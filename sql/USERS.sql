DELIMITER $$

-- craendo nuevo usuario medico_consulta (medico que realizará las consultas)
CREATE USER 'medico_consulta'@'localhost' IDENTIFIED BY 'contraseña_segura';

-- permisos específicos
GRANT SELECT ON moiras_db.Pacientes TO 'medico_consulta'@'localhost';
GRANT SELECT ON moiras_db.ConsultasRealizadas TO 'medico_consulta'@'localhost';
GRANT SELECT ON moiras_db.ExamenesLaboratorio TO 'medico_consulta'@'localhost';

-- revocar permisos si es necesario
-- REVOKE INSERT, UPDATE, DELETE ON moiras_db.* FROM 'medico_consulta'@'localhost';

DELIMITER ;