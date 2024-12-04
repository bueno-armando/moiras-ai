import mysql.connector
from flask import Flask, render_template, request, redirect, url_for, session, flash
import numpy as np
import joblib
from werkzeug.security import check_password_hash
from datetime import datetime

app = Flask(__name__)
app.secret_key = "your_secret_key"  # Replace with a secure key

# Database connection
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="moiras_db"
    )

# User authentication
def authenticate_user(username, password):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    query = "SELECT * FROM Usuarios WHERE username = %s"
    cursor.execute(query, (username,))
    user = cursor.fetchone()
    cursor.close()
    connection.close()
    if user and check_password_hash(user["password"], password):
        return user
    return None

# Routes
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = authenticate_user(username, password)
        if user:
            session['user_id'] = user['id']
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid username or password', 'danger')
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    return render_template('dashboard.html')

@app.route('/ai', methods=['GET', 'POST'])
def ai_prediction():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    result = None
    if request.method == 'POST':
        edad = float(request.form['edad'])
        anemia = 1 if request.form['anemia'].lower() == "si" else 0
        diabetes = 1 if request.form['diabetes'].lower() == "si" else 0
        eyeccion = int(request.form['eyeccion'])
        presion = 1 if request.form['presion'].lower() == "si" else 0
        plaquetas = float(request.form['plaquetas'])
        creatinina = float(request.form['creatinina'])
        sexo = 1 if request.form['sexo'].lower() in ["f", "femenino", "mujer"] else 0
        fuma = int(request.form['fuma'])
        tiempo = int(request.form['tiempo'])

        modelo = joblib.load('./models/modelo9523.joblib')
        datos = np.array([[edad, anemia, diabetes, eyeccion, presion, plaquetas, creatinina, sexo, fuma, tiempo]])
        resultado = modelo.predict_proba(datos)
        result = resultado[0][1]

    return render_template('ai_form.html', result=result)

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    return redirect(url_for('login'))

# Rutas para Gestión de Pacientes
@app.route('/pacientes')
def pacientes():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Pacientes")
    pacientes = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('pacientes.html', pacientes=pacientes)

@app.route('/paciente/nuevo', methods=['GET', 'POST'])
def nuevo_paciente():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        fecha_nacimiento = request.form['fecha_nacimiento']
        genero = request.form['genero']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        email = request.form['email']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO Pacientes (nombre, fecha_nacimiento, genero, direccion, telefono, email)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nombre, fecha_nacimiento, genero, direccion, telefono, email))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('pacientes'))
    
    return render_template('nuevo_paciente.html')

@app.route('/paciente/editar/<int:paciente_id>', methods=['GET', 'POST'])
def editar_paciente(paciente_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        fecha_nacimiento = request.form['fecha_nacimiento']
        genero = request.form['genero']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        email = request.form['email']
        
        cursor.execute("""
            UPDATE Pacientes 
            SET nombre = %s, fecha_nacimiento = %s, genero = %s, 
                direccion = %s, telefono = %s, email = %s
            WHERE id_paciente = %s
        """, (nombre, fecha_nacimiento, genero, direccion, telefono, email, paciente_id))
        connection.commit()
        cursor.close()
        connection.close()
        flash('Paciente actualizado exitosamente', 'success')
        return redirect(url_for('pacientes'))
    
    cursor.execute("SELECT * FROM Pacientes WHERE id_paciente = %s", (paciente_id,))
    paciente = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return render_template('editar_paciente.html', paciente=paciente)

@app.route('/paciente/eliminar/<int:paciente_id>')
def eliminar_paciente(paciente_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor()
     
    try:
        # Eliminar registros relacionados primero
        cursor.execute("DELETE FROM ActividadesFisicas WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM Alergias WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM CitasMedicas WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM EventosCardiovasculares WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM ExamenesLaboratorio WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM HistorialFamiliar WHERE paciente_id = %s", (paciente_id,))
        cursor.execute("DELETE FROM PrescripcionesMedicas WHERE paciente_id = %s", (paciente_id,))
        
        # Finalmente eliminar el paciente
        cursor.execute("DELETE FROM Pacientes WHERE id_paciente = %s", (paciente_id,))
        connection.commit()
        flash('Paciente eliminado exitosamente', 'success')
    except mysql.connector.Error as err:
        flash(f'Error al eliminar paciente: {err}', 'danger')
    
    cursor.close()
    connection.close()
    return redirect(url_for('pacientes'))

# Rutas para Gestión de Doctores
@app.route('/doctores')
def doctores():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Doctores")
    doctores = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('doctores.html', doctores=doctores)

@app.route('/doctor/nuevo', methods=['GET', 'POST'])
def nuevo_doctor():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        especialidad_id = request.form['especialidad_id']
        telefono = request.form['telefono']
        email = request.form['email']
        
        cursor.execute("""
            INSERT INTO Doctores (nombre, especialidad_id, telefono, email)
            VALUES (%s, %s, %s, %s)
        """, (nombre, especialidad_id, telefono, email))
        connection.commit()
        return redirect(url_for('doctores'))
    
    cursor.execute("SELECT * FROM EspecialidadesMedicas")
    especialidades = cursor.fetchall()
    cursor.close()
    connection.close()
    
    return render_template('nuevo_doctor.html', especialidades=especialidades)

@app.route('/doctor/editar/<int:doctor_id>', methods=['GET', 'POST'])
def editar_doctor(doctor_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        especialidad_id = request.form['especialidad_id']
        telefono = request.form['telefono']
        email = request.form['email']
        
        cursor.execute("""
            UPDATE Doctores 
            SET nombre = %s, especialidad_id = %s, telefono = %s, email = %s
            WHERE id_doctor = %s
        """, (nombre, especialidad_id, telefono, email, doctor_id))
        connection.commit()
        cursor.close()
        connection.close()
        flash('Doctor actualizado exitosamente', 'success')
        return redirect(url_for('doctores'))
    
    cursor.execute("SELECT * FROM Doctores WHERE id_doctor = %s", (doctor_id,))
    doctor = cursor.fetchone()
    cursor.execute("SELECT * FROM EspecialidadesMedicas")
    especialidades = cursor.fetchall()
    cursor.close()
    connection.close()
    
    return render_template('editar_doctor.html', doctor=doctor, especialidades=especialidades)

@app.route('/doctor/eliminar/<int:doctor_id>')
def eliminar_doctor(doctor_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    try:
        # Eliminar registros relacionados primero
        cursor.execute("DELETE FROM CitasMedicas WHERE doctor_id = %s", (doctor_id,))
        cursor.execute("DELETE FROM PrescripcionesMedicas WHERE doctor_id = %s", (doctor_id,))
        
        # Finalmente eliminar el doctor
        cursor.execute("DELETE FROM Doctores WHERE id_doctor = %s", (doctor_id,))
        connection.commit()
        flash('Doctor eliminado exitosamente', 'success')
    except mysql.connector.Error as err:
        flash(f'Error al eliminar doctor: {err}', 'danger')
    
    cursor.close()
    connection.close()
    return redirect(url_for('doctores'))

# Rutas para Historial Médico
@app.route('/historial/<int:paciente_id>')
def historial_medico(paciente_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    cursor.execute("SELECT * FROM Pacientes WHERE id_paciente = %s", (paciente_id,))
    paciente = cursor.fetchone()
    
    cursor.execute("SELECT * FROM EventosCardiovasculares WHERE paciente_id = %s", (paciente_id,))
    eventos = cursor.fetchall()
    
    cursor.execute("SELECT * FROM ExamenesLaboratorio WHERE paciente_id = %s", (paciente_id,))
    examenes = cursor.fetchall()
    
    cursor.execute("SELECT * FROM PrescripcionesMedicas WHERE paciente_id = %s", (paciente_id,))
    prescripciones = cursor.fetchall()
    
    cursor.close()
    connection.close()
    
    return render_template('historial_medico.html', 
                           paciente=paciente, 
                           eventos=eventos, 
                           examenes=examenes, 
                           prescripciones=prescripciones)

# Rutas adicionales para gestión completa
@app.route('/citas')
def citas():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("""
        SELECT c.*, p.nombre as paciente, d.nombre as doctor, h.nombre as hospital
        FROM CitasMedicas c
        JOIN Pacientes p ON c.paciente_id = p.id_paciente
        JOIN Doctores d ON c.doctor_id = d.id_doctor
        JOIN Hospitales h ON c.hospital_id = h.id_hospital
    """)
    citas = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('citas.html', citas=citas)

# Rutas adicionales para citas
@app.route('/cita/nueva', methods=['GET', 'POST'])
def nueva_cita():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        paciente_id = request.form['paciente_id']
        doctor_id = request.form['doctor_id']
        hospital_id = request.form['hospital_id']
        fecha = request.form['fecha']
        hora = request.form['hora']
        motivo = request.form['motivo']
        
        cursor.execute("""
            INSERT INTO CitasMedicas (paciente_id, doctor_id, hospital_id, fecha, hora, motivo)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (paciente_id, doctor_id, hospital_id, fecha, hora, motivo))
        connection.commit()
        return redirect(url_for('citas'))
    
    # Obtener datos para los selects
    cursor.execute("SELECT id_paciente, nombre FROM Pacientes")
    pacientes = cursor.fetchall()
    
    cursor.execute("SELECT id_doctor, nombre FROM Doctores")
    doctores = cursor.fetchall()
    
    cursor.execute("SELECT id_hospital, nombre FROM Hospitales")
    hospitales = cursor.fetchall()
    
    cursor.close()
    connection.close()
    
    return render_template('nueva_cita.html', 
                         pacientes=pacientes,
                         doctores=doctores,
                         hospitales=hospitales)

@app.route('/cita/editar/<int:cita_id>', methods=['GET', 'POST'])
def editar_cita(cita_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        fecha = request.form['fecha']
        hora = request.form['hora']
        motivo = request.form['motivo']
        
        cursor.execute("""
            UPDATE CitasMedicas 
            SET fecha = %s, hora = %s, motivo = %s
            WHERE id_cita = %s
        """, (fecha, hora, motivo, cita_id))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('citas'))
    
    cursor.execute("SELECT * FROM CitasMedicas WHERE id_cita = %s", (cita_id,))
    cita = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return render_template('editar_cita.html', cita=cita)

@app.route('/cita/cancelar/<int:cita_id>')
def cancelar_cita(cita_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("DELETE FROM CitasMedicas WHERE id_cita = %s", (cita_id,))
    connection.commit()
    cursor.close()
    connection.close()
    
    flash('Cita cancelada exitosamente', 'success')
    return redirect(url_for('citas'))

# Rutas para Gestión de Historial Médico
@app.route('/historial/evento/nuevo/<int:paciente_id>', methods=['POST'])
def nuevo_evento(paciente_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    tipo_evento = request.form['tipo_evento']
    fecha = request.form['fecha']
    descripcion = request.form['descripcion']
    
    cursor.execute("""
        INSERT INTO EventosCardiovasculares (paciente_id, tipo_evento, fecha, descripcion)
        VALUES (%s, %s, %s, %s)
    """, (paciente_id, tipo_evento, fecha, descripcion))
    connection.commit()
    
    cursor.close()
    connection.close()
    flash('Evento cardiovascular registrado exitosamente', 'success')
    return redirect(url_for('historial_medico', paciente_id=paciente_id))

@app.route('/examenes')
def examenes():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM ExamenesLaboratorio")
    examenes = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('examenes.html', examenes=examenes)

@app.route('/examen/nuevo', methods=['GET', 'POST'])
def nuevo_examen():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        paciente_id = request.form['paciente_id']
        tipo_examen = request.form['tipo_examen']
        resultado = request.form['resultado']
        fecha = request.form['fecha']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO ExamenesLaboratorio (paciente_id, tipo_examen, resultado, fecha)
            VALUES (%s, %s, %s, %s)
        """, (paciente_id, tipo_examen, resultado, fecha))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('examenes'))
    
    return render_template('nuevo_examen.html')

@app.route('/historial/prescripcion/nueva/<int:paciente_id>', methods=['POST'])
def nueva_prescripcion(paciente_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    doctor_id = request.form['doctor_id']
    medicamento_id = request.form['medicamento_id']
    dosis = request.form['dosis']
    instrucciones = request.form['instrucciones']
    fecha = datetime.now().date()
    
    cursor.execute("""
        INSERT INTO PrescripcionesMedicas 
        (paciente_id, doctor_id, medicamento_id, fecha_prescripcion, dosis, instrucciones)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (paciente_id, doctor_id, medicamento_id, fecha, dosis, instrucciones))
    connection.commit()
    
    cursor.close()
    connection.close()
    flash('Prescripción médica registrada exitosamente', 'success')
    return redirect(url_for('historial_medico', paciente_id=paciente_id))

@app.route('/hospitales')
def hospitales():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Hospitales")
    hospitales = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('hospitales.html', hospitales=hospitales)

@app.route('/hospital/nuevo', methods=['GET', 'POST'])
def nuevo_hospital():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO Hospitales (nombre, direccion, telefono)
            VALUES (%s, %s, %s)
        """, (nombre, direccion, telefono))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('hospitales'))
    
    return render_template('nuevo_hospital.html')

@app.route('/hospital/editar/<int:hospital_id>', methods=['GET', 'POST'])
def editar_hospital(hospital_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        direccion = request.form['direccion']
        telefono = request.form['telefono']
        
        cursor.execute("""
            UPDATE Hospitales 
            SET nombre = %s, direccion = %s, telefono = %s
            WHERE id_hospital = %s
        """, (nombre, direccion, telefono, hospital_id))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('hospitales'))
    
    cursor.execute("SELECT * FROM Hospitales WHERE id_hospital = %s", (hospital_id,))
    hospital = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return render_template('editar_hospital.html', hospital=hospital)

@app.route('/medicamentos')
def medicamentos():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Medicamentos")
    medicamentos = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('medicamentos.html', medicamentos=medicamentos)

@app.route('/medicamento/nuevo', methods=['GET', 'POST'])
def nuevo_medicamento():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        fabricante = request.form['fabricante']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO Medicamentos (nombre, descripcion, fabricante)
            VALUES (%s, %s, %s)
        """, (nombre, descripcion, fabricante))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('medicamentos'))
    
    return render_template('nuevo_medicamento.html')

@app.route('/medicamento/editar/<int:medicamento_id>', methods=['GET', 'POST'])
def editar_medicamento(medicamento_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    if request.method == 'POST':
        nombre = request.form['nombre']
        descripcion = request.form['descripcion']
        fabricante = request.form['fabricante']
        
        cursor.execute("""
            UPDATE Medicamentos 
            SET nombre = %s, descripcion = %s, fabricante = %s
            WHERE id_medicamento = %s
        """, (nombre, descripcion, fabricante, medicamento_id))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('medicamentos'))
    
    cursor.execute("SELECT * FROM Medicamentos WHERE id_medicamento = %s", (medicamento_id,))
    medicamento = cursor.fetchone()
    cursor.close()
    connection.close()
    
    return render_template('editar_medicamento.html', medicamento=medicamento)

@app.route('/estadisticas')
def estadisticas():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM EstadisticasPrediccion")
    estadisticas = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('estadisticas.html', estadisticas=estadisticas)

@app.route('/estadistica/nueva', methods=['GET', 'POST'])
def nueva_estadistica():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        paciente_id = request.form['paciente_id']
        fecha = request.form['fecha']
        resultado = request.form['resultado']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO EstadisticasPrediccion (paciente_id, fecha, resultado)
            VALUES (%s, %s, %s)
        """, (paciente_id, fecha, resultado))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('estadisticas'))
    
    return render_template('nueva_estadistica.html')

@app.route('/imagenes')
def imagenes():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM ImagenesMedicas")
    imagenes = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('imagenes.html', imagenes=imagenes)

@app.route('/imagen/nueva', methods=['GET', 'POST'])
def nueva_imagen():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        paciente_id = request.form['paciente_id']
        tipo_imagen = request.form['tipo_imagen']
        descripcion = request.form['descripcion']
        fecha = request.form['fecha']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO ImagenesMedicas (paciente_id, tipo_imagen, descripcion, fecha)
            VALUES (%s, %s, %s, %s)
        """, (paciente_id, tipo_imagen, descripcion, fecha))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('imagenes'))
    
    return render_template('nueva_imagen.html')

@app.route('/seguimientos')
def seguimientos():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT * FROM SeguimientoMedico")
    seguimientos = cursor.fetchall()
    cursor.close()
    connection.close()
    return render_template('seguimientos.html', seguimientos=seguimientos)

@app.route('/seguimiento/nuevo', methods=['GET', 'POST'])
def nuevo_seguimiento():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    if request.method == 'POST':
        paciente_id = request.form['paciente_id']
        fecha = request.form['fecha']
        observaciones = request.form['observaciones']
        
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            INSERT INTO SeguimientoMedico (paciente_id, fecha, observaciones)
            VALUES (%s, %s, %s)
        """, (paciente_id, fecha, observaciones))
        connection.commit()
        cursor.close()
        connection.close()
        return redirect(url_for('seguimientos'))
    
    return render_template('nuevo_seguimiento.html')

if __name__ == '__main__':
    app.run(debug=True)
