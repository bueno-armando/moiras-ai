DELIMITER //

CREATE PROCEDURE insertar_paciente(
    IN p_nombre VARCHAR(100),
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('M','F','Otro'),
    IN p_direccion TEXT,
    IN p_telefono VARCHAR(15),
    IN p_email VARCHAR(100)
)
BEGIN
    INSERT INTO Pacientes (nombre, fecha_nacimiento, genero, direccion, telefono, email)
    VALUES (p_nombre, p_fecha_nacimiento, p_genero, p_direccion, p_telefono, p_email);
END //

DELIMITER ;