-- A1) Todos los docentes
SELECT id_docente, nombre, materia
FROM docentes
ORDER BY nombre;

-- A2) Todos los estudiantes
SELECT id_estudiante, nombre, email, created_at
FROM estudiantes
ORDER BY created_at DESC;

-- A3) Todas las evaluaciones (con nombres)
SELECT e.id_evaluacion, d.nombre AS docente, d.materia,
       s.nombre AS estudiante,
       e.claridad, e.puntualidad, e.dominio_tema, e.trato_estudiantes,
       e.comentarios, e.created_at
FROM evaluaciones e
JOIN docentes d    ON d.id_docente = e.id_docente
JOIN estudiantes s ON s.id_estudiante = e.id_estudiante
ORDER BY e.created_at DESC;


-- B1) Promedios + estado (igual que usa el backend)
SELECT
  d.id_docente,
  d.nombre,
  d.materia,
  ROUND(COALESCE(AVG(e.claridad), 0), 2)        AS promedio_claridad,
  ROUND(COALESCE(AVG(e.puntualidad), 0), 2)     AS promedio_puntualidad,
  ROUND(COALESCE(AVG(e.dominio_tema), 0), 2)    AS promedio_dominio,
  ROUND(COALESCE(AVG(e.trato_estudiantes), 0),  2) AS promedio_trato,
  ROUND((
    COALESCE(AVG(e.claridad), 0) +
    COALESCE(AVG(e.puntualidad), 0) +
    COALESCE(AVG(e.dominio_tema), 0) +
    COALESCE(AVG(e.trato_estudiantes), 0)
  ) / 4, 2) AS calificacion_total,
  CASE
    WHEN COUNT(e.id_evaluacion) = 0 THEN 'Sin datos'
    WHEN (
      (
        COALESCE(AVG(e.claridad), 0) +
        COALESCE(AVG(e.puntualidad), 0) +
        COALESCE(AVG(e.dominio_tema), 0) +
        COALESCE(AVG(e.trato_estudiantes), 0)
      ) / 4
    ) < 7 THEN 'Inactivo'
    ELSE 'Activo'
  END AS estado,
  COUNT(e.id_evaluacion) AS total_evaluaciones
FROM docentes d
LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
GROUP BY d.id_docente, d.nombre, d.materia
ORDER BY d.nombre;

-- B2) Sólo INACTIVOS (calificación total < 7)
WITH res AS (
  SELECT d.id_docente, d.nombre, d.materia,
         (
           (COALESCE(AVG(e.claridad),0) +
            COALESCE(AVG(e.puntualidad),0) +
            COALESCE(AVG(e.dominio_tema),0) +
            COALESCE(AVG(e.trato_estudiantes),0))/4
         ) AS total
  FROM docentes d
  LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
  GROUP BY d.id_docente, d.nombre, d.materia
)
SELECT *, ROUND(total,2) AS calificacion_total
FROM res
WHERE total < 7;

-- B3) Top 5 por calificación total (desc)
SELECT d.id_docente, d.nombre, d.materia,
       ROUND((
         AVG(e.claridad)+AVG(e.puntualidad)+AVG(e.dominio_tema)+AVG(e.trato_estudiantes)
       )/4, 2) AS calificacion_total
FROM docentes d
LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
GROUP BY d.id_docente, d.nombre, d.materia
ORDER BY calificacion_total DESC
LIMIT 5;


