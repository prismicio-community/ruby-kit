## Ruby development kit for prismic.io

[![Gem Version](https://badge.fury.io/rb/prismic.io.png)](http://badge.fury.io/rb/prismic.io)
[![Build Status](https://api.travis-ci.org/prismicio/ruby-kit.png)](https://travis-ci.org/prismicio/ruby-kit)

### Getting Started

The prismic kit is compatible with Ruby 1.9.3 or later.

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

#### Get started

- [developer documentation](https://prismic.io/docs)
- [quickstart](https://prismic.io/quickstart)
- [API reference](http://prismicio.github.io/ruby-kit/)

The quickstart is not available for Ruby yet, but if you understand Javascript you can easily adapt the code.

#### Configuring Alternative API Caches

The default cache stores data in-memory, in the server. You may want to use a different cache, for example to share it between several servers (with memcached or similar). A null cache (does no caching) is also available if you need a predictible behavior for testing or VCR. To use it (or any other compliant cache), simply add `api_cache: Prismic::BasicNullCache.new` to the options passed to `Prismic.api`.

### Changelog

Need to see what changed, or to upgrade your kit? We keep our changelog on [this repository's "Releases" tab](https://github.com/prismicio/ruby-kit/releases).

#### Install the kit locally

Of course, you're going to need [Ruby installed](https://www.ruby-lang.org/en/downloads/) on your computer, as well as [RubyGems](http://rubygems.org/pages/download) and [Bundler](http://bundler.io/).

Clone the kit, then run `bundle install`.

#### Test

Please write tests for any bugfix or new feature, by placing your tests in the [spec/](spec/) folder, following the [RSpec](http://rspec.info/) syntax. Launch the tests by running `rspec`

If you find existing code that is not optimally tested and wish to make it better, we really appreciate it; but you should document it on its own branch and its own pull request.

#### Documentation

Please document any bugfix or new feature, using the [Yard](http://yardoc.org/) syntax. Don't worry about generating the doc, we'll take care of that.

If you find existing code that is not optimally documented and wish to make it better, we really appreciate it; but you should document it on its own branch and its own pull request.


### Contributing

We hope you'll get involved! Read our [Contributors' Guide](/CONTRIBUTING.md) for details.


### Licence

This software is licensed under the Apache 2 license, quoted below.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
