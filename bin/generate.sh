#!/bin/bash

CUVEE=$1
HISTOIRE1=$2
HISTOIRE2=$3

cat etiquettes/recto_grappe.svg | sed "s/%CUVEE%/$CUVEE/" > generate/000000000000_recto_grappe.svg
cat etiquettes/recto_grappe.svg | sed "s/%CUVEE%/$CUVEE/" > generate/000000000000_recto_grappe.svg

echo -n "https://nutri.vin/000000000001" | qrencode -d 300 -s 24 -m 0 --inline --svg-path -t SVG -o generate/000000000000_qrcode.svg
QRCODE=$(cat generate/000000000000_qrcode.svg | grep "path" | sed "s/\"/'/g")
cat etiquettes/verso.svg | sed "s/%CUVEE%/$CUVEE/" | sed "s/%HISTOIRE1%/$HISTOIRE1/" | sed "s/%HISTOIRE2%/$HISTOIRE2/" | sed "s*%QRCODE%*$QRCODE*"> generate/000000000000_verso.svg
