#!/bin/bash

# Directorio donde se encuentran los scripts
SCRIPT_DIR="$(pwd)/scripts"

# Lista de los scripts de despliegue
scripts=("deploy-dev.sh" "deploy-prod.sh" "deploy-test.sh")

# Función para verificar y aplicar chmod
check_and_chmod() {
  for script in "${scripts[@]}"
  do
    script_path="$SCRIPT_DIR/$script"
    if [ -f "$script_path" ]; then
      if [ ! -x "$script_path" ]; then
        echo "$script_path no tiene permisos de ejecución, aplicando chmod..."
        chmod +x "$script_path"
      else
        echo "$script_path ya tiene permisos de ejecución."
      fi
    else
      echo "$script_path no encontrado."
    fi
  done
}

# Llamar a la función para verificar los permisos
check_and_chmod

# Ejecutar los tres scripts de despliegue
echo "Ejecutando $SCRIPT_DIR/deploy-prod.sh..."
$SCRIPT_DIR/deploy-prod.sh

echo "Ejecutando $SCRIPT_DIR/deploy-test.sh..."
$SCRIPT_DIR/deploy-test.sh

echo "Ejecutando $SCRIPT_DIR/deploy-dev.sh..."
$SCRIPT_DIR/deploy-dev.sh

echo "Todos los recursos han sido desplegados."
