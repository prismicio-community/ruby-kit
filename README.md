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

#### Kit Documentation

You should check out [the "Kits and helpers" section of our API documentation](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers), which sets general information about how our kits work. The Ruby kit is mostly compliant with it, but contains some mild differences:

 * The api object's type is Prismic::API, and the name of the method to retrieve the master ref is gotten by `api.master_ref`.
 * There's no `ctx` object to pass around; the context is passed in different ways.
 * From the api object, getting a form is done through the `create_search_form` method; a basic querying therefore looks like this: `api.create_search_form("everything").query("[[:d = at(document.type, \"product\")]]").submit(ref)`
 * Advice: the `%()` Ruby notation for strings is great for queries, as they may include quotes and/or double-quotes. The above querying is therefore even better this way: `api.create_search_form("everything").query(%([[:d = at(document.type, "product")]])).submit(ref)`
 * Accessing type-dependent fields from a `document` is done through a `fragments` hash. Printing the HTML version of a field therefore looks like `document.fragments["title_user_friendly"].as_html(link_resolver(ref)).html_safe`.

#### Use it

You can look at the [rails starter](https://github.com/prismicio/ruby-rails-starter) project to see how to use it :-)

### Licence

This software is licensed under the Apache 2 license, quoted below.

Copyright 2013 Zengularity (http://www.zengularity.com).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
