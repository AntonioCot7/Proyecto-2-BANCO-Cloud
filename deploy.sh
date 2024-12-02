#!/bin/bash

# Lista de servicios
services=(TABLA-CUENTA TABLA-PAGOS TABLA-PRESTAMOS TABLA-SOLICITUD-PRESTAMO TABLA-SOPORTE TABLA-TARJETAS TABLA-TOKENS_ACCESO TABLA-TRANSACCION TABLA-USUARIOS)

for service in "${services[@]}"
do
  echo "Deploying $service..."

  cd $service
  
  if [[ "$service" == "TABLA-PRESTAMOS" || "$service" == "TABLA-SOLICITUD-PRESTAMO" || "$service" == "TABLA-SOPORTE" ]]; then

    if [ ! -f package.json ]; then
      echo "package.json no encontrado. Creando uno nuevo..."
      npm init -y
    fi
    echo "Running npm install in $service..."
    npm install
  fi

  npx serverless deploy
  
  cd ..
done
