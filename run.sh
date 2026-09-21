#!/usr/bin/env bash
# ============================================================================
#  run.sh -> Detecta el sistema operativo y ejecuta el install correspondiente.
#            macOS  -> install.sh
#            Linux  -> install_linux.sh
#            Antes de ejecutar verifica que la key de git este configurada.
# ============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------------
#  Verificacion de la key de git (SSH contra GitHub)
# ----------------------------------------------------------------------------
git_key_ok() {
  ssh -o BatchMode=yes \
      -o StrictHostKeyChecking=accept-new \
      -o ConnectTimeout=10 \
      -T git@github.com 2>&1 | grep -qi "successfully authenticated"
}

echo "verificando key de git..."
if git_key_ok; then
  echo "key de git OK"
else
  # No esta la key: mostramos cartel y esperamos respuesta.
  while true; do
    echo ""
    echo "########################################################"
    echo "#  No se detecta la key de git configurada en GitHub.  #"
    echo "#  Agregala antes de continuar.                        #"
    echo "########################################################"
    printf "ya lo agregaste ? [y/n] "
    read -r ans
    case "$ans" in
      [yY])
        # Apreto 'y': no re-chequea, sigue y ejecuta.
        echo "ok, continuando..."
        break
        ;;
      [nN])
        # Apreto 'n': sigue esperando (vuelve a preguntar).
        echo "esperando a que agregues la key..."
        ;;
      *)
        echo "responde y o n."
        ;;
    esac
  done
fi

# ----------------------------------------------------------------------------
#  Deteccion de SO y ejecucion del installer
# ----------------------------------------------------------------------------
os="$(uname -s)"
echo "detected OS: $os"

case "$os" in
  Darwin)
    echo "running macOS installer (install.sh)"
    exec bash "$SCRIPT_DIR/install.sh"
    ;;
  Linux)
    echo "running Linux installer (install_linux.sh)"
    exec bash "$SCRIPT_DIR/install_linux.sh"
    ;;
  *)
    echo "unsupported OS: $os"
    echo "solo hay instaladores para macOS (Darwin) y Linux."
    exit 1
    ;;
esac
