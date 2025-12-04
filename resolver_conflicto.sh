#!/bin/bash

echo "🔄 RESOLVIENDO CONFLICTO CON REPOSITORIO REMOTO"
echo "================================================"

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "🔍 Estado actual:"
git status
echo ""

echo "📥 Descargando cambios del repositorio remoto..."
echo "-------------------------------------------------"

# Opción 1: Pull con merge
echo "1. Intentando git pull (merge automático)..."
if git pull origin main --allow-unrelated-histories; then
    echo -e "${GREEN}✅ Pull exitoso${NC}"
else
    echo -e "${YELLOW}⚠️  Hay conflictos que resolver${NC}"
    
    # Ver archivos en conflicto
    echo ""
    echo "📄 Archivos en conflicto:"
    git diff --name-only --diff-filter=U
    
    echo ""
    echo "🔧 Para resolver conflictos:"
    echo "   git status                         # Ver conflictos"
    echo "   git diff                           # Ver diferencias"
    echo "   # Edita los archivos en conflicto"
    echo "   git add <archivos>                 # Marca como resueltos"
    echo "   git commit -m 'Resuelve conflictos'"
fi

echo ""
echo "📤 Intentando push después del pull..."
echo "--------------------------------------"

if git push origin main; then
    echo -e "${GREEN}🎉 ¡ÉXITO! Todo subido correctamente${NC}"
    echo ""
    echo "🌐 Ve a: https://github.com/Wasetica/consulta-registraduria"
    echo ""
    echo "📊 Estado final:"
    git status
else
    echo -e "${RED}❌ Aún hay problemas${NC}"
    echo ""
    echo "🔄 Opción 2: Forzar push (cuidado: sobreescribe remoto)"
    echo "¿Quieres forzar el push? (s/n)"
    read -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        echo "🚨 Forzando push..."
        if git push -u origin main --force; then
            echo -e "${GREEN}✅ Push forzado exitoso${NC}"
            echo "⚠️  Nota: Esto sobreescribió todo el historial remoto"
        else
            echo -e "${RED}❌ Error incluso forzando${NC}"
        fi
    fi
fi

echo ""
echo "✨ Proceso completado ✨"
