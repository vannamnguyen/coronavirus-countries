#!/bin/bash

cd $(dirname $0)
mkdir -p data

for typ in confirmed deaths; do
  curl -sL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_global.csv > data/time_series_covid19_${typ}_global.csv
done;

for typ in confirmed deaths testing; do
  curl -sL https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_${typ}_US.csv > data/time_series_covid19_${typ}_US.csv
done;

./export-main-countries.py

if git diff data/*.csv | grep . > /dev/null; then
  echo "Data updated!"
  ts=$(date +%s)
  sed -i 's/"##LASTUPDATE##"/'$ts'/' data/coronavirus-countries.json
  git commit -m "update data" data/
  git push
else
  git checkout -- data/coronavirus-countries.json
fi
