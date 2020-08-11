#!/bin/bash
echo "***********************************************************************"
echo "***********************************************************************"
echo "Este script no tiene validaciones, procure hacer todo sin errores"
echo ""
echo "Si cometió algún error, ejecute: [git reset --hard] y vuelva a empezar"
echo "***********************************************************************"
echo "***********************************************************************"
echo ""
echo "1. Escriba nombre del store para su entorno ej: icbc,spv,tclic,bbva,galicia: "
echo ""
read STORE
echo ""
echo "2. Escriba puerto HTTP [un numero entre 1000 y 99999] evite usar el 9000"
echo ""
read PORTHTTP
echo ""
echo "3. Escriba puerto HTTPS (no puede ser igual al anterior)"
echo ""
read PORTHTTPS
echo ""
echo "4. Para Prestashop 1.6 escriba 1, Prestashop 1.7 escriba 2"
echo ""
read VERSION
echo ""

P16=1
p17=2

  if [[ $VERSION = "1" ]]; then
    cat etc/sourceFiles/Dockerfile71 >> etc/php/Dockerfile
  fi
  if [[ $VERSION = "2" ]]; then
    cat etc/sourceFiles/Dockerfile73 >> etc/php/Dockerfile
  fi

  cat etc/sourceFiles/.env.example >> .env
  sed -i 's/_STORE_NAME_/'"$STORE"'/g' .env
  sed -i 's/_PORT_HTTP_/'"$PORTHTTP"'/g' .env
  sed -i 's/_PORT_HTTPS_/'"$PORTHTTPS"'/g' .env
  sed -i 's/_PORT_HTTPS_/'"$PORTHTTPS"'/g' etc/nginx/default.conf
  mkdir www/

  chown -R $USUARIO. www
  cat etc/sourceFiles/index.php >> www/index.php

echo "************************************************************************"
echo "************************************************************************"
echo "Desea construir su entorno ya? Escriba 1 para SI || Escriba 2 para NO)"
read CONSTR
echo "************************************************************************"
echo "************************************************************************"

if [[ $CONSTR = "1" ]]; then
  docker-compose up --build -d

  echo "************************************************************************"
  echo "************************************************************************"
  echo ""
  echo "Al terminar la construcción abra en el explorador la url: https://localhost:$PORTHTTPS"
  echo ""
  echo "Si ve: Connected successfully - OK, presione 1"
  echo ""
  read ISFINE
  echo ""
  echo "************************************************************************"
  echo "************************************************************************"
  if [[ $ISFINE = "1" ]]; then

    chown -R $USUARIO. www
    rm www/index.php

    echo "************************************************************************"
    echo "************************************************************************"

    echo " $$$$$ Exito, empiece a migrar su proyecto al directorio www $$$$$$"
    
    echo "************************************************************************"
    echo "************************************************************************"
  fi
fi