# Link Resolver

When working with field types such as [Link](../03-templating/11-links-content-relationship.md) or [Rich Text](../03-templating/14-rich-text-title.md), the prismic.io Ruby kit will need to generate links to documents within your website.

> **Before Reading**
>
> This page assumes that you have retrieved your content and stored it in a variable named `document`.

Since routing is specific to your site, you will need to define your Link Resolver and provide it to some of the methods used on the fields.

## Adding the Link Resolver function

If you are incorporating prismic.io into your existing Ruby project or using the Ruby on Rails starter project, you will need to create a Link Resolver.

Here is an example that shows how to add a Link Resolver function.

```
def link_resolver()
  @link_resolver ||= Prismic::LinkResolver.new(nil) {|link|

    # URL for the category type
    if link.type == "category"
      "/category/" + link.uid

    # URL for the product type
    elsif link.type == "product"
      "/product/" + link.id

    # Default case for all other types
    else
      "/"
    end
  }
end
```

> A Link Resolver is provided in the [Ruby on Rails starter project](https://github.com/prismicio/ruby-rails-starter), but you may need to adapt it or write your own depending on how you've built your website app.
>
> The Link Resolver can be found in the `app/helpers/prismic_helper.rb` file of the Ruby on Rails starter.

## Accessible attributes

When creating your link resolver function, you will have access to certain attributes of the linked document.

| Property                                                | Description                                             |
| ------------------------------------------------------- | ------------------------------------------------------- |
| <strong>link.id</strong><br/><code>string</code>        | <p>The document id</p>                                  |
| <strong>link.uid</strong><br/><code>string</code>       | <p>The user-friendly unique id</p>                      |
| <strong>link.type</strong><br/><code>string</code>      | <p>The custom type of the document</p>                  |
| <strong>link.tags</strong><br/><code>array</code>       | <p>Array of the document tags</p>                       |
| <strong>link.lang</strong><br/><code>string</code>      | <p>The language code of the document</p>                |
| <strong>link.isBroken</strong><br/><code>boolean</code> | <p>Boolean that states if the link is broken or not</p> |
