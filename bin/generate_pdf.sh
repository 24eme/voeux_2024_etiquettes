#!/bin/bash

SESSIONDATE=$(date +%Y%m%d%H%M%S)
QRCODEIMPRESSION_FILE=/tmp/qrcode_impression_$SESSIONDATE.csv

mkdir generate 2> /dev/null

echo -n > $QRCODEIMPRESSION_FILE

cat - | while read csvline;
do
  CUVEE=$(echo -n $csvline | cut -d ";" -f 1)
  HISTOIRE1=$(echo -n $csvline | cut -d ";" -f 2)
  HISTOIRE2=$(echo -n $csvline | cut -d ";" -f 3)
  RECTO=$(echo -n $csvline | cut -d ";" -f 4)
  VERSO=$(echo -n $csvline | cut -d ";" -f 5)
  QRCODE=$(echo -n $csvline | cut -d ";" -f 6)

  echo -n "https://nutri.vin/$QRCODE" | qrencode -d 300 -s 24 -m 0 --inline --svg-path -t SVG -o generate/"$QRCODE"_qrcode.svg
  QRCODESVG=$(cat generate/"$QRCODE"_qrcode.svg | sed 's/stroke:#000000//' | grep "path" | sed "s/\"/'/g")
  echo $csvline
  cat etiquettes/rectos/$RECTO | sed "s/%CUVEE%/$CUVEE/" > generate/"$QRCODE"_recto.svg
  cat etiquettes/versos/$VERSO | sed "s/%CUVEE%/$CUVEE/" | sed "s/%HISTOIRE1%/$HISTOIRE1/" | sed "s/%HISTOIRE2%/$HISTOIRE2/" | sed "s*%QRCODE%*$QRCODESVG*"> generate/"$QRCODE"_verso.svg
  echo $QRCODE >> $QRCODEIMPRESSION_FILE
done

NBPAGE=0

cat $QRCODEIMPRESSION_FILE | while read QRCODE;
do
  if ! test $QRCODE1; then
    QRCODE1=$QRCODE
  elif ! test $QRCODE2; then
    QRCODE2=$QRCODE
  elif ! test $QRCODE3; then
    QRCODE3=$QRCODE
  fi
  cat etiquettes/impression/impression.svg | sed "s/recto_1.svg/"$QRCODE1"_recto.svg/" | sed "s/verso_1.svg/"$QRCODE1"_verso.svg/" | sed "s/recto_2.svg/"$QRCODE2"_recto.svg/" | sed "s/verso_2.svg/"$QRCODE2"_verso.svg/" | sed "s/recto_3.svg/"$QRCODE3"_recto.svg/" | sed "s/verso_3.svg/"$QRCODE3"_verso.svg/"  > generate/impression_"$SESSIONDATE"_$(printf %03d $NBPAGE).svg
  inkscape generate/impression_"$SESSIONDATE"_$(printf %03d $NBPAGE).svg --export-type=pdf
  if test $QRCODE1 && test $QRCODE2 && test $QRCODE3; then
    NBPAGE=`expr $NBPAGE + 1`
    unset QRCODE1
    unset QRCODE2
    unset QRCODE3
  fi
done

sleep 3
pdftk generate/impression_"$SESSIONDATE"_*.pdf cat output generate/impression_"$SESSIONDATE".pdf

echo
echo
echo "PDF généré : generate/impression_"$SESSIONDATE".pdf"
