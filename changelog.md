## Changelog for prismic.io Ruby development kit


### prismic.io.1.0.0.preview.7

#### Potentially breaking changes
 * Boldness in `Prismic::Fragments::StructuredText#as_html` was represented as `<b>` tags, now as `<strong>` tags (262b5da9219cb990773a5b307f270f899b067ee5)

#### New features
 * You had to call `Prismic::Link_resolver#link_to` on a `Prismic::Fragments::DocumentLink` object, but sometimes, you actually have the full `Prismic::Document`; you can now call it on both types of objects (b1a53141e1a962762e00bd904a68d6fcd5c3a6bc).
 * You had to call `api.master_ref` to get the master ref; now you can call it `api.master`, just like in the other dev kits; both methods do the same thing (a9e11bbb735601734512a8cefca72ed29a6bdc81).
 * New method: `Prismic::Fragments::StructuredText#as_text`, renders zero formatting, and ignores images and embeds (d4c8c751a28afef4ef2c2e0d943cf8066ef3c039).
 * `Prismic::SearchForm` only had the `query` method to set the `q` parameter of the API call. Now those methods are dynamically created from the RESTful form found in the `/api` document, so it's now possible to use those methods too: `orderings`, `page`, `pageSize`, as well as all the future non-yet-existing ones (fcb4e3a92dbda1b6901a1065dcf0ef4144871fdd)


### prismic.io.1.0.0.preview.6

#### Potentially breaking changes
 * From an image, you had to call the view with its index, like this `image_object[0]`; now they're stored in a Hash, you have to call them with their proper name: `image_object['large']` (e6312b8d4486c8eacb1de7214563d45c61b5653c).