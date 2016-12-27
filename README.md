# Wheelhouse

Wheelhouse is a tiny "static" site scaffold. Wheelhouse lets you use ERB templates, and will minify Sass and JS while you work.

### Development Prerequisites

- Ruby 2 (install with `brew`, `rbenv`, `ruby-install`, or the like)
- Bundler (`gem install bundler`)
- [Heroku Toolbelt](https://toolbelt.heroku.com)

### Starting a New Project

[Download this repo as a zip file][zip]. Then extract it.

[zip]: https://github.com/Threespot/wheelhouse/archive/master.zip

Rename the folder and change to it.

```shell
mv wheelhouse-master myapp
cd myapp
```

Create a Git repo.

```shell
git init
```

Install the Ruby dependencies with bundler:

```shell
bundle install --path ./vendor/bundle
```

Provide some environment settings, which live in `.env`

```
echo "RACK_ENV=development" >> .env
echo "WEB_CONCURRENCY=1" >> .env
echo "PORT=8080" >> .env
```

Start the server:

```shell
foreman start
```

You can now develop on <http://0.0.0.0:8080>. Minified FE assets are built while you work. Hit <kbd>Ctrl</kbd>+<kbd>C</kbd> to stop the server.

### Deploying to Heroku

Commit your work:

```shell
git add --all
git commit -m "Initial commit"
```

Deploy it to Heroku:

```shell
heroku apps:create
heroku addons:add memcachier:dev
heroku config:set RACK_ENV=production PUMA_WORKERS=4
git push heroku master
heroku open
```

### More About The Project Structure

`public` is the site root for all things like `favicon.ico` and friends. Files in `public` are served verbatim.

`templates/index` is the document root for HTML views.

Image assets live in `/assets/images` and are available to HTML at `/assets/`

Sass lives in `/assets/stylesheets/` and it is built and minified for HTML at `/assets/`.

The JavaScript lives in `/assets/javascripts/` and it is built and minified for HTML at `/assets/`.

### Using ERB

You have Ruby and a basic templating system available to you. You can factor out reusable HTML code into templates, and include it as a partial.

```erb
<h1>Page Title</h1>
<%= render "shared/header" %>
```

Ruby can save you a lot of FE time, vis-à-vis repletion and random content generation. For example, you can repeat parts of code:

```erb
<% 5.times do %>
  <li>My list item</li>
<% end %>
```

Or use a random string on each page load:

```erb
<h2><%= ["Sollicitudin", "Consectetur", "Sem"].sample %></h2>
```

Also check out the documentation for [Sprockets](https://github.com/sstephenson/sprockets)

### HTTP Basic Auth

Specify the credentials in the Heroku config, and you’re all set. Visitors will be required to enter the specified username and password to view the site.

```shell
heroku config:set HTTP_USERNAME=username HTTP_PASSWORD=password
heroku open
```

### Force visitors onto a specific domain

Specify the domain in the Heroku config, and you’re all set. Visitors will be 301-redirected onto the correct domain.

```shell
heroku domains:add www.example.com
heroku config:set DOMAIN=www.example.com
heroku open
```

### Force TLS/HTTPS

Set the `FORCE_HTTPS` environment variable.

```shell
heroku config:set FORCE_HTTPS=true
heroku open
```
