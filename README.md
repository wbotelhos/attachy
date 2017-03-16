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

## Showing

If you want just show your uploaded image, use:

```html
<%= attachy_link :avatar, @object %>
```

It will generate a link to your image with the image inside.

## Transformation

You can manipulate the image using the `t` attribute:

```
<%= f.attachy :avatar, t: { width: 160, height: 160, crop: :fill } %>
```

To know more about transformations, check the [Cloudinary Doc](http://cloudinary.com/documentation/image_transformations).

## HTML

For HTML attributes, just use `html`:

```
<%= f.attachy :avatar, html: { width: 160, height: 160, alt: 'Image' } %>
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
