# Templating the Geopoint field

The GeoPoint field is used for Geolocation coordinates. It works by adding coordinates or by pasting a Google Maps URL.

## Get the latitude and longitude values

Here's an example of how to retrieve the latitude the longitude values from the GeoPoint field.

```
latitude = @document["store.location"].latitude
longitude = @document["store.location"].longitude
```
