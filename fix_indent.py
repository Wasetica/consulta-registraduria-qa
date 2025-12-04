import sys

with open('consulta_simple.py', 'r') as f:
    lines = f.readlines()

# Encontrar y corregir la línea 66
if len(lines) >= 66:
    # La línea 66 (índice 65 en Python) debería empezar con 12 espacios (3 niveles)
    line_66 = lines[65]
    if line_66.strip().startswith('from selenium.webdriver.support.ui import WebDriverWait'):
        # Reindentar correctamente
        lines[65] = ' ' * 12 + 'from selenium.webdriver.support.ui import WebDriverWait\n'
    
    # También verificar la línea 67
    if len(lines) >= 67 and 'from selenium.webdriver.support import expected_conditions as EC' in lines[66]:
        lines[66] = ' ' * 12 + 'from selenium.webdriver.support import expected_conditions as EC\n'

with open('consulta_simple.py', 'w') as f:
    f.writelines(lines)

print("✅ Indentación corregida en consulta_simple.py")
