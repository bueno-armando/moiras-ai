DELIMITER //

CREATE PROCEDURE actualizar_seguimiento_medico()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE paciente_id INT;
    DECLARE total_eventos INT;
    DECLARE cur CURSOR FOR SELECT id_paciente FROM Pacientes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO paciente_id;
        
        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT COUNT(*) INTO total_eventos 
        FROM EventosCardiovasculares 
        WHERE paciente_id = paciente_id;

        INSERT INTO SeguimientoMedico (paciente_id, fecha, observaciones)
        VALUES (paciente_id, CURDATE(), CONCAT('Total de eventos: ', total_eventos));
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;