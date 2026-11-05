#!/usr/bin/env bash
# Uso: ./bootstrap.sh [nome-do-host]
# Se não passar argumento tenta usar o hostname atual da máquina (`hostname`).

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

host="${1:-$(hostname)}"
nixflags=(--extra-experimental-features "nix-command flakes")
rebuildflags=(--option experimental-features "nix-command flakes")

# Log persistente inspirado no build.sh do github.com/Bad3r/nixos
log_dir="${XDG_STATE_HOME:-$HOME/.local/state}/nixos-bootstrap"
mkdir -p "$log_dir"
log_file="$log_dir/$(date +%Y%m%d-%H%M%S)-$host.log"
exec > >(tee -a "$log_file") 2>&1
echo "==> Log desta execução: $log_file"

if [[ ! -d "modules/hosts/$host" ]]; then
  echo "Host '$host' não existe em modules/hosts/. Hosts disponíveis:"
  ls modules/hosts
  exit 1
fi

untracked=$(git status --porcelain --ignored=no modules/hosts/"$host" | grep '^??' || true)
if [[ -n $untracked ]]; then
  echo "Aviso: há arquivos NÃO rastreados em modules/hosts/$host/:"
  echo "$untracked"
  echo "Rode 'git add' nos arquivos novos antes de continuar."
  exit 1
fi

echo "==> Checando o flake"
nix "${nixflags[@]}" flake check --no-build --no-write-lock-file

echo "==> Buildando o toplevel de '$host'"
# Build antes de switch inspirado no github.com/pedro-pereira-dev/nixfiles.
sudo nixos-rebuild build --flake ".#$host" "${rebuildflags[@]}"

echo
echo "Build pronto em ./result"
read -rp "Ativar agora com 'switch'? [s/N] " resp
if [[ $resp =~ ^[sSyY]$ ]]; then
  sudo nixos-rebuild switch --flake ".#$host" "${rebuildflags[@]}"
  echo
  echo "Switch feito. A partir de agora, use 'nh os switch .' para os próximos rebuilds."
  echo "Log salvo em: $log_file"
else
  echo "Não foi feito build. Para ativar rode o seguinte comando:"
  echo "sudo nixos-rebuild switch --flake .#$host --option experimental-features 'nix-command flakes'"
fi
