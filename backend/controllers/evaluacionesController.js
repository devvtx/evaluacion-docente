const db = require("../models/db");

// Guardar evaluación
exports.guardarEvaluacion = (req, res) => {
  const { id_docente, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios } = req.body;

  const sql = `INSERT INTO evaluaciones 
    (id_docente, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios) 
    VALUES (?, ?, ?, ?, ?, ?)`;

  db.query(sql, [id_docente, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios], (err) => {
    if (err) {
      console.error("❌ Error al guardar evaluación:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json({ success: true, message: "✅ Evaluación guardada correctamente" });
  });
};

// Obtener resultados (con total de evaluaciones por docente)
exports.obtenerResultados = (req, res) => {
  const sql = `
    SELECT d.nombre, d.materia,
           COUNT(e.id_evaluacion) AS total_evaluaciones,
           AVG(e.claridad) AS promedio_claridad,
           AVG(e.puntualidad) AS promedio_puntualidad,
           AVG(e.dominio_tema) AS promedio_dominio,
           AVG(e.trato_estudiantes) AS promedio_trato
    FROM docentes d
    LEFT JOIN evaluaciones e ON d.id_docente = e.id_docente
    GROUP BY d.id_docente
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error("❌ Error al obtener resultados:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json(results);
  });
};

// Obtener docentes
exports.obtenerDocentes = (req, res) => {
  const sql = "SELECT * FROM docentes";
  db.query(sql, (err, results) => {
    if (err) {
      console.error("❌ Error al obtener docentes:", err);
      return res.status(500).json({ success: false, message: "Error en el servidor" });
    }
    res.json(results);
  });
};
