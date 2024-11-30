-- 1. Doctores
CREATE TABLE Doctores (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad_id INT NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    FOREIGN KEY (especialidad_id) REFERENCES EspecialidadesMedicas(id_especialidad)
);

-- 2. Especialidades Médicas
CREATE TABLE EspecialidadesMedicas (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- 3. Medicamentos
CREATE TABLE Medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fabricante VARCHAR(100)
);

-- 4. Prescripciones Médicas
CREATE TABLE PrescripcionesMedicas (
    id_prescripcion INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    medicamento_id INT NOT NULL,
    fecha_prescripcion DATE NOT NULL,
    dosis VARCHAR(50),
    instrucciones TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (doctor_id) REFERENCES Doctores(id_doctor),
    FOREIGN KEY (medicamento_id) REFERENCES Medicamentos(id_medicamento)
);

-- 5. Hospitales o Clínicas
CREATE TABLE Hospitales (
    id_hospital INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion TEXT,
    telefono VARCHAR(15)
);

-- 6. Citas Médicas
CREATE TABLE CitasMedicas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    hospital_id INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    motivo TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (doctor_id) REFERENCES Doctores(id_doctor),
    FOREIGN KEY (hospital_id) REFERENCES Hospitales(id_hospital)
);

-- 7. Procedimientos Médicos
CREATE TABLE ProcedimientosMedicos (
    id_procedimiento INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    doctor_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente),
    FOREIGN KEY (doctor_id) REFERENCES Doctores(id_doctor)
);

-- 8. Exámenes de Laboratorio
CREATE TABLE ExamenesLaboratorio (
    id_examen INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo_examen VARCHAR(100) NOT NULL,
    resultados TEXT,
    fecha DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 9. Imágenes Médicas
CREATE TABLE ImagenesMedicas (
    id_imagen INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo_imagen VARCHAR(50) NOT NULL,
    url_imagen TEXT NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 10. Historial Familiar
CREATE TABLE HistorialFamiliar (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    enfermedad VARCHAR(100) NOT NULL,
    familiar_relacion VARCHAR(50),
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 11. Factores de Riesgo
CREATE TABLE FactoresRiesgo (
    id_factor INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 12. Eventos Cardiovasculares Previos
CREATE TABLE EventosCardiovasculares (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo_evento VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 13. Seguimiento Médico
CREATE TABLE SeguimientoMedico (
    id_seguimiento INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    fecha DATE NOT NULL,
    observaciones TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 14. Dietas Recomendadas
CREATE TABLE DietasRecomendadas (
    id_dieta INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 15. Actividades Físicas
CREATE TABLE ActividadesFisicas (
    id_actividad INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    descripcion TEXT NOT NULL,
    frecuencia VARCHAR(50),
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 16. Alertas Médicas
CREATE TABLE AlertasMedicas (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATE NOT NULL,
    leida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 17. Datos de Dispositivos Médicos
CREATE TABLE DatosDispositivos (
    id_dato INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo_dispositivo VARCHAR(50) NOT NULL,
    dato_recopilado TEXT NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(id_paciente)
);

-- 18. Estadísticas de Predicción
CREATE TABLE EstadisticasPrediccion (
    id_estadistica INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    total_predicciones INT,
    precision_modelo FLOAT,
    recall_modelo FLOAT
);

