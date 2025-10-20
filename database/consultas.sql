-- Listados
SELECT id_campus, nombre FROM campus ORDER BY nombre;
SELECT id_carrera, nombre FROM carreras ORDER BY nombre;

-- Estudiantes
SELECT id_estudiante, nombre, email, campus_id, carrera_id, semestre, created_at
FROM estudiantes ORDER BY created_at DESC;

-- Docentes por carrera/semestre
SELECT id_docente, nombre, materia, carrera_id, semestre
FROM docentes WHERE carrera_id=@sis AND semestre=3 ORDER BY nombre;

-- Resultados agregados (mismos umbrales del backend)
SELECT
  d.id_docente, d.nombre, d.materia, d.carrera_id, d.semestre,
  ROUND(COALESCE(AVG(e.claridad), 0), 2) AS promedio_claridad,
  ROUND(COALESCE(AVG(e.puntualidad), 0), 2) AS promedio_puntualidad,
  ROUND(COALESCE(AVG(e.dominio_tema), 0), 2) AS promedio_dominio,
  ROUND(COALESCE(AVG(e.trato_estudiantes), 0), 2) AS promedio_trato,
  ROUND((
    COALESCE(AVG(e.claridad), 0) +
    COALESCE(AVG(e.puntualidad), 0) +
    COALESCE(AVG(e.dominio_tema), 0) +
    COALESCE(AVG(e.trato_estudiantes), 0)
  ) / 4, 2) AS calificacion_total,
  CASE
    WHEN COUNT(e.id_evaluacion) = 0 THEN 'Sin datos'
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
LEFT JOIN estudiantes s   ON s.id_estudiante = e.id_estudiante
-- filtros opcionales
-- WHERE s.campus_id = ? AND d.carrera_id = ? AND d.semestre = ?
GROUP BY d.id_docente, d.nombre, d.materia, d.carrera_id, d.semestre
ORDER BY d.nombre;

-- Métricas
-- 1) Campus que evalúan
SELECT c.nombre AS campus, COUNT(DISTINCT e.id_estudiante) AS alumnos
FROM campus c
JOIN estudiantes s ON s.campus_id = c.id_campus
JOIN evaluaciones e ON e.id_estudiante = s.id_estudiante
GROUP BY c.nombre ORDER BY c.nombre;

-- 2) Alumnos totales que evalúan
SELECT COUNT(DISTINCT id_estudiante) AS alumnos_que_evaluan FROM evaluaciones;

-- 3) Alumnos por campus
SELECT c.nombre AS campus, COUNT(DISTINCT e.id_estudiante) AS alumnos
FROM campus c
JOIN estudiantes s ON s.campus_id = c.id_campus
JOIN evaluaciones e ON e.id_estudiante = s.id_estudiante
GROUP BY c.nombre ORDER BY c.nombre;

-- 4) Alumnos por carrera
SELECT ca.nombre AS carrera, COUNT(DISTINCT e.id_estudiante) AS alumnos
FROM carreras ca
JOIN estudiantes s ON s.carrera_id = ca.id_carrera
JOIN evaluaciones e ON e.id_estudiante = s.id_estudiante
GROUP BY ca.nombre ORDER BY ca.nombre;

-- 5) Faltantes por campus/carrera/semestre
SELECT
  c.nombre AS campus,
  ca.nombre AS carrera,
  s.semestre,
  COUNT(*) AS alumnos_sin_evaluar
FROM estudiantes s
JOIN campus c   ON c.id_campus = s.campus_id
JOIN carreras ca ON ca.id_carrera = s.carrera_id
LEFT JOIN (SELECT DISTINCT id_estudiante FROM evaluaciones) ev
  ON ev.id_estudiante = s.id_estudiante
WHERE ev.id_estudiante IS NULL
GROUP BY c.nombre, ca.nombre, s.semestre
ORDER BY c.nombre, ca.nombre, s.semestre;
