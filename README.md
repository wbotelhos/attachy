# Attachy

Attachments handler for Rails via http://cloudinary.com

## Description

Send files from your browser directly to Cloudinary.
Attachy will generate a `has_one` or `has_many` files (photos) to your model
with no need to change your model schema!

## Install

Extracts the necessary files including a migrate that create a table used
to keep your file metadata. You can choose a [Default Image](#default-image) via params 'version', `public_id` and 'format'.

```bash
rails g attachy:install
```

Then execute the migrations to create the `attachy_files` table.

```bash
rake db:migrate
```

## Usage

### Model

Upload a single image that will be overrided on each upload:

```ruby
class User < ApplicationRecord
  has_attachment :avatar
end
```

Upload a couple of images that will be added on each upload:

```ruby
class User < ApplicationRecord
  has_attachments :photos
end
```

### View

Expose your Cloudinary credentials on your layout:

```html
<%= cloudinary_js_config %>
```

Into your form, add the upload field:

```html
<%= f.attachy :avatar %>
```

### Assets

Includes the `attachy.js` on your js manifest:

```js
//= require attachy
```

Includes the `attachy.sass` on your css manifest:

```js
/*
 *= require attachy
 */
```

### <a name="default-image"></a> Configurations

On your `attachy.yml` you can configure a default image to show when model has no file attached:

```js
format: jpg
public_id: default
version: 42
```

## Transformations

To know more about transformations, check the [Cloudinary Doc](http://cloudinary.com/documentation/image_transformations).

## Helpers

### Attachy

```
<%= f.attachy :avatar,
  t:      { width: 160, height: 160, crop: :fill },
  tl:     { width: 800, height: 600, crop: :scale },
  button: { html: { text: 'Upload' } }
%>
```

+ `t`: image transformations;
+ `tl`: linked image transformations;
+ `button.html`: button html attributes.

```
<div class="attachy">
  <ul class="attachy__content">
    <li class="attachy__node">
      <a class="attachy__link" href="">
        <img src="">
      </a>

      <span class="attachy__remove">×</span>
    </li>
  </ul>

  <div class="attachy__button">
    <span>...</span>

    <input type="file" class="attachy__fileupload">

    <input value="[]" type="hidden">
  </div>
</div>
```

+ `attachy`: wrapper;
+ `attachy__content`: the file content;
+ `attachy__node`: each file of the content;
+ `attachy__link`: the link of some file;
+ `img`: the uploaded file;
+ `attachy__remove`: button to remove the image;
+ `attachy__button`: pseudo button to access the upload file button;
+ `span`: the label of the button;
+ `attachy__fileupload`: the upload file field;
+ `hidden`: the field that keeps hidden the files metadata as JSON.

## Link

It draws the link with the image inside:

```
<%= attachy_link :avatar, @object
  t:    { width: 160, height: 160, crop: :fill },
  tl:   { width: 800, height: 600, crop: :scale },
  html: { class: :added_custom }
%>
```

+ `t`: image transformations;
+ `tl`: linked image transformations;
+ `html`: link html attributes.

```
<a class="attachy__link" href="">
  <img src="">
</a>
```

### Image

It draws the link with the image inside:

```
<%= attachy_image :avatar, @object
  t:    { width: 160, height: 160, crop: :fill },
  html: { alt: :me }
%>
```

+ `t`: image transformations;
+ `html`: link html attributes.

```
<img src="https://res.cloudinary.com/account/image/upload/secret/version/hash.format">
```

## Test

Before send pull request, check if specs is passing.

```bash
rspec spec
```

## Code Style

Check if the code style is good.

```bash
rubocop --debug --display-cop-names
```
