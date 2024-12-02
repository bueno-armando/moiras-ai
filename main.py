import mysql.connector
from flask import Flask, render_template, request, redirect, url_for
from respuesta import Respuesta
from validator import Validator
import numpy as np
import joblib

app = Flask(__name__)

# Configuración de la conexión a la base de datos
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="moiras_db"
    )

def obtener_historial_medico_completo(paciente_id):
    """
    Función que usa INNER JOIN para obtener un historial médico completo de un paciente
    """
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        query = """
        SELECT 
            p.nombre AS nombre_paciente,
            p.fecha_nacimiento,
            p.genero,
            ev.tipo_evento AS evento_cardiovascular,
            ev.fecha AS fecha_evento,
            ex.tipo_examen,
            ex.resultados,
            ex.fecha AS fecha_examen,
            inter.tipo_intervencion,
            inter.fecha AS fecha_intervencion
        FROM Pacientes p
        INNER JOIN EventosCardiovasculares ev ON p.id_paciente = ev.paciente_id
        INNER JOIN ExamenesLaboratorio ex ON p.id_paciente = ex.paciente_id
        INNER JOIN IntervencionesQuirurgicas inter ON p.id_paciente = inter.paciente_id
        WHERE p.id_paciente = %s
        """
        
        cursor.execute(query, (paciente_id,))
        historial = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        return historial
    
    except mysql.connector.Error as error:
        print(f"Error al obtener historial médico: {error}")
        return None

def obtener_prescripciones_con_detalles(paciente_id):
    """
    Función que usa múltiples INNER JOINs para obtener prescripciones detalladas
    """
    try:
        connection = get_db_connection()
        cursor = connection.cursor(dictionary=True)
        
        query = """
        SELECT 
            p.nombre AS nombre_paciente,
            m.nombre AS medicamento,
            m.fabricante,
            pm.dosis,
            pm.instrucciones,
            pm.fecha_prescripcion,
            d.nombre AS nombre_doctor,
            d.especialidad_id
        FROM PrescripcionesMedicas pm
        INNER JOIN Pacientes p ON pm.paciente_id = p.id_paciente
        INNER JOIN Medicamentos m ON pm.medicamento_id = m.id_medicamento
        INNER JOIN Doctores d ON pm.doctor_id = d.id_doctor
        WHERE p.id_paciente = %s
        """
        
        cursor.execute(query, (paciente_id,))
        prescripciones = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        return prescripciones
    
    except mysql.connector.Error as error:
        print(f"Error al obtener prescripciones: {error}")
        return None

app = Flask(__name__)

modelo = joblib.load('./models/modelo9523.joblib')

@app.route('/')
def index():
    return render_template('form.html')

@app.route('/submit_answers', methods=['POST'])
def handle_button():
    if request.method == 'POST':
        # try:
        edad = float(request.form['edad'])
        anemia = str(request.form['anemia'])
        anemia = anemia.upper()
        diabetes = str(request.form['diabetes'])
        diabetes = diabetes.upper()
        eyeccion = int(request.form['eyeccion'])
        presion = str(request.form['presion'])
        presion = presion.upper()
        plaquetas = float(request.form['plaquetas'])
        creatinina = float(request.form['creatinina'])
        sexo = str(request.form['sexo'])
        sexo = sexo.upper()
        fuma = int(request.form['fuma'])
        tiempo = int(request.form['tiempo'])
        peso = int(request.form['peso'])
        
        if(anemia == "SI" or anemia == "Sí"):
            anemia = 1
        else:
            anemia = 0
        if(diabetes == "SI" or diabetes == "Sí"):
            diabetes = 1
        else:
            diabetes = 0
        if(presion == "SI" or presion == "Sí"):
            presion = 1
        else:
            presion = 0
        if(sexo == "F" or sexo == "FEMENINO" or sexo == "MUJER"):
            sexo = 1
        else:
            sexo = 0
        if(fuma == 0):
            cigarrillo = False
        else:
            cigarrillo = True

        #Creación del arreglo a enviar al árbol
        datos = []
        datos.append([edad, anemia, diabetes, eyeccion, presion, plaquetas, creatinina, sexo, cigarrillo, tiempo])
        datos = np.array(datos)
        
        #Enviar los datos a analizar
        resultado = modelo.predict_proba(datos)
        #Elegir el primer dato
        res = resultado[0][1]
        
        respuesta_instance = Respuesta(res, sexo, edad, peso, fuma, presion, diabetes)

        respuesta_text = respuesta_instance.respuesta

        #Creacion del output a mostar
        # stringFinal = Respuesta(res, sexo, edad, peso, cigarrillos, presion, diabetes)
        # print(stringFinal)
        # stringFinal = "holis si jala el boton"
        #Enviar el string al HTML
        return render_template('form.html', submitted_answers = respuesta_text)
        

if __name__ == '__main__':
    app.run(debug=True)