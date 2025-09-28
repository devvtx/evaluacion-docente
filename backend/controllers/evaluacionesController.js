const db = require("../models/db");

// Guardar / Actualizar evaluación (requiere auth)
exports.guardarEvaluacion = (req, res) => {
  const { id_estudiante } = req.user || {};
  const { id_docente, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios } = req.body;

  if (!id_estudiante) {
    return res.status(401).json({ success: false, message: "No autorizado" });
  }
  if (!id_docente || !claridad || !puntualidad || !dominio_tema || !trato_estudiantes) {
    return res.status(400).json({ success: false, message: "Faltan datos de la evaluación" });
  }

  // Upsert por par (docente, estudiante)
  const sql = `
    INSERT INTO evaluaciones (id_docente, id_estudiante, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
      claridad = VALUES(claridad),
      puntualidad = VALUES(puntualidad),
      dominio_tema = VALUES(dominio_tema),
      trato_estudiantes = VALUES(trato_estudiantes),
      comentarios = VALUES(comentarios),
      created_at = CURRENT_TIMESTAMP
  `;

  db.query(sql, [id_docente, id_estudiante, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios || null], (err) => {
    if (err) {
      console.error("❌ Error al guardar evaluación:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json({ success: true, message: "✅ Evaluación guardada correctamente" });
  });
};

// Resultados agregados por docente (promedios y estado)
exports.obtenerResultados = (req, res) => {
  const sql = `
    SELECT
      d.id_docente,
      d.nombre,
      d.materia,
      ROUND(COALESCE(AVG(e.claridad), 0), 2)       AS promedio_claridad,
      ROUND(COALESCE(AVG(e.puntualidad), 0), 2)    AS promedio_puntualidad,
      ROUND(COALESCE(AVG(e.dominio_tema), 0), 2)   AS promedio_dominio,
      ROUND(COALESCE(AVG(e.trato_estudiantes), 0),2) AS promedio_trato,
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
      END AS estado
    FROM docentes d
    LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
    GROUP BY d.id_docente, d.nombre, d.materia
    ORDER BY d.nombre ASC
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error("❌ Error al obtener resultados:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json(results);
  });
};

// Obtener listado de docentes
exports.obtenerDocentes = (req, res) => {
  const sql = "SELECT id_docente, nombre, materia FROM docentes ORDER BY nombre ASC";
  db.query(sql, (err, results) => {
    if (err) {
      console.error("❌ Error al obtener docentes:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json(results);
  });
};
