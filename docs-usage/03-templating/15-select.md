# Templating the Select field

The Select field will add a dropdown select box of choices for the content authors to pick from.

## Get the Select field text value

The following example shows how to retrieve the value of a Select field.

```
<p class="category">
  <%= @document["article.category"].value %>
</p>
```
