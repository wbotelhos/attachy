/*!
 * Attachy - Attachments handler for Rails via Cloudinary
 *
 * The MIT License
 *
 * @author  : Washington Botelho
 * @doc     : http://wbotelhos.com/attachy
 * @version : 0.2.0
 *
 */

;
(function($) {
  'use strict';

  $.attachy = {
    crop:        undefined,
    disableWith: ' %',
    dropZone:    undefined,
    fieldName:   'avatar',
    height:      undefined,
    progress:    true,
    secure:      true,
    sequential:  true,
    sign_url:    true,
    url:         '/attachy/url',
    width:       undefined,

    link: {
      crop:   undefined,
      height: undefined,
      width:  undefined
    }
  }

  $.fn.attachy = function(options) {
    var settings = $.extend({}, $.attachy, options);

    return this.each(function() {
      return (new $.attachy.Attachy(this, settings)).create();
    });
  }

  $.attachy.Attachy = (function() {
    var Attachy = function(field, options) {
      this.field   = $(field);
      this.options = options;
    }

    Attachy.prototype = {
      add: function(file) {
        if (this.multiple) {
          this.files.push(file);
        } else {
          this.files = [file];
        }

        this.draw(file);
      },

      backupStatus: function() {
        this.submit.data('label', this.submit.text());
        this.button.data('label', this.button.text());
      },

      binds: function() {
        this.field.on('fileuploadsend', this.onUploading.bind(this));
        this.field.on('fileuploaddone', this.onDone.bind(this));
        this.field.on('fileuploadprogressall', this.onProgress.bind(this));
        this.field.on('fileuploadalways', this.onAlways.bind(this));

        this.content.on('click', '.attachy__remove', this.onRemove.bind(this));
      },

      configure: function() {
        var json = JSON.parse(this.hidden.val());

        if (!$.isArray(json)) {
          json = [json];
        }

        this.files    = json;
        this.multiple = this.content.data('multiple');
      },

      create: function() {
        this.scan();
        this.configure();
        this.init();
        this.backupStatus();
        this.binds();

        return this;
      },

      changeStatus: function(progress) {
        var label = progress + this.options.disableWith;

        this.submit.text(label);
        this.button.text(label);
      },

      draw: function(file) {
        var that = this;

        this.render(file, function(json) {
          var
            image  = that.image(file, json),
            link   = that.link(file, image, json),
            remove = that.removeButton();

          that.hideEmpty();

          if (that.multiple) {
            var node = $('<li />', { html: link, 'class': 'attachy__node' }).append(remove);

            that.content.append(node);
          } else {
            var item = that.content.find('li');
console.log(item.length);
            if (!item.length) {
              item = $('<li />', { html: link + remove, 'class': 'attachy__node' }).appendTo(that.content);
            }

            item.empty().append(link, remove);
          }
        });
      },

      hideEmpty: function() {
        this.empty.hide();
      },

      image: function(file, json) {
        var
          config     = this.imageConfig(file),
          attributes = { alt: config.alt, height: config.height, width: config.width };

        $.extend({}, attributes, config);

        if (this.options.sign_url) {
          attributes.src = json.image;
        } else {
          attributes.src = $.cloudinary.url(file.public_id, config);
        }

        return $('<img />', attributes);
      },

      imageConfig: function(file) {
        return {
          crop:     this.content.data('crop') || this.options.crop,
          format:   file.format,
          height:   this.content.data('height') || this.options.height,
          publicId: file.public_id,
          version:  file.version,
          width:    this.content.data('width') || this.options.width
        };
      },

      init: function() {
        this.field.fileupload({
          dataType:          'json',
          dropZone:          this.options.dropZone,
          headers:           { 'X-Requested-With': 'XMLHttpRequest' },
          sequentialUploads: this.options.sequential
        });

        this.field.cloudinary_fileupload();
      },

      link: function(file, image, json) {
        var attributes = { html: image, 'class': 'attachy__link' };

        if (this.options.sign_url) {
          attributes.href = json.link;
        } else {
          attributes.href = $.cloudinary.url(file.public_id, this.linkConfig(file));
        }

        return $('<a />', attributes);
      },

      linkConfig: function(file) {
        return {
          crop:    this.content.data('link-crop') || this.options.link.crop,
          format:  file.format,
          height:  this.content.data('link-height') || this.options.link.height,
          version: file.version,
          width:   this.content.data('link-width') || this.options.link.width
        }
      },

      onAlways: function() {
        this.wrapper.removeClass('attachy__uploading');

        this.restoreStatus();
      },

      onDone: function(_evt, data) {
        var file = data.result;

        this.add(file);

        this.updateHidden();
      },

      onProgress: function(_evt, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);

        if (this.options.progress && this.options.disableWith) {
          this.changeStatus(progress);
        }
      },

      onRemove: function(e) {
        var
          file,
          files = [],
          node  = $(e.currentTarget).closest('.attachy__node'),
          image = node.find('img');

        for (var i = 0; i < this.files.length; i++) {
          file = this.files[i];

          if (file.public_id !== image.data('publicId')) {
            files.push(file);
          }
        }

        node.remove();

        this.files = files;

        this.updateHidden();

        if (!this.files.length) {
          this.showEmpty();
        }
      },

      onUploading: function() {
        this.wrapper.addClass('attachy__uploading');
      },

      removeButton: function() {
        return $('<span />', { html: '&#215;', 'class': 'attachy__remove' });
      },

      render: function(file, callback) {
        if (this.options.sign_url) {
          var
            linkConfig = this.linkConfig(file),

            options = $.extend({}, {
              format:    file.format,
              public_id: file.public_id,
              secure:    this.options.secure,
              sign_url:  this.options.sign_url
            }, this.imageConfig(file));

          for (var key in linkConfig) {
            if (linkConfig.hasOwnProperty(key)) {
              options['link_' + key] = linkConfig[key];
            }
          }

          var ajax = $.ajax({ data: options, url: this.options.url });

          ajax.done(callback);

          ajax.fail(function(response) {
            alert(response.responseText);
          });
        } else {
          callback();
        }
      },

      restoreStatus: function() {
        this.submit.text(this.submit.data('label'));
        this.button.text(this.button.data('label'));
      },

      scan: function() {
        this.wrapper = this.field.closest('.attachy');
        this.button  = this.wrapper.find('.attachy__button span');
        this.content = this.wrapper.find('.attachy__content');
        this.empty   = this.wrapper.find('.attachy__empty');
        this.hidden  = this.wrapper.find('input[type="hidden"]');
        this.remove  = this.wrapper.find('.attachy__remove');
        this.submit  = this.wrapper.closest('form').find(':submit');
      },

      showEmpty: function() {
        this.empty.show();
      },

      updateHidden: function() {
        this.hidden.val(JSON.stringify(this.files));
      }
    };

    return Attachy;
  })();
})(jQuery);
