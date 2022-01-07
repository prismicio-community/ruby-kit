# Templating the Color field

The Color field allows content writers to select a color through a variety of color pickers as well as having the option to manually input a hex value.

## Get the hex color value

Here's how to get the hex value of a Color field.

```css
@document ["blog-post.color"].value
# Outputs as: efac26;
```

### An Example

Here is an example that retrieves a color value to style a blog post title.

```html
<% color = @document["blog-post.color"].value %>
<h2 style="color:#<%= color %>">Colorful Title</h2>
```

## Get the RGB value

Here is an example that converts the color to an RGB value by using the `asRGB` method.

```
@document["blog-post.color"].asRGB
# Outputs as: {"red"=>239, "green"=>172, "blue"=>38}
```
