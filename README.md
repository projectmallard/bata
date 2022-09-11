# Bata - A CSS design language for documentation

Bata is a CSS design language for documentation built from semantic formats
like Mallard, Ducktype, DocBook, DITA, AsciiDoc, and reStructuredText. It
distills, simplifies, and modernizes the design elements and CSS from the
GNOME documentation system. Bata aims to make it easier for designers to
work with by taking it out of XSLT (which designers hate) and putting it
into Sass (which designers love).


## How do I build it?

Just run the `build.sh` script. It will output everything into the `_build`
directory, including test files in the `_build/test` directory.

You do need Inkscape installed as a Flatpak for the build script. If you
have it installed as a system package, modify the build script to change
`flatpak run org.inkscape.Inkscape` to just `inkscape`.


## How do I use it?

You can build the CSS and copy it into your project, but note that Bata is
not ready for production use yet. We definitely appreciate you trying it
out and submitting issues or pull requests.

There is some documentation embedded in the Sass files. Eventually, we
should extract, transform, and publish these. But for now, they're just
in the Sass files. You were going to look at the Sass files anyway tho,
weren't you?


## What's up with the icons?

Bata uses some icons for certain design elements. It inherits these from
GNOME, but they'll probably change. In an attempt to not have a collection
of files, we embed the icons as data URIs into the CSS. But nobody wants
to hand-edit SVGs, much less as data URIs. So the icons sit as standalone
SVG files under the `icons` directory. The build script munges them into
something that our Sass files can read and even recolor.

It's neat. There's probably a better solution, but it works.
