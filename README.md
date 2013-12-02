## Ruby development kit for prismic.io

[![Gem Version](https://badge.fury.io/rb/prismic.io.png)](http://badge.fury.io/rb/prismic.io)
[![Build Status](https://api.travis-ci.org/prismicio/ruby-kit.png)](https://travis-ci.org/prismicio/ruby-kit)
[![Code Climate](https://codeclimate.com/github/prismicio/ruby-kit.png)](https://codeclimate.com/github/prismicio/ruby-kit)

### Getting Started

#### Install using bundler

You can this line in your Gemfile:

```ruby
gem 'prismic.io', require: 'prismic'
```

#### Install manually

Run in shell:

```sh
gem install prismic.io --pre
```

then add in your code:

```ruby
require 'prismic'
```

#### Documentation

There are two ways to get a better understanding at the kit:
 * to get a global overview how to use a prismic.io kit the best way, you can check out [our cross-technology documentation for kits](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers), on prismic.io developers' portal. The Ruby kit's API has specificities in a couple of places, that are listed below.
 * to get a detailed documentation of the Ruby kit's variables and methods, please check out the [prismic.io Ruby kit's documentation](http://prismicio.github.io/ruby-kit/) (click on the "Class list" tab at the top-right)

##### Ruby kit's specificities

This Ruby kit contains some mild differences or tips over [the "Kits and helpers" section of our API documentation](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers), which sets general information about how our kits work. They are listed here:
 * Retrieving the master ref from the API object is gotten by `api.master_ref` (rather than `api.master`).
 * From the api object, getting a form is done through the `create_search_form` method; a basic querying therefore looks like this: `api.create_search_form("everything").query(%([[:d = at(document.type, "product")]])).ref(@ref).submit()`.
 * When calling the API, a faster way to pass the `ref`: directly as a parameter of the `submit` method (no need to use the `ref` method then): `api.create_search_form("everything").submit(@ref)`.
 * Accessing type-dependent fields from a `document` is done through a `fragments` hash (rather than a `get()` method). Printing the HTML version of a field therefore looks like `document.fragments["title_user_friendly"].as_html(link_resolver(@ref)).html_safe`.
 * Two of the fields in the `DocumentLink` object (the one used to write your `link_resolver` method, for instance) were renamed to fit Ruby's best practice: `doc.type` is in fact `doc.link_type`, and `doc.isBroken` is in fact `doc.broken?`.

#### Use it

You can look at the [rails starter](https://github.com/prismicio/ruby-rails-starter) project to see how to use it :-)

### Licence

This software is licensed under the Apache 2 license, quoted below.

Copyright 2013 Zengularity (http://www.zengularity.com).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
