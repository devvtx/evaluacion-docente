-- Reinicio
DROP DATABASE IF EXISTS evaluacion_docentes;
CREATE DATABASE evaluacion_docentes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE evaluacion_docentes;

-- Catálogos
CREATE TABLE campus (
  id_campus INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE carreras (
  id_carrera INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL UNIQUE
);

-- Estudiantes (se asocian a campus/carrera/semestre)
CREATE TABLE estudiantes (
  id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  campus_id INT NOT NULL,
  carrera_id INT NOT NULL,
  semestre TINYINT NOT NULL CHECK (semestre BETWEEN 1 AND 10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (campus_id) REFERENCES campus(id_campus),
  FOREIGN KEY (carrera_id) REFERENCES carreras(id_carrera)
);

-- Docentes están ligados a una carrera, semestre y materia
CREATE TABLE docentes (
  id_docente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  materia VARCHAR(120) NOT NULL,
  carrera_id INT NOT NULL,
  semestre TINYINT NOT NULL CHECK (semestre BETWEEN 1 AND 10),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (carrera_id) REFERENCES carreras(id_carrera)
);

-- Evaluaciones: 1 por estudiante-docente
CREATE TABLE evaluaciones (
  id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
  id_docente INT NOT NULL,
  id_estudiante INT NOT NULL,
  claridad TINYINT NOT NULL CHECK (claridad BETWEEN 1 AND 10),
  puntualidad TINYINT NOT NULL CHECK (puntualidad BETWEEN 1 AND 10),
  dominio_tema TINYINT NOT NULL CHECK (dominio_tema BETWEEN 1 AND 10),
  trato_estudiantes TINYINT NOT NULL CHECK (trato_estudiantes BETWEEN 1 AND 10),
  comentarios TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_eval (id_docente, id_estudiante),
  FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
  FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
);

-- Seed: Campus
INSERT INTO campus (nombre) VALUES
('UVM Lomas Verdes'),
('UVM Roma'),
('UVM Reforma');

-- Seed: Carreras
INSERT INTO carreras (nombre) VALUES
('Ingeniería en Sistemas Computacionales'),
('Ingeniería Industrial'),
('Ingeniería Automotriz');

-- IDs auxiliares
SET @sis = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería en Sistemas Computacionales');
SET @ind = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería Industrial');
SET @aut = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería Automotriz');

-- =========
-- DOCENTES por carrera y semestre
-- =========

-- Ingeniería Industrial (resumen completo de tu lista)
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Roberto Salgado','Cálculo Diferencial',@ind,1),
('Mariana Cortés','Fundamentos de Ingeniería Industrial',@ind,1),
('Héctor Vargas','Química',@ind,1),
('Elena Ramírez','Comunicación Profesional',@ind,1),
('Ricardo Pineda','Dibujo Industrial',@ind,1),

('Verónica Cabrera','Álgebra Lineal',@ind,2),
('Gerardo Espinosa','Física I',@ind,2),
('Santiago Cruz','Programación Aplicada',@ind,2),
('Patricia Nava','Administración General',@ind,2),
('José Antonio Nieto','Metrología',@ind,2),

('Liliana Torres','Cálculo Integral',@ind,3),
('Fernando Lozano','Procesos de Manufactura',@ind,3),
('Mónica Rojas','Ergonomía',@ind,3),
('Edgar Domínguez','Economía Empresarial',@ind,3),
('Gabriela Pacheco','Estadística Descriptiva',@ind,3),

('Arturo Jiménez','Ingeniería de Métodos',@ind,4),
('Lucía Vargas','Control de Calidad',@ind,4),
('César Aguilar','Probabilidad y Estadística',@ind,4),
('Rodrigo Morales','Física II',@ind,4),
('Rebeca Pérez','Seguridad Industrial',@ind,4),

('Luis Mendoza','Investigación de Operaciones I',@ind,5),
('Beatriz Castillo','Planeación y Control de la Producción',@ind,5),
('Humberto García','Simulación de Sistemas',@ind,5),
('Diana Ávila','Contabilidad de Costos',@ind,5),
('Carlos Gutiérrez','Ingeniería Económica',@ind,5),

('Karen López','Investigación de Operaciones II',@ind,6),
('Mario Ortega','Administración de Proyectos Industriales',@ind,6),
('Nancy Rivera','Logística',@ind,6),
('Jesús Bravo','Control Estadístico del Proceso',@ind,6),
('Adriana Silva','Desarrollo Sustentable',@ind,6),

('Pablo Hernández','Manufactura Esbelta',@ind,7),
('Claudia Rangel','Automatización Industrial',@ind,7),
('Omar Chávez','Gestión de la Calidad',@ind,7),
('Marisol Reyes','Planeación Estratégica',@ind,7),
('Andrés González','Ética y Responsabilidad Profesional',@ind,7),

('Paola Treviño','Sistemas Integrados de Manufactura',@ind,8),
('Ricardo Jiménez','Ingeniería de Plantas',@ind,8),
('Norma Figueroa','Mantenimiento Productivo Total',@ind,8),
('Manuel Castro','Gestión de Innovación',@ind,8),
('Andrea López','Auditoría de Procesos',@ind,8),

('Sergio Cabrera','Seminario de Titulación',@ind,9),
('Alicia Torres','Proyecto Integrador Industrial',@ind,9),
('Tomás Herrera','Calidad Total',@ind,9),
('Carmen Pérez','Emprendimiento Industrial',@ind,9),
('Germán Castillo','Competitividad Global',@ind,9);

-- Ingeniería Automotriz
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Ángel Durán','Matemáticas para Ingeniería',@aut,1),
('Estefanía Lara','Introducción a la Ingeniería Automotriz',@aut,1),
('Ricardo Morales','Física I',@aut,1),
('José Eduardo Pérez','Dibujo Mecánico',@aut,1),
('Laura Escalante','Química General',@aut,1),

('Víctor Ramírez','Cálculo Integral',@aut,2),
('Beatriz Martínez','Materiales para Ingeniería Automotriz',@aut,2),
('Mario Sánchez','Termodinámica',@aut,2),
('Héctor Mejía','Electricidad y Magnetismo',@aut,2),
('Rosa Aguilar','Comunicación y Liderazgo',@aut,2),

('Juan Pablo Torres','Mecánica Clásica',@aut,3),
('Lorena Flores','Álgebra Lineal',@aut,3),
('Fernando Castillo','Procesos de Manufactura',@aut,3),
('Yazmín Herrera','Dibujo Asistido por Computadora (CAD)',@aut,3),
('Carlos Rojas','Circuitos Eléctricos',@aut,3),

('Marcos Valdez','Dinámica de Vehículos',@aut,4),
('Claudia Martínez','Electrónica Automotriz',@aut,4),
('Jorge Pineda','Motores de Combustión Interna I',@aut,4),
('Elena Gutiérrez','Análisis de Esfuerzos',@aut,4),
('Rubén García','Estadística para Ingenieros',@aut,4),

('Israel Franco','Motores de Combustión Interna II',@aut,5),
('Marcela Rivas','Sistemas de Suspensión y Dirección',@aut,5),
('Enrique Torres','Mecánica de Fluidos',@aut,5),
('Cecilia González','Control Automotriz',@aut,5),
('Héctor Luna','Diseño Asistido por Computadora (CAM)',@aut,5),

('Daniel Ramírez','Transmisiones Automotrices',@aut,6),
('Paola Vargas','Electrónica de Potencia',@aut,6),
('Iván Navarro','Diagnóstico y Mantenimiento Automotriz',@aut,6),
('Teresa Aguilera','Sistemas de Frenos',@aut,6),
('Javier Salinas','Gestión de Talleres Automotrices',@aut,6),

('Sofía Ramírez','Innovación en Vehículos Híbridos',@aut,7),
('Alejandro Cruz','Sistemas de Control Electrónico',@aut,7),
('Patricia Romero','Diseño de Componentes Automotrices',@aut,7),
('Francisco López','Ingeniería de Pruebas',@aut,7),
('Dulce Sánchez','Legislación Automotriz',@aut,7),

('Héctor Olivares','Vehículos Eléctricos',@aut,8),
('Daniela Campos','Integración de Sistemas Automotrices',@aut,8),
('Guillermo Torres','Seguridad y Normatividad Vehicular',@aut,8),
('Raquel Jiménez','Gestión de Innovación Tecnológica',@aut,8),
('Néstor Gutiérrez','Diseño Ecológico de Vehículos',@aut,8),

('Mariana Díaz','Seminario de Titulación',@aut,9),
('Luis Cabrera','Proyecto Integrador Automotriz',@aut,9),
('Rodrigo Vargas','Gestión de Proyectos Automotrices',@aut,9),
('Julieta Morales','Emprendimiento en el Sector Automotriz',@aut,9),
('Emilio Hernández','Tendencias Futuras en Movilidad',@aut,9);

-- Ingeniería en Sistemas Computacionales (según tu lista provista)
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Uriel Villela','Fundamentos de Programación',@sis,1),
('Rafael Medina','Matemáticas Discretas',@sis,1),
('Giovanni Melo','Álgebra Lineal',@sis,1),
('Arizu Tovar','Introducción a la Ingeniería en Sistemas',@sis,1),
('Ana María Ortiz','Comunicación Oral y Escrita',@sis,1),

('José Luis Torres','Programación Estructurada',@sis,2),
('Laura Hernández','Cálculo Diferencial e Integral',@sis,2),
('Miguel Ángel Reyes','Lógica Computacional',@sis,2),
('Jorge Ramírez','Física para Ingenieros',@sis,2),
('Carolina Gómez','Taller de Ética Profesional',@sis,2),

('Uriel Villela','Programación Orientada a Objetos',@sis,3),
('Rafael Medina','Estructura de Datos',@sis,3),
('Giovanni Melo','Arquitectura de Computadoras',@sis,3),
('Arizu Tovar','Bases de Datos I',@sis,3),
('Alejandro López','Probabilidad y Estadística',@sis,3),

('Uriel Villela','Bases de Datos II',@sis,4),
('Rafael Medina','Sistemas Operativos',@sis,4),
('Giovanni Melo','Programación Web',@sis,4),
('Arizu Tovar','Redes de Computadoras I',@sis,4),
('Luis Fernando Cruz','Métodos Numéricos',@sis,4),

('Uriel Villela','Ingeniería de Software I',@sis,5),
('Rafael Medina','Redes de Computadoras II',@sis,5),
('Giovanni Melo','Administración de Bases de Datos',@sis,5),
('Arizu Tovar','Análisis de Algoritmos',@sis,5),
('María Fernanda Díaz','Desarrollo de Aplicaciones de Escritorio',@sis,5),

('Uriel Villela','Ingeniería de Software II',@sis,6),
('Rafael Medina','Programación de Dispositivos Móviles',@sis,6),
('Giovanni Melo','Seguridad Informática',@sis,6),
('Arizu Tovar','Administración de Proyectos de TI',@sis,6),
('Daniela Hernández','Interacción Humano-Computadora',@sis,6),

('Uriel Villela','Inteligencia Artificial',@sis,7),
('Rafael Medina','Computación en la Nube',@sis,7),
('Giovanni Melo','Integración de Sistemas',@sis,7),
('Arizu Tovar','Gestión de Servicios de TI (ITIL)',@sis,7),
('Claudia Sánchez','Emprendimiento Tecnológico',@sis,7),

('Uriel Villela','Minería de Datos',@sis,8),
('Rafael Medina','Internet de las Cosas (IoT)',@sis,8),
('Giovanni Melo','Desarrollo de Software Empresarial',@sis,8),
('Arizu Tovar','Auditoría de Sistemas',@sis,8),
('Luis Alberto Romero','Arquitectura de Software',@sis,8),

('Uriel Villela','Seminario de Titulación',@sis,9),
('Rafael Medina','Proyecto Integrador de Sistemas',@sis,9),
('Giovanni Melo','Computación Avanzada',@sis,9),
('Arizu Tovar','Ética y Responsabilidad Profesional',@sis,9),
('Sofía Rivera','Innovación y Transformación Digital',@sis,9);

-- Procedimiento: estado por docente con umbrales
DELIMITER //
CREATE PROCEDURE sp_resultados_docentes(
  IN p_campus_id INT,
  IN p_carrera_id INT,
  IN p_semestre TINYINT
)
BEGIN
  SELECT
    d.id_docente, d.nombre, d.materia, d.carrera_id, d.semestre,
    ROUND(COALESCE(AVG(e.claridad),0),2) AS promedio_claridad,
    ROUND(COALESCE(AVG(e.puntualidad),0),2) AS promedio_puntualidad,
    ROUND(COALESCE(AVG(e.dominio_tema),0),2) AS promedio_dominio,
    ROUND(COALESCE(AVG(e.trato_estudiantes),0),2) AS promedio_trato,
    ROUND((
      COALESCE(AVG(e.claridad),0)+
      COALESCE(AVG(e.puntualidad),0)+
      COALESCE(AVG(e.dominio_tema),0)+
      COALESCE(AVG(e.trato_estudiantes),0)
    )/4,2) AS calificacion_total,
    CASE
      WHEN COUNT(e.id_evaluacion)=0 THEN 'Sin datos'
      WHEN (
        (COALESCE(AVG(e.claridad),0)+COALESCE(AVG(e.puntualidad),0)+COALESCE(AVG(e.dominio_tema),0)+COALESCE(AVG(e.trato_estudiantes),0))/4
      ) >= 8.5 THEN 'Candidato a asignación'
      WHEN (
        (COALESCE(AVG(e.claridad),0)+COALESCE(AVG(e.puntualidad),0)+COALESCE(AVG(e.dominio_tema),0)+COALESCE(AVG(e.trato_estudiantes),0))/4
      ) >= 7 THEN 'En valoración'
      ELSE 'Sin asignación'
    END AS estado
  FROM docentes d
  LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
  LEFT JOIN estudiantes s ON s.id_estudiante = e.id_estudiante
  WHERE (p_carrera_id IS NULL OR d.carrera_id = p_carrera_id)
    AND (p_semestre   IS NULL OR d.semestre   = p_semestre)
    AND (p_campus_id  IS NULL OR s.campus_id  = p_campus_id)
  GROUP BY d.id_docente, d.nombre, d.materia, d.carrera_id, d.semestre
  ORDER BY d.nombre ASC;
END//
DELIMITER ;
