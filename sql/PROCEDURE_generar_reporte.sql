DELIMITER //

CREATE PROCEDURE generar_reporte_pacientes()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE paciente_id INT;
    DECLARE nombre_paciente VARCHAR(100);
    DECLARE cur CURSOR FOR SELECT id_paciente, nombre FROM Pacientes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE ReportePacientes (
        id_paciente INT,
        nombre VARCHAR(100),
        eventos_cardiovasculares INT,
        examenes_laboratorio INT
    );

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO paciente_id, nombre_paciente;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO ReportePacientes (id_paciente, nombre, eventos_cardiovasculares, examenes_laboratorio)
        SELECT 
            paciente_id, 
            nombre_paciente,
            (SELECT COUNT(*) FROM EventosCardiovasculares WHERE paciente_id = paciente_id),
            (SELECT COUNT(*) FROM ExamenesLaboratorio WHERE paciente_id = paciente_id);
    END LOOP;

    CLOSE cur;

    SELECT * FROM ReportePacientes;
    DROP TEMPORARY TABLE ReportePacientes;
END //

DELIMITER ;