# Templating the Number field

The Number field allows content writers to enter or select a number. You can set set max and min values for the number.

## Get the number value

Here is an example of how to simply retrieve the value of the Number field and insert it into your template.

```
<span><%= @document["article.statistic"].value %></span>
```

## Control the number of decimal places

Here we see how to control the number of decimal places to ensure that our price looks right.

```
<% price = @document["product.price"].value %>
<h3 class="price">
  $<%= number_with_precision( price, precision: 2 ) %>
</h3>
```

## Convert to an integer

Here we see how we can convert the number to an integer.

```
<span><%= @document["page.number"].as_int %></span>
```
