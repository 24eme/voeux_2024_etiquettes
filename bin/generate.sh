#!/bin/bash

CUVEE=$1
HISTOIRE1=$2
HISTOIRE2=$3

ls etiquettes/rectos | while read template; do
  cat etiquettes/rectos/$template | sed "s/%CUVEE%/$CUVEE/" > generate/000000000000_$template
done;

echo -n "https://nutri.vin/000000000001" | qrencode -d 300 -s 24 -m 0 --inline --svg-path -t SVG -o generate/000000000000_qrcode.svg
QRCODE=$(cat generate/000000000000_qrcode.svg | sed 's/stroke:#000000//' | grep "path" | sed "s/\"/'/g")

ls etiquettes/versos | while read template; do
  cat etiquettes/versos/$template | sed "s/%CUVEE%/$CUVEE/" | sed "s/%HISTOIRE1%/$HISTOIRE1/" | sed "s/%HISTOIRE2%/$HISTOIRE2/" | sed "s*%QRCODE%*$QRCODE*"> generate/000000000000_$template
done;
