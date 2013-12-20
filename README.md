## Ruby development kit for prismic.io

[![Gem Version](https://badge.fury.io/rb/prismic.io.png)](http://badge.fury.io/rb/prismic.io)
[![Build Status](https://api.travis-ci.org/prismicio/ruby-kit.png)](https://travis-ci.org/prismicio/ruby-kit)
[![Code Climate](https://codeclimate.com/github/prismicio/ruby-kit.png)](https://codeclimate.com/github/prismicio/ruby-kit)

### Getting Started with the gem

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

#### Getting started with prismic.io

On our [prismic.io developer's portal](https://developers.prismic.io/), on top of the complete documentation, you will:
 * get a better understanding of [what prismic.io is and how to get started with it](https://developers.prismic.io/documentation/UjBaQsuvzdIHvE4D/getting-started).
 * get a thorough understanding of [how prismic.io kits work](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers), including this one. There's a couple of specificities for Ruby's case, described below.
 * see [what else is available for Ruby](https://developers.prismic.io/technologies/UjBh6MuvzeMJvE4m/ruby).

#### Kit documentation

To get a detailed documentation of the Ruby kit's variables and methods, please check out the [prismic.io Ruby kit's documentation](http://rubydoc.info/github/prismicio/ruby-kit/master/frames)

Need to see what changed, or to upgrade your kit? Check out [this kit's changelog](changelog.md).

##### Ruby kit's specificities

This Ruby kit contains some mild differences and syntastic sugar over [the "Kits and helpers" section of our API documentation](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers) (which you should read first). They are listed here:
 * When calling the API, a faster way to pass the `ref`: directly as a parameter of the `submit` method (no need to use the `ref` method then): `api.form("everything").submit(@ref)`.
 * Accessing type-dependent fields from a `document` is done through the `[]` operator (rather than a `get()` method). Printing the HTML version of a field therefore looks like `document["title_user_friendly"].as_html(link_resolver(@ref))`.
 * Two of the fields in the `DocumentLink` object (the one used to write your `link_resolver` method, for instance) were renamed to fit Ruby's best practice: `doc.type` is in fact `doc.link_type`, and `doc.isBroken` is in fact `doc.broken?`.

#### Use it

You can look at the [rails starter](https://github.com/prismicio/ruby-rails-starter) project to see how to use it :-)

### Licence

This software is licensed under the Apache 2 license, quoted below.

Copyright 2013 Zengularity (http://www.zengularity.com).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
