-- Función para determinar si el paciente tiene un riesgo alto de recidiva

DELIMITER $$

CREATE FUNCTION riesgo_recidiva_alto(probabilidad DECIMAL(5,2)) RETURNS BOOLEAN
DETERMINES
BEGIN
    IF probabilidad > 50 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

DELIMITER ;