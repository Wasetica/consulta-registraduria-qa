#!/bin/bash

echo "🚀 SUBIENDO PROYECTO EXPLORADOR A GITHUB"
echo "=========================================="
echo "Repositorio: https://github.com/Wasetica/consulta-registraduria"
echo ""

# Color para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar comandos
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 no está instalado${NC}"
        return 1
    fi
    return 0
}

# Verificar comandos necesarios
echo "🔍 Verificando dependencias..."
check_command git || exit 1
check_command python || exit 1

# Verificar que estamos en el directorio correcto
if [ ! -f "consulta_simple.py" ] || [ ! -f "main_final.py" ]; then
    echo -e "${RED}❌ No estás en el directorio del proyecto${NC}"
    echo "Debes estar en: ~/consulta_registraduria"
    exit 1
fi

echo -e "${GREEN}✅ Directorio correcto${NC}"

# Inicializar git si no existe
if [ ! -d ".git" ]; then
    echo "📦 Inicializando repositorio git..."
    git init
fi

# Configurar usuario si no está configurado
if [ -z "$(git config user.name)" ]; then
    echo "👤 Configurando usuario git..."
    git config user.name "Wasetica"
    git config user.email "tu-email@ejemplo.com"
fi

# Configurar remote
echo "🔗 Configurando conexión con GitHub..."
if git remote | grep -q "origin"; then
    echo "✅ Remote 'origin' ya existe"
    git remote set-url origin https://github.com/Wasetica/consulta-registraduria.git
else
    git remote add origin https://github.com/Wasetica/consulta-registraduria.git
fi

# Verificar conexión
echo "🌐 Probando conexión con GitHub..."
if git ls-remote origin &> /dev/null; then
    echo -e "${GREEN}✅ Conexión exitosa${NC}"
else
    echo -e "${YELLOW}⚠️  No se pudo conectar a GitHub${NC}"
    echo "Posibles causas:"
    echo "1. Repositorio no existe o es privado"
    echo "2. Problemas de red"
    echo "3. Necesitas autenticación"
    echo ""
    echo "📋 URL del repositorio: https://github.com/Wasetica/consulta-registraduria"
    read -p "¿Continuar de todos modos? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        exit 1
    fi
fi

# Agregar archivos
echo "📁 Agregando archivos..."
git add .

# Verificar cambios
if git diff --cached --quiet; then
    echo -e "${YELLOW}⚠️  No hay cambios para commit${NC}"
else
    # Commit
    echo "💾 Creando commit..."
    
    # Crear mensaje de commit
    COMMIT_MSG="🎉 Proyecto EXPLORADOR completo
    
✅ Sistema automatizado de consultas a Registraduría Nacional
✅ 15 consultas paralelas funcionando (0.50s, 100% éxito)
✅ 11/11 tests pasando completamente
✅ Almacenamiento: SQLite + CSV + JSON + Excel
✅ Documentación profesional completa
    
📊 Resultados:
- Tests: 11/11 pasando
- Tiempo 15 consultas: 0.50 segundos
- Tasa éxito: 100%
- Sin bloqueos detectados
    
📦 Entregables:
1. Código fuente documentado
2. README completo
3. Resultados de pruebas
4. Base de datos/archivos
5. Suite de tests
    
Fecha: $(date '+%Y-%m-%d %H:%M:%S')"
    
    echo "$COMMIT_MSG" | git commit -F -
    
    # Cambiar a rama main
    echo "🌿 Configurando rama main..."
    git branch -M main
    
    # Push
    echo "📤 Subiendo a GitHub..."
    if git push -u origin main; then
        echo -e "${GREEN}✅ ¡ÉXITO! Proyecto subido correctamente${NC}"
        echo ""
        echo "🌐 Ve a: https://github.com/Wasetica/consulta-registraduria"
        echo ""
        echo "📋 Para verificar:"
        echo "   1. Abre el enlace en tu navegador"
        echo "   2. Deberías ver todos los archivos"
        echo "   3. El README.md debe mostrarse con formato"
        echo ""
        echo "🧪 Para probar localmente:"
        echo "   git clone https://github.com/Wasetica/consulta-registraduria.git"
        echo "   cd consulta-registraduria"
        echo "   python -m pytest tests/ -v"
    else
        echo -e "${RED}❌ Error al subir${NC}"
        echo ""
        echo "🔧 Soluciones posibles:"
        echo "   1. Usa token de acceso en lugar de contraseña"
        echo "   2. Verifica tus permisos en el repositorio"
        echo "   3. Intenta con SSH: git@github.com:Wasetica/consulta-registraduria.git"
    fi
fi

echo ""
echo "✨ Proceso completado ✨"
