## Ruby development kit for prismic.io

[![Gem Version](https://badge.fury.io/rb/prismic.io.png)](http://badge.fury.io/rb/prismic.io)
[![Build Status](https://api.travis-ci.org/prismicio/ruby-kit.png)](https://travis-ci.org/prismicio/ruby-kit)
[![Code Climate](https://codeclimate.com/github/prismicio/ruby-kit.png)](https://codeclimate.com/github/prismicio/ruby-kit)

### Getting Started

#### Install the kit for your project

*(Assuming that [Ruby is installed](https://www.ruby-lang.org/en/downloads/) on your computer, as well as [RubyGems](http://rubygems.org/pages/download))*


To install the gem on your computer, run in shell:

```sh
gem install prismic.io --pre
```
then add in your code:
```ruby
require 'prismic'
```

To add the gem as a dependency to your project with [Bundler](http://bundler.io/), you can add this line in your Gemfile:

```ruby
gem 'prismic.io', require: 'prismic'
```

#### Get started with prismic.io

You can find out [how to get started with prismic.io](https://developers.prismic.io/documentation/UjBaQsuvzdIHvE4D/getting-started) on our [prismic.io developer's portal](https://developers.prismic.io/).

#### Get started using the kit

Also on our [prismic.io developer's portal](https://developers.prismic.io/), on top of our full documentation, you will:
 * get a thorough introduction of [how to use prismic.io kits](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers), including this one.
 * see [what else is available for Ruby](https://developers.prismic.io/technologies/UjBh6MuvzeMJvE4m/ruby): starter projects, examples, ...

### Using the kit

#### Kit's detailed documentation

To get a detailed documentation of the Ruby kit's variables and methods, please check out the [prismic.io Ruby kit's documentation](http://rubydoc.info/github/prismicio/ruby-kit/master/frames).

#### Specific Ruby kit syntax

Thanks to Ruby's syntax, this kit contains some mild differences and syntastic sugar over [the "Kits and helpers" section of our API documentation](https://developers.prismic.io/documentation/UjBe8bGIJ3EKtgBZ/api-documentation#kits-and-helpers) in general (which you should read first). They are listed here:

 * When calling the API, a faster way to pass the `ref`: directly as a parameter of the `submit` method (no need to use the `ref` method then): `api.form("everything").submit(@ref)`.
 * Accessing type-dependent fields from a `document` is done through the `[]` operator (rather than a `get()` method). Printing the HTML version of a field therefore looks like `document["title_user_friendly"].as_html(link_resolver(@ref))`.
 * Two of the fields in the `DocumentLink` object (the one used to write your `link_resolver` method, for instance) were renamed to fit Ruby's best practice: `doc.type` is in fact `doc.link_type`, and `doc.isBroken` is in fact `doc.broken?`.
 * You don't need to pass a `ctx` object in `as_html()`, you can use the `Prismic.link_resolver` static method to build a link resolver object that takes the `ref` into account, like this: `@link_resolver = Prismic.link_resolver(@ref) { |doc| ...  }`. Then you can simply go: `fragment.as_html(@link_resolver)`. Note: the Rails starter kit provides you with a helper allowing you to pass the ref each time you call the link resolver, like this: `fragment.as_html(link_resolver(@ref))`.

Knowing all that, here is typical code written with the Ruby kit:

 * A typical API object instantiation looks like this: `Prismic.api(url, opts)`
 * A typical querying looks like this: `api.form('everything').query('[[:d = at(document.type, "product")]]').submit(@ref)`
 * A typical fragment manipulation looks like this: `doc['article.image'].get_view('icon').url`
 * A typical fragment serialization to HTML looks like this: `doc['article.body'].as_html(@link_resolver)`

### Changelog

Need to see what changed, or to upgrade your kit? We keep our changelog on [this repository's "Releases" tab](https://github.com/prismicio/ruby-kit/releases).

### Contribute to the kit

Contribution is open to all developer levels, read our "[Contribute to the official kits](https://developers.prismic.io/documentation/UszOeAEAANUlwFpp/contribute-to-the-official-kits)" documentation to learn more.

#### Install the kit locally

Of course, you're going to need [Ruby installed](https://www.ruby-lang.org/en/downloads/) on your computer, as well as [RubyGems](http://rubygems.org/pages/download) and [Bundler](http://bundler.io/).

Clone the kit, then run ```bundle install```.

#### Test

Please write tests for any bugfix or new feature, by placing your tests in the [spec/](spec/) folder, following the [RSpec](http://rspec.info/) syntax. Launch the tests by running ```bundle exec rspec```

If you find existing code that is not optimally tested and wish to make it better, we really appreciate it; but you should document it on its own branch and its own pull request.

#### Documentation

Please document any bugfix or new feature, using the [Yard](http://yardoc.org/) syntax. Don't worry about generating the doc, we'll take care of that.

If you find existing code that is not optimally documented and wish to make it better, we really appreciate it; but you should document it on its own branch and its own pull request.

### Licence

This software is licensed under the Apache 2 license, quoted below.

Copyright 2013 Zengularity (http://www.zengularity.com).

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
