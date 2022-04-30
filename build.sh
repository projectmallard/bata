#!/bin/sh

mkdir -p _build
mkdir -p _build/css
mkdir -p _build/icons/default
mkdir -p _build/sass/default

for svg in icons/*.svg; do
    var=$(basename "$svg" .svg)
    val=$(flatpak run org.inkscape.Inkscape "$svg" --export-type svg --export-plain-svg -o - \
              | tr '\n' ' ' \
              | sed -e 's/\s\+/ /g' \
                    -e 's/fill:[^;"]*/fill:%BATA_FILL%/g' \
                    -e 's/#/%23/g' \
       )
    echo "\$$var:'$val'" > _build/icons/default/"$var".sass
done

cat _build/icons/default/*.sass > _build/sass/default/_icons__data.sass

sass -I _build/sass/default/ bata/bata.sass > _build/css/bata.css

for themedir in themes/*/; do
    theme=$(basename "$themedir")
    mkdir -p _build/sass/"$theme"
    for sassfile in bata/*.sass; do
        sassbase=$(basename "$sassfile")
        if [ -f "$themedir/$basename" ]; then
            cp "$themedir/$basename" _build/sass/"$theme"/
        else
            cp "$sassfile" _build/sass/"$theme"/
        fi
    done
    sass -I _build/sass/default/ bata/bata.sass > _build/css/bata-"$theme".css
done

cp _build/css/bata.css test/bata.css
