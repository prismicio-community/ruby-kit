# Templating Multi-language info

This page shows you how to access the language code and alternate language versions of a document.

## Get the document language code

Here is how to access the language code of a document queried from your prismic.io repository. This might give "en-us" (American english), for example.

```javascript
document.lang;
```

## Get the alternate language versions

Next we will access the information about a document's alternate language versions. You can loop through the `alternate_languages` array and access the id, uid, type, and language code of each as shown below.

```
document.alternate_languages.each do |lang, doc|
    id = doc.id
    uid = doc.uid
    type = doc.type
    doc_lang = lang
end
```

## Get a specific language version

If you need to get a specific alternate language version, pass the language code of the desired language into the `alternate_languages`\*\* \*\*array as shown below.

```
french_version = @document.alternate_languages["fr-fr"]
id = french_version.id
uid = french_version.uid
type = french_version.type
lang = french_version.lang
```
