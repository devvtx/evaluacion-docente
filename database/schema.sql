-- ========================================================
-- 📚 Sistema de Evaluación Docente - Esquema de Base de Datos
-- Autor: devvtx
-- ========================================================

-- Eliminar la base de datos si ya existe (para instalación limpia)
DROP DATABASE IF EXISTS evaluacion_docentes;

-- Crear la base de datos
CREATE DATABASE evaluacion_docentes CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

-- Usar la base de datos
USE evaluacion_docentes;

-- =========================
-- Tabla: docentes
-- =========================
CREATE TABLE docentes (
    id_docente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    materia VARCHAR(100) NOT NULL
);

-- =========================
-- Tabla: evaluaciones
-- =========================
CREATE TABLE evaluaciones (
    id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    id_docente INT NOT NULL,
    claridad INT CHECK (claridad BETWEEN 1 AND 5),
    puntualidad INT CHECK (puntualidad BETWEEN 1 AND 5),
    dominio_tema INT CHECK (dominio_tema BETWEEN 1 AND 5),
    trato_estudiantes INT CHECK (trato_estudiantes BETWEEN 1 AND 5),
    comentarios TEXT,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente) ON DELETE CASCADE
);

-- =========================
-- Insertar docentes de ejemplo
-- =========================
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
