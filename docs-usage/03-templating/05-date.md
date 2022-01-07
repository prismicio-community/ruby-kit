# Templating the Date field

The Date field allows content writers to add a date that represents a calendar day.

## Get the date value

Here's how to get the value of a Date field.

```
@document["post.date"].value
```

## Output a simple date

The first way to display the date is to use the simple format: "YYYY/MM/DD".

Here's an example that shows how to do this using the `to_date` method.

```
<span class="date">
  <%= @document["post.date"].value.to_date %>
</span>
# Outputs in the following format: 2016/01/23
```

## Other date formats

You can control the format of the date value by using `strftime` method as shown below.

```
<span class="date">
  <%= @document["post.date"].value.strftime("%B %d, %Y") %>
</span>
# Outputs in the following format: January 23, 2016
```

For more formatting options, explore the [Ruby documentation for the strftime method](https://ruby-doc.org/stdlib-2.4.1/libdoc/date/rdoc/Date.html#method-i-strftime).
