import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import numpy as np
import pandas as pd

# Cargar el modelo
model = joblib.load("random_forest_model.joblib")

# Cargar los datos
df2 = pd.read_csv('df2.csv', low_memory=False)
dict_marca = df2.loc[:, ["MARCA", "MARCA_encoded"]].drop_duplicates().reset_index(drop=True)
dict_modelo = df2.loc[:, ["MODELO", "MODELO_encoded"]].drop_duplicates().reset_index(drop=True)
dict_tipo_combustible = df2.loc[:, ["TIPO COMBUSTIBLE", "TIPO COMBUSTIBLE_encoded"]].drop_duplicates().reset_index(drop=True)
dict_clase = df2.loc[:, ["CLASE", "CLASE_encoded"]].drop_duplicates().reset_index(drop=True)
dict_canton = df2.loc[:, ["CANTÓN", "CANTÓN_encoded"]].drop_duplicates().reset_index(drop=True)
dict_pais = df2.loc[:, ["PAÍS", "PAÍS_encoded"]].drop_duplicates().reset_index(drop=True)
dict_color1 = df2.loc[:, ["COLOR 1", "COLOR 1_encoded"]].drop_duplicates().reset_index(drop=True)
dict_tipo_persona = df2.loc[:, ["PERSONA NATURAL - JURÍDICA", "PERSONA NATURAL - JURÍDICA_encoded"]].drop_duplicates().reset_index(drop=True)
dict_tipo = df2.loc[:, ["TIPO", "TIPO_encoded"]].drop_duplicates().reset_index(drop=True)
dict_tipo_servicio = df2.loc[:, ["TIPO SERVICIO", "TIPO SERVICIO_encoded"]].drop_duplicates().reset_index(drop=True)
dict_tipo_transaccion = df2.loc[:, ["TIPO TRANSACCIÓN", "TIPO TRANSACCIÓN_encoded"]].drop_duplicates().reset_index(drop=True)
dict_dia_del_anio = df2.loc[:, ["DIA_DEL_AÑO", "DIA_DEL_AÑO_encoded"]].drop_duplicates().reset_index(drop=True)

df_arbol = df2.loc[:,[
   'CILINDRAJE','MARCA_encoded','MODELO_encoded','CLASE_encoded','TIPO COMBUSTIBLE_encoded',
                'PAÍS_encoded','CANTÓN_encoded','COLOR 1_encoded','DIA_DEL_AÑO_encoded','PERSONA NATURAL - JURÍDICA_encoded',
                'TIPO_encoded','EDAD','TIPO SERVICIO_encoded','TIPO TRANSACCIÓN_encoded'
]].copy()

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
    df_fecha = pd.DataFrame({
        'FECHA COMPRA': [features[0][13]]
    })
    df_fecha['FECHA COMPRA'] = pd.to_datetime(df_fecha['FECHA COMPRA'])

    # Manejar caso de día del año no encontrado
    try:
        dia_del_anio_encoded = dict_dia_del_anio.loc[dict_dia_del_anio['DIA_DEL_AÑO'] == str(df_fecha['FECHA COMPRA'].dt.dayofyear.values[0]), 'DIA_DEL_AÑO_encoded'].values[0]
    except IndexError:
        dia_del_anio_encoded = dict_dia_del_anio.loc[dict_dia_del_anio['DIA_DEL_AÑO'] == 'OTRO', 'DIA_DEL_AÑO_encoded'].values[0]

    df_features = pd.DataFrame({
        'CILINDRAJE': [int(features[0][0])],
        'MARCA_encoded': [dict_marca.loc[dict_marca['MARCA'] == features[0][1], 'MARCA_encoded'].values[0]],
        'MODELO_encoded': [dict_modelo.loc[dict_modelo['MODELO'] == features[0][2], 'MODELO_encoded'].values[0]],
        'CLASE_encoded': [dict_clase.loc[dict_clase['CLASE'] == features[0][5], 'CLASE_encoded'].values[0]],
        'TIPO COMBUSTIBLE_encoded': [dict_tipo_combustible.loc[dict_tipo_combustible['TIPO COMBUSTIBLE'] == features[0][4], 'TIPO COMBUSTIBLE_encoded'].values[0]],
        'PAÍS_encoded': [dict_pais.loc[dict_pais['PAÍS'] == features[0][7], 'PAÍS_encoded'].values[0]],
        'CANTÓN_encoded': [dict_canton.loc[dict_canton['CANTÓN'] == features[0][6], 'CANTÓN_encoded'].values[0]],
        'COLOR 1_encoded': [dict_color1.loc[dict_color1['COLOR 1'] == features[0][8], 'COLOR 1_encoded'].values[0]],
        'DIA_DEL_AÑO_encoded': [dia_del_anio_encoded],
        'PERSONA NATURAL - JURÍDICA_encoded': [dict_tipo_persona.loc[dict_tipo_persona['PERSONA NATURAL - JURÍDICA'] == features[0][9], 'PERSONA NATURAL - JURÍDICA_encoded'].values[0]],
        'TIPO_encoded': [dict_tipo.loc[dict_tipo['TIPO'] == features[0][10], 'TIPO_encoded'].values[0]],
        'EDAD': [df_fecha['FECHA COMPRA'].dt.year.values[0] - int(features[0][3])],
        'TIPO SERVICIO_encoded': [dict_tipo_servicio.loc[dict_tipo_servicio['TIPO SERVICIO'] == features[0][11], 'TIPO SERVICIO_encoded'].values[0]],
        'TIPO TRANSACCIÓN_encoded': [dict_tipo_transaccion.loc[dict_tipo_transaccion['TIPO TRANSACCIÓN'] == features[0][12], 'TIPO TRANSACCIÓN_encoded'].values[0]],
    })

    # Realizar la predicción
    prediction = model.predict(df_features)
    return jsonify({'prediction': prediction.tolist()})

@app.route('/batch_predict', methods=['POST'])
def batch_predict():
    data = request.json
    features_list = data['features'] 
    
    predictions = []

    for features in features_list:
        df_fecha = pd.DataFrame({
            'FECHA COMPRA': [features[13]]
        })
        df_fecha['FECHA COMPRA'] = pd.to_datetime(df_fecha['FECHA COMPRA'])
        try:
            dia_del_anio_encoded = dict_dia_del_anio.loc[
                dict_dia_del_anio['DIA_DEL_AÑO'] == str(df_fecha['FECHA COMPRA'].dt.dayofyear.values[0]),
                'DIA_DEL_AÑO_encoded'
            ].values[0]
        except IndexError:
            dia_del_anio_encoded = dict_dia_del_anio.loc[
                dict_dia_del_anio['DIA_DEL_AÑO'] == 'OTRO',
                'DIA_DEL_AÑO_encoded'
            ].values[0]
        df_features = pd.DataFrame({
            'CILINDRAJE': [int(features[0])],
            'MARCA_encoded': [dict_marca.loc[dict_marca['MARCA'] == features[1], 'MARCA_encoded'].values[0]],
            'MODELO_encoded': [dict_modelo.loc[dict_modelo['MODELO'] == features[2], 'MODELO_encoded'].values[0]],
            'CLASE_encoded': [dict_clase.loc[dict_clase['CLASE'] == features[5], 'CLASE_encoded'].values[0]],
            'TIPO COMBUSTIBLE_encoded': [dict_tipo_combustible.loc[
                dict_tipo_combustible['TIPO COMBUSTIBLE'] == features[4], 'TIPO COMBUSTIBLE_encoded'].values[0]],
            'PAÍS_encoded': [dict_pais.loc[dict_pais['PAÍS'] == features[7], 'PAÍS_encoded'].values[0]],
            'CANTÓN_encoded': [dict_canton.loc[
                dict_canton['CANTÓN'] == features[6].strip(), 'CANTÓN_encoded'].values[0]],
            'COLOR 1_encoded': [dict_color1.loc[dict_color1['COLOR 1'] == features[8], 'COLOR 1_encoded'].values[0]],
            'DIA_DEL_AÑO_encoded': [dia_del_anio_encoded],
            'PERSONA NATURAL - JURÍDICA_encoded': [dict_tipo_persona.loc[
                dict_tipo_persona['PERSONA NATURAL - JURÍDICA'] == features[9], 'PERSONA NATURAL - JURÍDICA_encoded'
            ].values[0]],
            'TIPO_encoded': [dict_tipo.loc[dict_tipo['TIPO'] == features[10], 'TIPO_encoded'].values[0]],
            'EDAD': [df_fecha['FECHA COMPRA'].dt.year.values[0] - int(features[3])],
            'TIPO SERVICIO_encoded': [dict_tipo_servicio.loc[
                dict_tipo_servicio['TIPO SERVICIO'] == features[11], 'TIPO SERVICIO_encoded'].values[0]],
            'TIPO TRANSACCIÓN_encoded': [dict_tipo_transaccion.loc[
                dict_tipo_transaccion['TIPO TRANSACCIÓN'] == features[12], 'TIPO TRANSACCIÓN_encoded'].values[0]],
        })

        prediction = model.predict(df_features)
        predictions.append(prediction[0])
    return jsonify({'predictions': predictions})

@app.route('/feature_importances', methods=['GET'])
def feature_importances():
    feature_importances = model.feature_importances_
    feature_importances_dict = dict(zip(df_arbol.columns, feature_importances))
    return jsonify(feature_importances_dict)

@app.route('/')
def show_routes():
    routes = []
    for rule in app.url_map.iter_rules():
        routes.append({
            'route': str(rule),
            'methods': list(rule.methods)
        })
    return jsonify({'routes': routes})

if __name__ == '__main__':
    app.run(debug=True)
