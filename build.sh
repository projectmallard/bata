#!/bin/sh

inkscape="flatpak run org.inkscape.Inkscape"

mkdir -p _build
mkdir -p _build/css
mkdir -p _build/icons
mkdir -p _build/sass
mkdir -p _build/test

themes=$(echo default $(ls -d themes/*/ | sed -e 's/\/$//' -e 's/.*\///'))

for theme in $themes; do
    mkdir -p _build/css/"$theme"
    mkdir -p _build/icons/"$theme"
    mkdir -p _build/sass/"$theme"
    mkdir -p _build/test/"$theme"
    for svg in icons/*.svg; do
        var=$(basename "$svg" .svg)
        tsvg="themes/$theme/$svg"
        sourcefile=""
        if [ -f "$tsvg" ]; then
            sourcefile="$tsvg"
        elif [ "$theme" = "default" ]; then
            sourcefile="$svg"
        else
            cp _build/icons/default/"$var".sass  _build/icons/"$theme"/"$var".sass 
        fi
        if [ "x$sourcefile" != "x" ]; then
            val=$($inkscape  "$svg" --export-type svg --export-plain-svg -o - \
                      | tr '\n' ' ' \
                      | sed -e 's/\s\+/ /g' \
                            -e 's/fill:[^;"]*/fill:%BATA_FILL%/g' \
                            -e 's/#/%23/g' \
               )
            echo "\$$var:'$val'" > _build/icons/"$theme"/"$var".sass
        fi
    done
    cat _build/icons/"$theme"/*.sass > _build/sass/"$theme"/_icons__data.sass

    if stat -t themes/"$theme"/*.sass >/dev/null 2>&1; then
        for sassfile in themes/"$theme"/*.sass; do
            cp "$sassfile" _build/sass/"$theme"/
        done
    fi
    for sassfile in bata/*.sass; do
        sassbase=$(basename "$sassfile")
        if [ ! -f themes/"$theme"/"$sassbase" ]; then
            cp "$sassfile" _build/sass/"$theme"/
        fi
    done

    sass _build/sass/"$theme"/bata.sass > _build/css/"$theme"/bata.css

    cp _build/css/"$theme"/bata.css _build/test/"$theme"/
    for htmlfile in test/*.html; do
        cp "$htmlfile" _build/test/"$theme"/
    done
        
    (
        echo '<html><head><title>Bata Test</title>'
        echo '<link rel="stylesheet" href="bata.css">'
        echo '<meta name="viewport" content="width=device-width, initial-scale=1">'
        echo '</head><body>'
        echo '<div class="container"><article>'
        echo '<h1>Bata Tests - '"$theme"'</h1>'
        echo '<ul>'
        for htmlfile in test/*.html; do 
            htmlbase=$(basename "$htmlfile" .html)
            echo '<li><a href="'"$htmlbase"'.html">'"$htmlbase"'</a></li>'
        done
        echo '</ul></article></div></body></html>'
    ) > _build/test/"$theme"/index.html

    (
        echo '<html><head><title>Bata Test</title>'
        echo '<link rel="stylesheet" href="default/bata.css">'
        echo '<meta name="viewport" content="width=device-width, initial-scale=1">'
        echo '</head><body>'
        echo '<div class="container"><article><h1>Bata Tests</h1>'
        echo '<ul>'
        for theme in $themes; do
            echo '<li><a href="'"$theme"'/index.html">'"$theme"'</a></li>'
        done
        echo '</ul></article></div></body></html>'
    ) > _build/test/index.html

done

