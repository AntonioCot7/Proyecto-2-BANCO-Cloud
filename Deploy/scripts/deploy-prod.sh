#!/bin/bash

# Verificar si se pasa un stage, si no se usa "prod" como valor predeterminado
STAGE="${1:-prod}"

# Lista de servicios
services=(TABLA-CUENTA TABLA-PAGOS TABLA-PRESTAMOS TABLA-SOLICITUD-PRESTAMO TABLA-SOPORTE TABLA-TARJETAS TABLA-TOKENS_ACCESO TABLA-TRANSACCION TABLA-USUARIOS)

# Directorio base donde están las carpetas de las tablas
BASE_DIR="../"  # Ajusta este valor si la estructura es diferente

for service in "${services[@]}"
do
  echo "Deploying $service to stage $STAGE..."

  # Cambiar al directorio del servicio usando una ruta relativa
  cd "$BASE_DIR$service"

  # Para ciertos servicios, instalar dependencias si no existen
  if [[ "$service" == "TABLA-PRESTAMOS" || "$service" == "TABLA-SOLICITUD-PRESTAMO" || "$service" == "TABLA-SOPORTE" ]]; then
    if [ ! -f package.json ]; then
      echo "package.json no encontrado. Creando uno nuevo..."
      npm init -y
    fi
    echo "Running npm install in $service..."
    npm install
    npm install uuid
    npm install aws-sdk
  fi

  # Ejecutar deploy para el stage especificado
  npx serverless deploy --stage $STAGE
  
  # Volver al directorio de la carpeta deploy
  cd "$BASE_DIR"  # Regresar a la carpeta deploy

done
