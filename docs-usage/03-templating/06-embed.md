# Templating the Embed field

The Embed field will let content authors paste an oEmbed supported service resource URL (YouTube, Vimeo, Soundcloud, etc.), and add the embeded content to your website.

## Display as HTML

Here's an example of how to integrate the Embed field into your templates using the `as_html` method.

```
<%= @document["page.embed"].as_html.html_safe %>
```

## Get the Embed type

The following shows how to retrieve the Embed type from an Embed field.

```
@document["page.embed"].embed_type
# For example this might return: video
```

## Get the Embed provider

The following shows how to retrieve the Embed provider from an Embed field.

```
@document["page.embed"].provider
# For example, this might return: YouTube
```

## Get the Embed JSON data

You can also retrieve the JSON object that contains all the information about the Embed object.

The `o_embed_json` method will return the JSON data.

```
@document["page.embed"].o_embed_json
```

Here's what a typical Embed JSON object would look like.

```
{
  "height" => 270,
  "author_name" => "RickAstleyVEVO",
  "thumbnail_height" => 360,
  "thumbnail_url" => "https://i.ytimg.com/vi/dQw4w9WgXcQ/hqdefault.jpg",
  "width" => 480,
  "html" => "<iframe width=\"480\" height=\"270\" src=\"https://www.youtube.com/embed/dQw4w9WgXcQ?feature=oembed\" frameborder=\"0\" allowfullscreen></iframe>",
  "author_url" => "https://www.youtube.com/user/RickAstleyVEVO",
  "provider_name" => "YouTube", "thumbnail_width" => 480,
  "type" => "video",
  "version" => "1.0",
  "provider_url" => "https://www.youtube.com/",
  "title" => "Rick Astley - Never Gonna Give You Up",
  "embed_url" => "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
}
```
