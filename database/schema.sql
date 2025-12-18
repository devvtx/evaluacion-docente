DROP DATABASE IF EXISTS evaluacion_docentes;
CREATE DATABASE evaluacion_docentes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE evaluacion_docentes;

CREATE TABLE campus (
  id_campus INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE carreras (
  id_carrera INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE estudiantes (
  id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  campus_id INT NOT NULL,
  carrera_id INT NOT NULL,
  semestre TINYINT NOT NULL,
  es_intercambio TINYINT NOT NULL DEFAULT 0,
  universidad_origen VARCHAR(160) NULL,
  programa_origen VARCHAR(160) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (campus_id) REFERENCES campus(id_campus),
  FOREIGN KEY (carrera_id) REFERENCES carreras(id_carrera)
);

CREATE TABLE docentes (
  id_docente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(120) NOT NULL,
  materia VARCHAR(160) NOT NULL,
  carrera_id INT NOT NULL,
  semestre TINYINT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (carrera_id) REFERENCES carreras(id_carrera),
  INDEX idx_docentes_filtro (carrera_id, semestre)
);

CREATE TABLE evaluaciones (
  id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
  id_docente INT NOT NULL,
  id_estudiante INT NOT NULL,
  claridad TINYINT NOT NULL,
  puntualidad TINYINT NOT NULL,
  dominio_tema TINYINT NOT NULL,
  trato_estudiantes TINYINT NOT NULL,
  comentarios TEXT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uniq_eval (id_docente, id_estudiante),
  FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
  FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
);

INSERT INTO campus (nombre) VALUES
('UVM Lomas Verdes'),
('UVM Roma'),
('UVM Reforma');

INSERT INTO carreras (nombre) VALUES
('Ingeniería en Sistemas Computacionales'),
('Ingeniería Industrial'),
('Ingeniería Automotriz');

SET @sis = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería en Sistemas Computacionales');
SET @ind = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería Industrial');
SET @aut = (SELECT id_carrera FROM carreras WHERE nombre='Ingeniería Automotriz');

-- ==========================
-- Ingeniería Industrial (tus datos + completado a 7 por semestre + semestre 10)
-- ==========================
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Roberto Salgado','Cálculo Diferencial',@ind,1),
('Mariana Cortés','Fundamentos de Ingeniería Industrial',@ind,1),
('Héctor Vargas','Química',@ind,1),
('Elena Ramírez','Comunicación Profesional',@ind,1),
('Ricardo Pineda','Dibujo Industrial',@ind,1),
('Roberto Salgado','Introducción a Procesos Industriales',@ind,1),
('Mariana Cortés','Herramientas Digitales para Ingeniería',@ind,1),

('Verónica Cabrera','Álgebra Lineal',@ind,2),
('Gerardo Espinosa','Física I',@ind,2),
('Santiago Cruz','Programación Aplicada',@ind,2),
('Patricia Nava','Administración General',@ind,2),
('José Antonio Nieto','Metrología',@ind,2),
('Verónica Cabrera','Estadística Básica',@ind,2),
('Gerardo Espinosa','Dibujo Técnico',@ind,2),

('Liliana Torres','Cálculo Integral',@ind,3),
('Fernando Lozano','Procesos de Manufactura',@ind,3),
('Mónica Rojas','Ergonomía',@ind,3),
('Edgar Domínguez','Economía Empresarial',@ind,3),
('Gabriela Pacheco','Estadística Descriptiva',@ind,3),
('Fernando Lozano','Materiales Industriales',@ind,3),
('Liliana Torres','Investigación y Reportes Técnicos',@ind,3),

('Arturo Jiménez','Ingeniería de Métodos',@ind,4),
('Lucía Vargas','Control de Calidad',@ind,4),
('César Aguilar','Probabilidad y Estadística',@ind,4),
('Rodrigo Morales','Física II',@ind,4),
('Rebeca Pérez','Seguridad Industrial',@ind,4),
('Arturo Jiménez','Diseño de Plantas I',@ind,4),
('Lucía Vargas','Gestión de Procesos',@ind,4),

('Luis Mendoza','Investigación de Operaciones I',@ind,5),
('Beatriz Castillo','Planeación y Control de la Producción',@ind,5),
('Humberto García','Simulación de Sistemas',@ind,5),
('Diana Ávila','Contabilidad de Costos',@ind,5),
('Carlos Gutiérrez','Ingeniería Económica',@ind,5),
('Beatriz Castillo','Diseño de Plantas II',@ind,5),
('Luis Mendoza','Cadena de Suministro I',@ind,5),

('Karen López','Investigación de Operaciones II',@ind,6),
('Mario Ortega','Administración de Proyectos Industriales',@ind,6),
('Nancy Rivera','Logística',@ind,6),
('Jesús Bravo','Control Estadístico del Proceso',@ind,6),
('Adriana Silva','Desarrollo Sustentable',@ind,6),
('Nancy Rivera','Cadena de Suministro II',@ind,6),
('Mario Ortega','Gestión de Riesgos en Proyectos',@ind,6),

('Pablo Hernández','Manufactura Esbelta',@ind,7),
('Claudia Rangel','Automatización Industrial',@ind,7),
('Omar Chávez','Gestión de la Calidad',@ind,7),
('Marisol Reyes','Planeación Estratégica',@ind,7),
('Andrés González','Ética y Responsabilidad Profesional',@ind,7),
('Pablo Hernández','Mejora Continua (Kaizen)',@ind,7),
('Claudia Rangel','Instrumentación Industrial',@ind,7),

('Paola Treviño','Sistemas Integrados de Manufactura',@ind,8),
('Ricardo Jiménez','Ingeniería de Plantas',@ind,8),
('Norma Figueroa','Mantenimiento Productivo Total',@ind,8),
('Manuel Castro','Gestión de Innovación',@ind,8),
('Andrea López','Auditoría de Procesos',@ind,8),
('Norma Figueroa','Gestión de Activos Industriales',@ind,8),
('Manuel Castro','Transformación Digital Industrial',@ind,8),

('Sergio Cabrera','Seminario de Titulación',@ind,9),
('Alicia Torres','Proyecto Integrador Industrial',@ind,9),
('Tomás Herrera','Calidad Total',@ind,9),
('Carmen Pérez','Emprendimiento Industrial',@ind,9),
('Germán Castillo','Competitividad Global',@ind,9),
('Alicia Torres','Gestión del Cambio Organizacional',@ind,9),
('Tomás Herrera','Auditorías y Normas ISO',@ind,9),

('Sergio Cabrera','Proyecto de Titulación Industrial',@ind,10),
('Alicia Torres','Evaluación de Proyectos Industriales',@ind,10),
('Tomás Herrera','Dirección de Operaciones',@ind,10),
('Carmen Pérez','Innovación y Emprendimiento Avanzado',@ind,10),
('Germán Castillo','Estrategia y Competitividad Avanzada',@ind,10),
('Nancy Rivera','Logística Internacional',@ind,10),
('Mario Ortega','Gestión de Portafolio de Proyectos',@ind,10);

-- ==========================
-- Ingeniería Automotriz (tus datos + completado a 7 por semestre + semestre 10)
-- ==========================
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Ángel Durán','Matemáticas para Ingeniería',@aut,1),
('Estefanía Lara','Introducción a la Ingeniería Automotriz',@aut,1),
('Ricardo Morales','Física I',@aut,1),
('José Eduardo Pérez','Dibujo Mecánico',@aut,1),
('Laura Escalante','Química General',@aut,1),
('Ángel Durán','Herramientas de Ingeniería',@aut,1),
('Estefanía Lara','Comunicación Técnica',@aut,1),

('Víctor Ramírez','Cálculo Integral',@aut,2),
('Beatriz Martínez','Materiales para Ingeniería Automotriz',@aut,2),
('Mario Sánchez','Termodinámica',@aut,2),
('Héctor Mejía','Electricidad y Magnetismo',@aut,2),
('Rosa Aguilar','Comunicación y Liderazgo',@aut,2),
('Víctor Ramírez','Estadística para Ingeniería',@aut,2),
('Héctor Mejía','Electrónica Básica',@aut,2),

('Juan Pablo Torres','Mecánica Clásica',@aut,3),
('Lorena Flores','Álgebra Lineal',@aut,3),
('Fernando Castillo','Procesos de Manufactura',@aut,3),
('Yazmín Herrera','Dibujo Asistido por Computadora (CAD)',@aut,3),
('Carlos Rojas','Circuitos Eléctricos',@aut,3),
('Juan Pablo Torres','Resistencia de Materiales',@aut,3),
('Carlos Rojas','Sensores y Actuadores',@aut,3),

('Marcos Valdez','Dinámica de Vehículos',@aut,4),
('Claudia Martínez','Electrónica Automotriz',@aut,4),
('Jorge Pineda','Motores de Combustión Interna I',@aut,4),
('Elena Gutiérrez','Análisis de Esfuerzos',@aut,4),
('Rubén García','Estadística para Ingenieros',@aut,4),
('Marcos Valdez','Sistemas de Chasis',@aut,4),
('Claudia Martínez','Diagnóstico Electrónico I',@aut,4),

('Israel Franco','Motores de Combustión Interna II',@aut,5),
('Marcela Rivas','Sistemas de Suspensión y Dirección',@aut,5),
('Enrique Torres','Mecánica de Fluidos',@aut,5),
('Cecilia González','Control Automotriz',@aut,5),
('Héctor Luna','Diseño Asistido por Computadora (CAM)',@aut,5),
('Israel Franco','Sistemas de Admisión y Escape',@aut,5),
('Cecilia González','Diagnóstico Electrónico II',@aut,5),

('Daniel Ramírez','Transmisiones Automotrices',@aut,6),
('Paola Vargas','Electrónica de Potencia',@aut,6),
('Iván Navarro','Diagnóstico y Mantenimiento Automotriz',@aut,6),
('Teresa Aguilera','Sistemas de Frenos',@aut,6),
('Javier Salinas','Gestión de Talleres Automotrices',@aut,6),
('Daniel Ramírez','Sistemas de Tracción',@aut,6),
('Paola Vargas','Redes CAN/LIN Automotrices',@aut,6),

('Sofía Ramírez','Innovación en Vehículos Híbridos',@aut,7),
('Alejandro Cruz','Sistemas de Control Electrónico',@aut,7),
('Patricia Romero','Diseño de Componentes Automotrices',@aut,7),
('Francisco López','Ingeniería de Pruebas',@aut,7),
('Dulce Sánchez','Legislación Automotriz',@aut,7),
('Alejandro Cruz','Seguridad Funcional (Automotriz)',@aut,7),
('Francisco López','Validación y Calibración',@aut,7),

('Héctor Olivares','Vehículos Eléctricos',@aut,8),
('Daniela Campos','Integración de Sistemas Automotrices',@aut,8),
('Guillermo Torres','Seguridad y Normatividad Vehicular',@aut,8),
('Raquel Jiménez','Gestión de Innovación Tecnológica',@aut,8),
('Néstor Gutiérrez','Diseño Ecológico de Vehículos',@aut,8),
('Héctor Olivares','Baterías y Sistemas de Carga',@aut,8),
('Guillermo Torres','Normas y Certificaciones',@aut,8),

('Mariana Díaz','Seminario de Titulación',@aut,9),
('Luis Cabrera','Proyecto Integrador Automotriz',@aut,9),
('Rodrigo Vargas','Gestión de Proyectos Automotrices',@aut,9),
('Julieta Morales','Emprendimiento en el Sector Automotriz',@aut,9),
('Emilio Hernández','Tendencias Futuras en Movilidad',@aut,9),
('Rodrigo Vargas','Gestión de Calidad Automotriz',@aut,9),
('Luis Cabrera','Integración de Sistemas Avanzados',@aut,9),

('Mariana Díaz','Proyecto de Titulación Automotriz',@aut,10),
('Luis Cabrera','Diseño de Tren Motriz Avanzado',@aut,10),
('Rodrigo Vargas','Dirección de Programas Automotrices',@aut,10),
('Julieta Morales','Innovación y Negocios de Movilidad',@aut,10),
('Emilio Hernández','Estrategia Tecnológica en Movilidad',@aut,10),
('Daniela Campos','Arquitectura Eléctrica Vehicular',@aut,10),
('Néstor Gutiérrez','Sustentabilidad y Movilidad',@aut,10);

-- ==========================
-- Ingeniería en Sistemas Computacionales (tus datos + completado a 7 por semestre + semestre 10)
-- ==========================
INSERT INTO docentes (nombre, materia, carrera_id, semestre) VALUES
('Uriel Villela','Fundamentos de Programación',@sis,1),
('Rafael Medina','Matemáticas Discretas',@sis,1),
('Giovanni Melo','Álgebra Lineal',@sis,1),
('Arizu Tovar','Introducción a la Ingeniería en Sistemas',@sis,1),
('Ana María Ortiz','Comunicación Oral y Escrita',@sis,1),
('Uriel Villela','Pensamiento Computacional',@sis,1),
('Giovanni Melo','Herramientas Digitales',@sis,1),

('José Luis Torres','Programación Estructurada',@sis,2),
('Laura Hernández','Cálculo Diferencial e Integral',@sis,2),
('Miguel Ángel Reyes','Lógica Computacional',@sis,2),
('Jorge Ramírez','Física para Ingenieros',@sis,2),
('Carolina Gómez','Taller de Ética Profesional',@sis,2),
('José Luis Torres','Programación Modular',@sis,2),
('Miguel Ángel Reyes','Matemáticas para Computación',@sis,2),

('Uriel Villela','Programación Orientada a Objetos',@sis,3),
('Rafael Medina','Estructura de Datos',@sis,3),
('Giovanni Melo','Arquitectura de Computadoras',@sis,3),
('Arizu Tovar','Bases de Datos I',@sis,3),
('Alejandro López','Probabilidad y Estadística',@sis,3),
('Rafael Medina','Análisis y Diseño de Algoritmos',@sis,3),
('Giovanni Melo','Sistemas Digitales',@sis,3),

('Uriel Villela','Bases de Datos II',@sis,4),
('Rafael Medina','Sistemas Operativos',@sis,4),
('Giovanni Melo','Programación Web',@sis,4),
('Arizu Tovar','Redes de Computadoras I',@sis,4),
('Luis Fernando Cruz','Métodos Numéricos',@sis,4),
('Uriel Villela','Bases de Datos Avanzada I',@sis,4),
('Rafael Medina','Seguridad en Sistemas Operativos',@sis,4),

('Uriel Villela','Ingeniería de Software I',@sis,5),
('Rafael Medina','Redes de Computadoras II',@sis,5),
('Giovanni Melo','Administración de Bases de Datos',@sis,5),
('Arizu Tovar','Análisis de Algoritmos',@sis,5),
('María Fernanda Díaz','Desarrollo de Aplicaciones de Escritorio',@sis,5),
('Uriel Villela','Bases de Datos Avanzada II',@sis,5),
('Giovanni Melo','Desarrollo Backend I',@sis,5),

('Uriel Villela','Ingeniería de Software II',@sis,6),
('Rafael Medina','Programación de Dispositivos Móviles',@sis,6),
('Giovanni Melo','Seguridad Informática',@sis,6),
('Arizu Tovar','Administración de Proyectos de TI',@sis,6),
('Daniela Hernández','Interacción Humano-Computadora',@sis,6),
('Rafael Medina','DevOps y Automatización',@sis,6),
('Giovanni Melo','Desarrollo Backend II',@sis,6),

('Uriel Villela','Inteligencia Artificial',@sis,7),
('Rafael Medina','Computación en la Nube',@sis,7),
('Giovanni Melo','Integración de Sistemas',@sis,7),
('Arizu Tovar','Gestión de Servicios de TI (ITIL)',@sis,7),
('Claudia Sánchez','Emprendimiento Tecnológico',@sis,7),
('Uriel Villela','Machine Learning I',@sis,7),
('Rafael Medina','Arquitectura Cloud',@sis,7),

('Uriel Villela','Minería de Datos',@sis,8),
('Rafael Medina','Internet de las Cosas (IoT)',@sis,8),
('Giovanni Melo','Desarrollo de Software Empresarial',@sis,8),
('Arizu Tovar','Auditoría de Sistemas',@sis,8),
('Luis Alberto Romero','Arquitectura de Software',@sis,8),
('Rafael Medina','Ciberseguridad Aplicada',@sis,8),
('Giovanni Melo','Integración Continua (CI/CD)',@sis,8),

('Uriel Villela','Seminario de Titulación',@sis,9),
('Rafael Medina','Proyecto Integrador de Sistemas',@sis,9),
('Giovanni Melo','Computación Avanzada',@sis,9),
('Arizu Tovar','Ética y Responsabilidad Profesional',@sis,9),
('Sofía Rivera','Innovación y Transformación Digital',@sis,9),
('Rafael Medina','Gobierno de TI',@sis,9),
('Giovanni Melo','Arquitectura Empresarial',@sis,9),

('Uriel Villela','Proyecto de Titulación en Sistemas',@sis,10),
('Rafael Medina','Arquitectura de Soluciones',@sis,10),
('Giovanni Melo','Seguridad Avanzada y Respuesta a Incidentes',@sis,10),
('Arizu Tovar','Dirección de Tecnología',@sis,10),
('Sofía Rivera','Innovación Tecnológica Avanzada',@sis,10),
('Rafael Medina','Cloud Security',@sis,10),
('Giovanni Melo','Ingeniería de Plataformas',@sis,10);
