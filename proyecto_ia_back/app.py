from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
import pandas as pd

# Cargar el modelo
model = joblib.load("random_forest_model.joblib")

# Cargar los datos
df2 = pd.read_csv('df2.csv', low_memory=False)

app = Flask(__name__)
CORS(app)

@app.route('/unique_values/<feature>', methods=['GET'])
def unique_values(feature):
    if feature in df2.columns:
        unique_vals = df2[feature].astype(str).unique().tolist()
        unique_vals.sort()
        return jsonify({'unique_values': unique_vals})
    else:
        return jsonify({'error': 'Feature not found'}), 404
    
@app.route('/models/<string:marca>', methods=['GET'])
def get_models_by_brand(marca):
    try:
        # Filtra los modelos basados en la marca seleccionada
        filtered_models = df2[df2['MARCA'] == marca]['MODELO'].unique().tolist()
        filtered_models.sort()
        return jsonify(filtered_models)

    except Exception as e:
        return jsonify({'error': str(e)}), 500


@app.route('/predict', methods=['POST'])
def predict():
    # Obtener los datos del cuerpo de la solicitud
    data = request.json
    features = np.array(data['features']).reshape(1, -1)
    for i in range(0, len(features[0])):
        print(features[0][i])
    # Realizar la predicción
    # prediction = model.predict(features)
    # return jsonify({'prediction': prediction.tolist()})
    return jsonify({'prediction': [2000]})

@app.route('/')
def hello_world():
    return 'Hola Mundo'

if __name__ == '__main__':
    app.run(debug=True)
