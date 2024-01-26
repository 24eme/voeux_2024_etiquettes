#!/bin/bash

mkdir -p generate/etiquettes 2> /dev/null

csvline=$1

CUVEE=$(echo -n $csvline | cut -d ";" -f 1)
HISTOIRE1=$(echo -n $csvline | cut -d ";" -f 2)
HISTOIRE2=$(echo -n $csvline | cut -d ";" -f 3)
RECTO=$(echo -n $csvline | cut -d ";" -f 4)
VERSO=$(echo -n $csvline | cut -d ";" -f 5)
QRCODE=$(echo -n $csvline | cut -d ";" -f 6)

echo -n "https://nutri.vin/$QRCODE" | qrencode -d 300 -s 24 -m 0 --inline --svg-path -t SVG -o generate/etiquettes/"$QRCODE"_qrcode.svg
QRCODESVG=$(cat generate/etiquettes/"$QRCODE"_qrcode.svg | sed 's/stroke:#000000//' | grep "path" | sed "s/\"/'/g")
echo $csvline
cat etiquettes/rectos/$RECTO | sed "s/%CUVEE%/$CUVEE/" > generate/etiquettes/"$QRCODE"_recto.svg
cat etiquettes/versos/$VERSO | sed "s/%CUVEE%/$CUVEE/" | sed "s/%HISTOIRE1%/$HISTOIRE1/" | sed "s/%HISTOIRE2%/$HISTOIRE2/" | sed "s*%QRCODE%*$QRCODESVG*"> generate/etiquettes/"$QRCODE"_verso.svg
