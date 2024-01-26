#!/bin/bash

mkdir -p generate/pages 2> /dev/null

cat - | while read csvline;
do
  QRCODE=$(echo -n $csvline | cut -d ";" -f 6)
  CUVEE=$(echo -n $csvline | cut -d ";" -f 1)
  bash bin/generate_etiquette.sh "$csvline"
  ETIQUETTESVG_BASE64=$(cat generate/etiquettes/"$QRCODE"_recto.svg | base64 -w 0)
  BOUTEILLESVG_BASE64=$(echo "s|%RECTO_BASE64%|$ETIQUETTESVG_BASE64|" | sed -f - templates/bouteille_brute_rouge_etiquette.svg | base64 -w 0)
  echo "s|bouteille_brute_rouge.svg|data:image/svg+xml;base64,$BOUTEILLESVG_BASE64|" | sed -f - templates/index.html | sed "s/%CUVEE%/$CUVEE/" > generate/pages/$QRCODE.html
done
