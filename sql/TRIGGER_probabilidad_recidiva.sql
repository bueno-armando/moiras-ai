-- Trigger para verificar que la probabilidad de recidiva esté en un rango válido
DELIMITER $$

CREATE TRIGGER check_probabilidad_recidiva BEFORE INSERT ON Resultados_Prediccion
FOR EACH ROW
BEGIN
    IF NEW.probabilidad_recidiva < 0 OR NEW.probabilidad_recidiva > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La probabilidad de recidiva debe estar entre 0 y 100';
    END IF;
END;

DELIMITER ;
