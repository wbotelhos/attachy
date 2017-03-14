# Attachy

Attachments handler for Rails via Cloudinary

## Desciption

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
  has_attachment :avatar # use singular
end
```

Upload a couple of images that will be added on each upload:

```ruby
class User < ApplicationRecord
  has_attachments :photos # use plural
end
```

### View

Expose your Cloudinary credentials on your layout:

```html
<%= cloudinary_js_config %>
```

Into your form add an upload placeholder:

```html
<div class="attachy">
  <ul class="attachy__content">
    <li>
      <%= image_tag f.object.cover.path %>
    </li>
  </ul>

  <div class="attachy__button">
    <span>Upload</span>

    <%= cl_image_upload_tag :avatar %>
  </div>

  <%= f.hidden_field :avatar, value: f.object.avatar.to_json %>
</div>
```

### Assets

Includes the `attachy.js` on your js manifest:

```js
//= require vendor/attachy
```

Includes the `attachy.sass` on your css manifest:

```js
/*
 *= require vendor/attachy
 */
```

### <a name="default-image"></a> Configurations

On your `attachy.yml` configure a default image to show when model has no one:

```js
format: jpg
public_id: default
version: 42
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
