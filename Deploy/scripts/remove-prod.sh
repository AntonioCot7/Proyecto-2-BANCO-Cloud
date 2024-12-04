#!/bin/bash

# Verificar si se pasa un stage, si no se usa "prod" como valor predeterminado
STAGE="${1:-prod}"

# Lista de servicios
services=(TABLA-CUENTA TABLA-PAGOS TABLA-PRESTAMOS TABLA-SOLICITUD-PRESTAMO TABLA-SOPORTE TABLA-TARJETAS TABLA-TOKENS_ACCESO TABLA-TRANSACCION TABLA-USUARIOS)

for service in "${services[@]}"
do
  echo "Removing $service from stage $STAGE..."

  cd $service

  # Ejecutar el remove para el stage especificado
  npx serverless remove --stage $STAGE
  
  cd ..  # Volver a la raíz del proyecto
done
