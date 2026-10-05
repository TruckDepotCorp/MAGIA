#!/usr/bin/env bash
# Compatibilidad: v0.2.0 usaba este nombre. Ahora delega en guard-write.sh
# (mismo patrón de archivos sensibles + protección del Core).
exec bash "$(dirname "$0")/guard-write.sh"
