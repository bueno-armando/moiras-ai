/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.6.2-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: moiras_db
-- ------------------------------------------------------
-- Server version	11.6.2-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `ActividadesFisicas`
--

DROP TABLE IF EXISTS `ActividadesFisicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ActividadesFisicas` (
  `id_actividad` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `descripcion` text NOT NULL,
  `frecuencia` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_actividad`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `ActividadesFisicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ActividadesFisicas`
--

LOCK TABLES `ActividadesFisicas` WRITE;
/*!40000 ALTER TABLE `ActividadesFisicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ActividadesFisicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Alergias`
--

DROP TABLE IF EXISTS `Alergias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Alergias` (
  `id_alergia` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_alergia` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_alergia`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `Alergias_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alergias`
--

LOCK TABLES `Alergias` WRITE;
/*!40000 ALTER TABLE `Alergias` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alergias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AlertasMedicas`
--

DROP TABLE IF EXISTS `AlertasMedicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AlertasMedicas` (
  `id_alerta` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `mensaje` text NOT NULL,
  `fecha` date NOT NULL,
  `leida` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id_alerta`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `AlertasMedicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AlertasMedicas`
--

LOCK TABLES `AlertasMedicas` WRITE;
/*!40000 ALTER TABLE `AlertasMedicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `AlertasMedicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CitasMedicas`
--

DROP TABLE IF EXISTS `CitasMedicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CitasMedicas` (
  `id_cita` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `hospital_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `hora` time NOT NULL,
  `motivo` text DEFAULT NULL,
  PRIMARY KEY (`id_cita`),
  KEY `paciente_id` (`paciente_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `hospital_id` (`hospital_id`),
  CONSTRAINT `CitasMedicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`),
  CONSTRAINT `CitasMedicas_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `Doctores` (`id_doctor`),
  CONSTRAINT `CitasMedicas_ibfk_3` FOREIGN KEY (`hospital_id`) REFERENCES `Hospitales` (`id_hospital`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CitasMedicas`
--

LOCK TABLES `CitasMedicas` WRITE;
/*!40000 ALTER TABLE `CitasMedicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `CitasMedicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ConsultasRealizadas`
--

DROP TABLE IF EXISTS `ConsultasRealizadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ConsultasRealizadas` (
  `id_consulta` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `motivo` text DEFAULT NULL,
  `diagnostico` text DEFAULT NULL,
  PRIMARY KEY (`id_consulta`),
  KEY `paciente_id` (`paciente_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `ConsultasRealizadas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`),
  CONSTRAINT `ConsultasRealizadas_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `Doctores` (`id_doctor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ConsultasRealizadas`
--

LOCK TABLES `ConsultasRealizadas` WRITE;
/*!40000 ALTER TABLE `ConsultasRealizadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ConsultasRealizadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DatosDispositivos`
--

DROP TABLE IF EXISTS `DatosDispositivos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DatosDispositivos` (
  `id_dato` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_dispositivo` varchar(50) NOT NULL,
  `dato_recopilado` text NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id_dato`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `DatosDispositivos_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DatosDispositivos`
--

LOCK TABLES `DatosDispositivos` WRITE;
/*!40000 ALTER TABLE `DatosDispositivos` DISABLE KEYS */;
/*!40000 ALTER TABLE `DatosDispositivos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DietasRecomendadas`
--

DROP TABLE IF EXISTS `DietasRecomendadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DietasRecomendadas` (
  `id_dieta` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`id_dieta`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `DietasRecomendadas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DietasRecomendadas`
--

LOCK TABLES `DietasRecomendadas` WRITE;
/*!40000 ALTER TABLE `DietasRecomendadas` DISABLE KEYS */;
/*!40000 ALTER TABLE `DietasRecomendadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Doctores`
--

DROP TABLE IF EXISTS `Doctores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Doctores` (
  `id_doctor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `especialidad_id` int(11) NOT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_doctor`),
  KEY `especialidad_id` (`especialidad_id`),
  CONSTRAINT `Doctores_ibfk_1` FOREIGN KEY (`especialidad_id`) REFERENCES `EspecialidadesMedicas` (`id_especialidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Doctores`
--

LOCK TABLES `Doctores` WRITE;
/*!40000 ALTER TABLE `Doctores` DISABLE KEYS */;
/*!40000 ALTER TABLE `Doctores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EspecialidadesMedicas`
--

DROP TABLE IF EXISTS `EspecialidadesMedicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EspecialidadesMedicas` (
  `id_especialidad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_especialidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EspecialidadesMedicas`
--

LOCK TABLES `EspecialidadesMedicas` WRITE;
/*!40000 ALTER TABLE `EspecialidadesMedicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `EspecialidadesMedicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EstadisticasPrediccion`
--

DROP TABLE IF EXISTS `EstadisticasPrediccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EstadisticasPrediccion` (
  `id_estadistica` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `total_predicciones` int(11) DEFAULT NULL,
  `precision_modelo` float DEFAULT NULL,
  `recall_modelo` float DEFAULT NULL,
  PRIMARY KEY (`id_estadistica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstadisticasPrediccion`
--

LOCK TABLES `EstadisticasPrediccion` WRITE;
/*!40000 ALTER TABLE `EstadisticasPrediccion` DISABLE KEYS */;
/*!40000 ALTER TABLE `EstadisticasPrediccion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EventosCardiovasculares`
--

DROP TABLE IF EXISTS `EventosCardiovasculares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `EventosCardiovasculares` (
  `id_evento` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_evento` varchar(100) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `EventosCardiovasculares_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EventosCardiovasculares`
--

LOCK TABLES `EventosCardiovasculares` WRITE;
/*!40000 ALTER TABLE `EventosCardiovasculares` DISABLE KEYS */;
/*!40000 ALTER TABLE `EventosCardiovasculares` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ExamenesLaboratorio`
--

DROP TABLE IF EXISTS `ExamenesLaboratorio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ExamenesLaboratorio` (
  `id_examen` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_examen` varchar(100) NOT NULL,
  `resultados` text DEFAULT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id_examen`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `ExamenesLaboratorio_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ExamenesLaboratorio`
--

LOCK TABLES `ExamenesLaboratorio` WRITE;
/*!40000 ALTER TABLE `ExamenesLaboratorio` DISABLE KEYS */;
/*!40000 ALTER TABLE `ExamenesLaboratorio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FactoresRiesgo`
--

DROP TABLE IF EXISTS `FactoresRiesgo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FactoresRiesgo` (
  `id_factor` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_factor`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `FactoresRiesgo_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FactoresRiesgo`
--

LOCK TABLES `FactoresRiesgo` WRITE;
/*!40000 ALTER TABLE `FactoresRiesgo` DISABLE KEYS */;
/*!40000 ALTER TABLE `FactoresRiesgo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `HistorialFamiliar`
--

DROP TABLE IF EXISTS `HistorialFamiliar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `HistorialFamiliar` (
  `id_historial` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `enfermedad` varchar(100) NOT NULL,
  `familiar_relacion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `HistorialFamiliar_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `HistorialFamiliar`
--

LOCK TABLES `HistorialFamiliar` WRITE;
/*!40000 ALTER TABLE `HistorialFamiliar` DISABLE KEYS */;
/*!40000 ALTER TABLE `HistorialFamiliar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Hospitales`
--

DROP TABLE IF EXISTS `Hospitales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Hospitales` (
  `id_hospital` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id_hospital`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Hospitales`
--

LOCK TABLES `Hospitales` WRITE;
/*!40000 ALTER TABLE `Hospitales` DISABLE KEYS */;
/*!40000 ALTER TABLE `Hospitales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ImagenesMedicas`
--

DROP TABLE IF EXISTS `ImagenesMedicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ImagenesMedicas` (
  `id_imagen` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_imagen` varchar(50) NOT NULL,
  `url_imagen` text NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id_imagen`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `ImagenesMedicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ImagenesMedicas`
--

LOCK TABLES `ImagenesMedicas` WRITE;
/*!40000 ALTER TABLE `ImagenesMedicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `ImagenesMedicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IntervencionesQuirurgicas`
--

DROP TABLE IF EXISTS `IntervencionesQuirurgicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IntervencionesQuirurgicas` (
  `id_intervencion` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `tipo_intervencion` varchar(100) NOT NULL,
  `fecha` date NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_intervencion`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `IntervencionesQuirurgicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IntervencionesQuirurgicas`
--

LOCK TABLES `IntervencionesQuirurgicas` WRITE;
/*!40000 ALTER TABLE `IntervencionesQuirurgicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `IntervencionesQuirurgicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Medicamentos`
--

DROP TABLE IF EXISTS `Medicamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Medicamentos` (
  `id_medicamento` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fabricante` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_medicamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Medicamentos`
--

LOCK TABLES `Medicamentos` WRITE;
/*!40000 ALTER TABLE `Medicamentos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Medicamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pacientes`
--

DROP TABLE IF EXISTS `Pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Pacientes` (
  `id_paciente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('M','F','Otro') DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pacientes`
--

LOCK TABLES `Pacientes` WRITE;
/*!40000 ALTER TABLE `Pacientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PrescripcionesMedicas`
--

DROP TABLE IF EXISTS `PrescripcionesMedicas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PrescripcionesMedicas` (
  `id_prescripcion` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `medicamento_id` int(11) NOT NULL,
  `fecha_prescripcion` date NOT NULL,
  `dosis` varchar(50) DEFAULT NULL,
  `instrucciones` text DEFAULT NULL,
  PRIMARY KEY (`id_prescripcion`),
  KEY `paciente_id` (`paciente_id`),
  KEY `doctor_id` (`doctor_id`),
  KEY `medicamento_id` (`medicamento_id`),
  CONSTRAINT `PrescripcionesMedicas_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`),
  CONSTRAINT `PrescripcionesMedicas_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `Doctores` (`id_doctor`),
  CONSTRAINT `PrescripcionesMedicas_ibfk_3` FOREIGN KEY (`medicamento_id`) REFERENCES `Medicamentos` (`id_medicamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PrescripcionesMedicas`
--

LOCK TABLES `PrescripcionesMedicas` WRITE;
/*!40000 ALTER TABLE `PrescripcionesMedicas` DISABLE KEYS */;
/*!40000 ALTER TABLE `PrescripcionesMedicas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProcedimientosMedicos`
--

DROP TABLE IF EXISTS `ProcedimientosMedicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProcedimientosMedicos` (
  `id_procedimiento` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id_procedimiento`),
  KEY `paciente_id` (`paciente_id`),
  KEY `doctor_id` (`doctor_id`),
  CONSTRAINT `ProcedimientosMedicos_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`),
  CONSTRAINT `ProcedimientosMedicos_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `Doctores` (`id_doctor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProcedimientosMedicos`
--

LOCK TABLES `ProcedimientosMedicos` WRITE;
/*!40000 ALTER TABLE `ProcedimientosMedicos` DISABLE KEYS */;
/*!40000 ALTER TABLE `ProcedimientosMedicos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SeguimientoMedico`
--

DROP TABLE IF EXISTS `SeguimientoMedico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SeguimientoMedico` (
  `id_seguimiento` int(11) NOT NULL AUTO_INCREMENT,
  `paciente_id` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `observaciones` text DEFAULT NULL,
  PRIMARY KEY (`id_seguimiento`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `SeguimientoMedico_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Pacientes` (`id_paciente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SeguimientoMedico`
--

LOCK TABLES `SeguimientoMedico` WRITE;
/*!40000 ALTER TABLE `SeguimientoMedico` DISABLE KEYS */;
/*!40000 ALTER TABLE `SeguimientoMedico` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2024-11-30 17:01:55
