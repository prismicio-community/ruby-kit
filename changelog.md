## Changelog for prismic.io Ruby development kit

### prismic.io.1.0.0.preview.8

#### New features
 * Support for group fragments.
 * Support for unknown fragments (instead of crashing, ignores the fragment with a warning advising to update the kit).

#### Syntactic sugar
 * `Prismic::API#create_search_form` is now `Prismic::API#form` (the former issues a deprecation warning, and will be removed in a later release); the online cross-tech doc was adapted to reflect that possibility.

### prismic.io.1.0.0.preview.7

#### Potentially breaking changes
 * Boldness in `Prismic::Fragments::StructuredText#as_html` was represented as `<b>` tags, now as `<strong>` tags.

#### New features
 * You had to call `Prismic::Link_resolver#link_to` on a `Prismic::Fragments::DocumentLink` object, but sometimes, you actually have the full `Prismic::Document`; you can now call it on both types of objects.
 * You had to call `api.master_ref` to get the master ref; now you can call it `api.master`, just like in the other dev kits; both methods do the same thing.
 * New method: `Prismic::Fragments::StructuredText#as_text`, renders zero formatting, and ignores images and embeds.
 * `Prismic::SearchForm` only had the `query` method to set the `q` parameter of the API call. Now those methods are dynamically created from the RESTful form found in the `/api` document, so it's now possible to use those methods too: `orderings`, `page`, `pageSize`, as well as all the future non-yet-existing ones.


### prismic.io.1.0.0.preview.6

#### Potentially breaking changes
 * From an image, you had to call the view with its index, like this `image_object[0]`; now they're stored in a Hash, you have to call them with their proper name: `image_object['large']`.