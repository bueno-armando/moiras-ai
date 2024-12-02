DELIMITER $$

CREATE VIEW Vista_Pacientes_Resultados AS
SELECT p.id, p.nombre, p.edad, p.genero, hm.anemia, hm.diabetes, hm.hipertension, hm.tabaquismo,
       rp.ejection_fraction, rp.creatinina_serica, rp.plaquetas, rp.probabilidad_recidiva
FROM Pacientes p
JOIN Historial_Medico hm ON p.id = hm.paciente_id
JOIN Resultados_Prediccion rp ON p.id = rp.paciente_id;

DELIMITER ;