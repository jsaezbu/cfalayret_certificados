#!/bin/bash

# Interfaz Bash para la gestión de certificados en MultiversX
# Utiliza mxpy para interactuar con el smart contract certificados_mvx
# Autor: Profesor de Informática
# Fecha: 2025

# ======================= CONFIGURACIÓN INICIAL =======================
CONTRACT_ADDRESS="erd1qqqqqqqqqqqqqpgq4zyp4jt5vyhc4ehn37r34je7e87cpdmlvj0qjsgaj2" # Dirección real del smart contract
PEM_PATH="$HOME/wallet.pem" # Ruta al archivo PEM de la wallet del emisor
PROXY="https://devnet-gateway.multiversx.com"
CHAIN="D"

# ======================= FUNCIÓN: Expedir un nuevo certificado =======================
expedir_certificado() {
  echo "Introduce el hash (huella) del certificado PDF (en texto, por ejemplo, el hash SHA256):"
  read hash_certificado
  echo "Introduce la dirección de wallet del alumno (empieza por erd1...):"
  read direccion_alumno

  # Llama al endpoint expedir_certificado del smart contract
  mxpy contract call $CONTRACT_ADDRESS \
    --pem $PEM_PATH \
    --proxy $PROXY \
    --chain $CHAIN \
    --function expedir_certificado \
    --arguments "str:$hash_certificado" addr:$direccion_alumno \
    --gas-limit 50000000 \
    --send

  echo "Certificado emitido (transacción enviada a la blockchain)."
}

# ======================= FUNCIÓN: Listar todos los hashes de certificados emitidos =======================
listar_certificados() {
  echo "Listando todos los hashes de certificados emitidos:"
  mxpy contract query $CONTRACT_ADDRESS \
    --function listar_certificados \
    --proxy $PROXY \
    
}

# ======================= FUNCIÓN: Comprobar si un certificado es válido =======================
comprobar_certificado() {
  echo "Introduce el hash (huella) del certificado PDF a comprobar:"
  read hash_certificado

  mxpy contract query $CONTRACT_ADDRESS \
    --function es_certificado_valido \
    --arguments "str:$hash_certificado" \
    --proxy $PROXY \
    
}

# ======================= MENÚ PRINCIPAL =======================
while true; do
  echo ""
  echo "===== Gestión de Certificados Blockchain (MultiversX) ====="
  echo "1. Expedir un nuevo certificado"
  echo "2. Listar todos los certificados emitidos"
  echo "3. Comprobar validez de un certificado"
  echo "4. Salir"
  echo "Selecciona una opción:"
  read opcion

  case $opcion in
    1) expedir_certificado ;;
    2) listar_certificados ;;
    3) comprobar_certificado ;;
    4) echo "¡Hasta luego!"; exit 0 ;;
    *) echo "Opción no válida, por favor elige 1-4." ;;
  esac
done
