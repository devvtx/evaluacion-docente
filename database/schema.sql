
-- (Reinstala todo para pruebas locales; elimina en producción si ya tienes data)
DROP DATABASE IF EXISTS evaluacion_docentes;
CREATE DATABASE evaluacion_docentes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE evaluacion_docentes;


-- Tabla: estudiantes (usuarios del sistema)

CREATE TABLE estudiantes (
  id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  email VARCHAR(120) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Tabla: docentes

CREATE TABLE docentes (
  id_docente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  materia VARCHAR(120) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Tabla: evaluaciones
-- 1 registro por estudiante y por docente (único)
-- Notas en escala 1..10

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
  CONSTRAINT fk_eval_docente FOREIGN KEY (id_docente) REFERENCES docentes(id_docente),
  CONSTRAINT fk_eval_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)
);


-- Docentes de ejemplo

INSERT INTO docentes (nombre, materia) VALUES
('Lionel Messi', 'Redes de Computadoras Avanzadas'),
('Cristiano Ronaldo', 'Ciberseguridad y Criptografía'),
('Kylian Mbappé', 'Inteligencia Artificial y Machine Learning'),
('Andrés Iniesta', 'Bases de Datos Distribuidas'),
('Ronaldinho Gaúcho', 'Arquitectura de Computadoras y Ensamblador'),
('Zinedine Zidane', 'Compiladores y Lenguajes de Programación'),
('Paolo Maldini', 'Seguridad en Redes y Protocolos'),
('Iker Casillas', 'Sistemas Operativos Avanzados'),
('David Beckham', 'Ingeniería de Software y Metodologías Ágiles'),
('Thierry Henry', 'Algoritmos y Estructuras de Datos');
