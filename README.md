# Predicción de Avalúo de Vehículos Usados Ecuador
## Pasos para ejecutar el cuaderno Jupyter Notebook
1. Instalar las librerias necesarias ejecutando la celda que empieza de la siguiente forma:
- %pip install

2. Ejecutar cada una de las siguientes celdas en orden secuencial.

## Pasos para ejecutar el Backend
1. Ejecutar el siguiente comando en la terminal:
- pip install pandas joblib flask flask-cors

2. Abrir la terminal dentro de la carpeta proyecto_ia_back y ejecutar el comando:
- python app.py

## Pasos para ejecutar el Frontend
1. Intalar Flutter en VS Code:
- Windows: https://docs.flutter.dev/get-started/install/windows/web
- Linux: https://docs.flutter.dev/get-started/install/linux/web
- macOS: https://docs.flutter.dev/get-started/install/macos/web

2. Instalar la extensión de Flutter para VS Code (en caso de no haberlo hecho en el paso 1).

3. Abrir la terminal en Frontend\gestion_citas y ejecutar el comando:
- flutter run -d chrome --web-port=8080

## Archivos para realizar pruebas
- **proyecto_ia_front\df_test_10.csv**: Este archivo contiene 10 vehículos obtenidos del suconjunto de prueba.
- **proyecto_ia_front\df_test_30.csv**: Este archivo contiene 30 vehículos obtenidos del suconjunto de prueba.
- **proyecto_ia_front\df_test_1000.csv**: Este archivo contiene 1000 vehículos obtenidos del suconjunto de prueba.
- **proyecto_ia_front\df_test_incompleto.csv**: Este archivo contiene 10 vehículos obtenidos del suconjunto de prueba, pero le falta la columna "TIPO TRANSACCIÓN". La finalidad de este archivo es verificar que el sistema valida la estructura del dataset e informa las columnas faltantes si tuviese.