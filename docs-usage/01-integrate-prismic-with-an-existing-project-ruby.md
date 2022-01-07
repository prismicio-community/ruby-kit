# Integrate Prismic with an existing project

If you already have a Ruby project that you want to integrate with Prismic, then you can simply add the Prismic Ruby development kit library as a dependency. Let's walk through all the steps to get Prismic integrated into your project!

## 1. Create a content repository

A content repository is where you define, edit and publish content.

[**Create a new repository**](https://prismic.io/dashboard/new-repository/)

Next you'll need to model your content, create your custom types, and publish some documents to your repository.

Now, let's take a look at how to connect this new content with your project.

## 2. Add the development kit as a dependency

Let's add the Prismic Ruby kit as a dependency to your project.

> Note: you will need to have both [Ruby](https://www.ruby-lang.org/en/downloads/) and [RubyGems](https://rubygems.org/pages/download) installed on your computer.

Launch the terminal (command prompt or similar on Windows), point it to your project location and run the following command.

```bash
gem install prismic.io --pre
```

## 3. Require the prismic gem

To add the gem as a dependency to your project with [Bundler](http://bundler.io/), you can add the following line in your Gemfile.

```bash
gem 'prismic.io', require: 'prismic'
```

## 4. Get the API and query your content

Now we can query your Prismic repository and retrieve the content as shown below.

```ruby
api = Prismic.api('https://your-repo-name.cdn.prismic.io/api')
response = api.query(Prismic::Predicates.at("document.type", "page"))
documents = response.results
```

If you are using a private repository, then you'll need to include your access token like this.

```ruby
url = 'https://your-repo-name.cdn.prismic.io/api'
token = 'MC5XUkynrnlvQUFIdVViSElaE--_ve-_ve-_vUUece71r77-9FgXvv73vv73uu73v'
api = Prismic.api(url, token)
response = api.query(Prismic::Predicates.at("document.type", "page"))
documents = response.results
```

To learn more about querying the API and explore the many ways to retrieve your content, check out the [How to Query the API](../02-query-the-api/01-how-to-query-the-api.md) page.

### Pagination of API Results

When querying a Prismic repository, your results will be paginated. By default, there are 20 documents per page in the results. You can read more about how to manipulate the pagination in the [Pagination for Results](../02-query-the-api/16-pagination-for-results.md) page.

## 5. Add the queried content to your templates

Once you've retrieved your content, you can include it in your template using the helper functions in the Ruby development kit. Here's a simple example.

```html
<div class="content">
   
  <h1><%= @document['page.title'].as_text() %></h1>
   <img src="<%= @document['page.image'].url %>" />
   <%= @document['page.description'].as_html(nil).html_safe %>
</div>
```

You can read more about templating your content in the Templating section of the documentation. There you will find explanations and examples of how to template each content field type.

## 6. Take advantage of Previews and the Prismic Toolbar

In order to take full advantage of Prismic's features, check out the[ Previews and the Prismic Toolbar](../04-beyond-the-api/02-previews-and-the-toolbar.md) page. There you will find the steps needed to add these features to your own Ruby app.

## And your Prismic journey begins!

You should have all the tools now to really dig into your Ruby project. We invite you to further explore the docs to learn how to define your Custom Types, query the API, and add your content to your templates.
