# Unsplash Extension For Quarto

Add [https://www.unsplash.com](Unsplash) images to your content using a simple shortcode. The Unsplash extension will select an image at random, or will use keywords to select a random image related to a particular topic. For example:

```         
{{< unsplash dog.jpg >}}
```

Will replace the shortcode with a randomly selected image of a dog from [https://www.unsplash.com](Unsplash).

## Installing

``` bash
quarto add dragonstyle/unsplash
```

This will install the extension under the `_extensions` subdirectory. If you're using version control, you will want to check in this directory.

## Using

The unsplash short supports the following options (each of which is optional):

```         
{{< unsplash [filename] keywords=[keywords] height=[height] width=[width] class=[class] float=[float] >}}
```

**`filename`** (optional)

If you provide a file name or path, the randomly selected image will be written to that location and will be used for any subsequent rendering. The filename will also be used as a keyword hint if keywords are not provided. For example, the shortcode `{{< unsplash dog.jpeg >}}` will random select a dog image from Unsplash and store it next to the input document.

If you omit the `filename`, a new image will be downloaded each time the document is rendered.

**`keywords`** (optional)

You can provide a single keyword or a comma delimited list of keywords that will be used when randomly selecting an image. If keywords are not provided, the `filename` stem will be used as a keyword. If no `keywords` and no `filename` are provided, a random image will be selected.

**`height`** (optional)
The height of the image. This will be used both when requesting the image (to attempt to find a suitable image) and when outputting the rendered image in the document.

**`width`** (optional)
The width of the image. This will be used both when requesting the image (to attempt to find a suitable image) and when outputting the rendered image in the document.

**`class`** (optional)
Classes to apply to the image container (the image is placed inside a div to control sizing without scaling the image, so the classes will be applied to that container).

**`float`** (optional)
The float style of the image container (`left`, `right`, `center`).

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).
