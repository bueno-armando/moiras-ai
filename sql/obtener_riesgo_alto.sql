-- PROCEDURE para obtener pacientes con riesgo alto de recidiva

DELIMITER $$

CREATE PROCEDURE obtener_riesgo_alto()
BEGIN
    SELECT p.id, p.nombre, p.edad, p.genero, rp.probabilidad_recidiva
    FROM Pacientes p
    JOIN Resultados_Prediccion rp ON p.id = rp.paciente_id
    WHERE rp.probabilidad_recidiva > 50;
END;

DELIMITER ;