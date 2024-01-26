#!/bin/bash

SESSIONDATE=$(date +%Y%m%d%H%M%S)
QRCODEIMPRESSION_FILE=/tmp/qrcode_impression_$SESSIONDATE.csv

mkdir -p generate/impressions 2> /dev/null

echo -n > $QRCODEIMPRESSION_FILE

cat - | while read csvline;
do
  QRCODE=$(echo -n $csvline | cut -d ";" -f 6)
  bash bin/generate_etiquette.sh "$csvline"
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
  cat etiquettes/impression/impression.svg | sed "s#recto_1.svg#../etiquettes/"$QRCODE1"_recto.svg#" | sed "s#verso_1.svg#../etiquettes/"$QRCODE1"_verso.svg#" | sed "s#recto_2.svg#../etiquettes/"$QRCODE2"_recto.svg#" | sed "s#verso_2.svg#../etiquettes/"$QRCODE2"_verso.svg#" | sed "s#recto_3.svg#../etiquettes/"$QRCODE3"_recto.svg#" | sed "s#verso_3.svg#../etiquettes/"$QRCODE3"_verso.svg#"  > generate/impressions/impression_"$SESSIONDATE"_$(printf %03d $NBPAGE).svg
  inkscape generate/impressions/impression_"$SESSIONDATE"_$(printf %03d $NBPAGE).svg --export-type=pdf
  if test $QRCODE1 && test $QRCODE2 && test $QRCODE3; then
    NBPAGE=`expr $NBPAGE + 1`
    unset QRCODE1
    unset QRCODE2
    unset QRCODE3
  fi
done

sleep 3
pdftk generate/impressions/impression_"$SESSIONDATE"_*.pdf cat output generate/impressions/impression_"$SESSIONDATE".pdf

echo
echo
echo "PDF généré : generate/impressions/impression_"$SESSIONDATE".pdf"
