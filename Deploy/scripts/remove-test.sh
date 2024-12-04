#!/bin/bash

# Verificar si se pasa un stage, si no se usa "test" como valor predeterminado
STAGE="${1:-test}"

# Lista de servicios (las tablas)
services=(TABLA-CUENTA TABLA-PAGOS TABLA-PRESTAMOS TABLA-SOLICITUD-PRESTAMO TABLA-SOPORTE TABLA-TARJETAS TABLA-TOKENS_ACCESO TABLA-TRANSACCION TABLA-USUARIOS)

for service in "${services[@]}"
do
  echo "Removing resources for $service in stage $STAGE..."

  # Cambiar al directorio del servicio
  cd "../$service"  # Retroceder un nivel y entrar a la carpeta del servicio

  # Eliminar recursos usando Serverless para el stage especificado
  npx serverless remove --stage $STAGE

  # Volver al directorio de "deploy" después de cada eliminación
  cd "../deploy"
done
