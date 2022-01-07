# HTML Serializer

You can customize the HTML output of a Rich Text Field by incorporating an HTML Serializer into your project. This allows you to do things like adding custom classes to certain elements or modifying the way an element will be displayed.

## Adding the HTML Serializer function

To be able to modify the HTML output of a Rich Text, you need to first create the HTML Serializer function.

It will need to identify the element by type and return the desired output.

> Make sure to add a default case that returns `null`. This will leave all the other elements untouched.

Here is an example of an HTML Serializer that will prevent image elements from being wrapped in paragraph tags and add a custom class to all hyperlink and paragraph elements.

```
html_serializer = Prismic.html_serializer do |element, html|

  case element

  # Add a custom class to paragraph elements
  when Prismic::Fragments::StructuredText::Block::Paragraph
    %(<p class="paragraph-class">#{html}</p>)

  # Don't wrap images in a <p> tag
  when Prismic::Fragments::StructuredText::Block::Image
    %(<img src="#{element.url}" alt="#{element.alt}" width="#{element.width}" height="#{element.height}" />)

  # Add a custom class to hyperlinks
  when Prismic::Fragments::StructuredText::Span::Hyperlink
    link = element.link
    target = link.target.nil? ? "" : 'target="' + link.target + '" rel="noopener"'
    if link.is_a? Prismic::Fragments::DocumentLink and link.broken
      "<span>#{html}</span>"
    else
      %(<a class="link-class" href="#{link.url(link_resolver)}" #{target}>#{html}</a>)
    end

  # Return nil to stick with the default behavior
  else
    nil

  end
end
```

## Using the serializer function

To use it, all you need to do is pass the Serializer function into the `as_html` method for a Rich Text element. Make sure to pass it in as the second parameter, the first being for the [Link Resolver](../04-beyond-the-api/01-link-resolving.md).

```
<%= @document["page.body_text"].as_html(link_resolver, html_serializer).html_safe %>
```

## Example with all elements

Here is an example that shows you how to change all of the available Rich Text elements.

```
html_serializer = Prismic.html_serializer do |element, html|

  case element

  # Embed
  when Prismic::Fragments::StructuredText::Block::Embed
    %(<div data-oembed="#{element.url}" data-oembed-type="#{element.embed_type.downcase}" data-oembed-provider="#{element.provider.downcase}">#{element.html}</div>)

  # Emphasis
  when Prismic::Fragments::StructuredText::Span::Em
    %(<em>#{html}</em>)

  # Headings
  when Prismic::Fragments::StructuredText::Block::Heading
    %(<h#{element.level}>#{html}</h#{element.level}>)

  # Hyperlink
  when Prismic::Fragments::StructuredText::Span::Hyperlink
    link = element.link
    target = link.target.nil? ? "" : 'target="' + link.target + '" rel="noopener"'
    if link.is_a? Prismic::Fragments::DocumentLink and link.broken
      "<span>#{html}</span>"
    else
      %(<a href="#{link.url(link_resolver)}" #{target}>#{html}</a>)
    end

  # Image
  when Prismic::Fragments::StructuredText::Block::Image
    classes = ['block-img']
    unless element.label.nil?
      classes.push(element.label)
    end
    link = element.link_to
    html = %(<img src="#{element.url}" alt="#{element.alt}" width="#{element.width}" height="#{element.height}" />)
    unless link.nil?
      target = link.target.nil? ? '' : 'target="' + link.target + '" rel="noopener"'
      html = %(<a href="#{link.url(link_resolver)}" #{target}>#{html}</a>)
    end
    %(<p class="#{classes.join(' ')}">#{html}</p>)

  # Label
  when Prismic::Fragments::StructuredText::Span::Label
    %(<span class=\"#{element.label}\">#{html}</span>)

  # List Item
  when Prismic::Fragments::StructuredText::Block::ListItem
    %(<li>#{html}</li>)

  # Paragraph
  when Prismic::Fragments::StructuredText::Block::Paragraph
    %(<p>#{html}</p>)

  # Preformatted
  when Prismic::Fragments::StructuredText::Block::Preformatted
    %(<pre>#{html}</pre>)

  # Strong
  when Prismic::Fragments::StructuredText::Span::Strong
    %(<strong>#{html}</strong>)

  # Default case returns nil
  else
    nil
  end

end
```
