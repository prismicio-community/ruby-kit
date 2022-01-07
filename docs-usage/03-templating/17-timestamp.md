# Templating the Timestamp field

The Timestamp field allows content writers to add a date and time.

## Get the Timestamp value

Here's how to get the value of a Timestamp field.

```
@document["event.date"].value
```

## Output the default date & time

The first way to display the Timestamp is to use the default format.

Here's an example that shows how to do this by simply outputting the Timestamp value.

```
<span>
  <%= @document["event.date"].value %>
</span>
# Outputs in the following format: 2016-01-23 13:30:00 +0000
```

## Other date formats

You can control the format of the Timestamp value by using `strftime` method as shown below.

```
<span class="event-date">
  <%= @document["event.date"].value.strftime("%A %b %d, %I:%M %P") %>
</span>
# Outputs in the following format: Saturday Jan 23, 01:30 pm
```

For more formatting options, explore the [Ruby documentation for the strftime method](https://ruby-doc.org/stdlib-2.4.1/libdoc/date/rdoc/Date.html#method-i-strftime).
