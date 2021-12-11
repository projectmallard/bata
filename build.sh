#!/bin/sh

for svg in icons/*.svg; do
    var=$(basename "$svg" .svg)
    val=$(flatpak run org.inkscape.Inkscape "$svg" --export-type svg --export-plain-svg -o - \
              | tr '\n' ' ' \
              | sed -e 's/\s\+/ /g' \
                    -e 's/fill:[^;"]*/fill:%BATA_FILL%/g' \
                    -e 's/#/%23/g' \
       )
    echo "\$$var:'$val'"
done > _icons__data.sass

sass bata.sass test/bata.css
