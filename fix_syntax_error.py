import re

# Leer el archivo
with open('consulta_simple.py', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Buscar la sección problemática (alrededor de línea 50-70)
inicio_correccion = -1
for i, line in enumerate(lines):
    if 'def iniciar_navegador(self):' in line:
        inicio_correccion = i
        break

if inicio_correccion != -1:
    # Encontrar el try
    for i in range(inicio_correccion, len(lines)):
        if 'try:' in lines[i]:
            # Ahora necesitamos encontrar el bloque completo del try
            indentacion = len(lines[i]) - len(lines[i].lstrip())
            
            # Reconstruir la sección corregida
            corrected_section = []
            in_try_block = False
            j = i
            
            while j < len(lines):
                current_line = lines[j]
                current_indent = len(current_line) - len(current_line.lstrip())
                
                if 'try:' in current_line:
                    corrected_section.append(current_line)
                    in_try_block = True
                elif in_try_block and current_indent <= indentacion:
                    # Terminó el bloque try, agregar except
                    corrected_section.append(' ' * indentacion + 'except ImportError as e:\n')
                    corrected_section.append(' ' * (indentacion + 4) + 'logger.error(f"❌ Dependencias faltantes: {e}")\n')
                    corrected_section.append(' ' * (indentacion + 4) + 'logger.info("📦 Instala: pip install selenium webdriver-manager")\n')
                    corrected_section.append(' ' * (indentacion + 4) + 'return False\n')
                    corrected_section.append(' ' * indentacion + 'except Exception as e:\n')
                    corrected_section.append(' ' * (indentacion + 4) + 'logger.error(f"❌ Error iniciando navegador: {e}")\n')
                    corrected_section.append(' ' * (indentacion + 4) + 'return False\n')
                    corrected_section.append(current_line)
                    in_try_block = False
                else:
                    corrected_section.append(current_line)
                
                j += 1
                if j >= len(lines):
                    break
            
            # Reemplazar la sección
            lines = lines[:i] + corrected_section
            break

# Limpiar líneas duplicadas
cleaned_lines = []
previous_line = ""
for line in lines:
    stripped = line.strip()
    if stripped == "from selenium.webdriver.support.ui import WebDriverWait":
        if previous_line != "from selenium.webdriver.support.ui import WebDriverWait":
            cleaned_lines.append(line)
    elif stripped == "from selenium.webdriver.support import expected_conditions as EC":
        if previous_line != "from selenium.webdriver.support import expected_conditions as EC":
            cleaned_lines.append(line)
    else:
        cleaned_lines.append(line)
    previous_line = stripped

# Guardar archivo corregido
with open('consulta_simple_corregido.py', 'w', encoding='utf-8') as f:
    f.writelines(cleaned_lines)

print("✅ Archivo corregido guardado como: consulta_simple_corregido.py")
print("💡 Ejecuta: mv consulta_simple_corregido.py consulta_simple.py")
