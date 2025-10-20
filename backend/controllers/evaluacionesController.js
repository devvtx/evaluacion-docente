const db = require("../models/db");

// Guardar / Actualizar evaluación. Valida carrera/semestre del docente = alumno.
exports.guardarEvaluacion = (req, res) => {
  const { id_estudiante, carrera_id: carreraAlumno, semestre: semestreAlumno } = req.user || {};
  const { id_docente, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios } = req.body;

  if (!id_estudiante) return res.status(401).json({ success: false, message: "No autorizado" });
  if (!id_docente || !claridad || !puntualidad || !dominio_tema || !trato_estudiantes) {
    return res.status(400).json({ success: false, message: "Faltan datos de la evaluación" });
  }

  // Verificar que el docente pertenezca a la misma carrera y semestre del alumno
  const qCheck = "SELECT carrera_id, semestre FROM docentes WHERE id_docente = ?";
  db.query(qCheck, [id_docente], (err, rows) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    if (rows.length === 0) return res.status(404).json({ success: false, message: "Docente no encontrado" });

    const { carrera_id: carreraDoc, semestre: semestreDoc } = rows[0];
    if (Number(carreraDoc) !== Number(carreraAlumno) || Number(semestreDoc) !== Number(semestreAlumno)) {
      return res.status(403).json({ success: false, message: "No puedes evaluar docentes de otra carrera o semestre" });
    }

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
    db.query(
      sql,
      [id_docente, id_estudiante, claridad, puntualidad, dominio_tema, trato_estudiantes, comentarios || null],
      (err2) => {
        if (err2) return res.status(500).json({ success: false, message: "Error al guardar" });
        res.json({ success: true, message: "Evaluación guardada" });
      }
    );
  });
};

// Docentes disponibles PARA EL ALUMNO AUTENTICADO.
// Siempre filtra por la carrera y semestre del alumno, ignorando query externa.
exports.obtenerDocentes = (req, res) => {
  const { carrera_id, semestre } = req.user || {};
  if (!carrera_id || !semestre) {
    return res.status(401).json({ success: false, message: "No autorizado" });
  }
  const sql = `
    SELECT id_docente, nombre, materia, carrera_id, semestre
    FROM docentes
    WHERE carrera_id = ? AND semestre = ?
    ORDER BY nombre ASC
  `;
  db.query(sql, [Number(carrera_id), Number(semestre)], (err, results) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    res.json(results);
  });
};

// Resultados agregados con filtros opcionales (público)
exports.obtenerResultados = (req, res) => {
  const { campus_id, carrera_id, semestre } = req.query;

  const params = [];
  const whereDoc = [];
  const whereEst = [];

  if (carrera_id) { whereDoc.push("d.carrera_id = ?"); params.push(Number(carrera_id)); }
  if (semestre)   { whereDoc.push("d.semestre = ?");   params.push(Number(semestre)); }
  if (campus_id)  { whereEst.push("s.campus_id = ?");  params.push(Number(campus_id)); }

  const whereDocSQL = whereDoc.length ? " AND " + whereDoc.join(" AND ") : "";
  const whereEstSQL = whereEst.length ? " AND " + whereEst.join(" AND ") : "";

  const sql = `
    SELECT
      d.id_docente,
      d.nombre,
      d.materia,
      d.carrera_id,
      d.semestre,
      ROUND(COALESCE(AVG(e.claridad), 0), 2)          AS promedio_claridad,
      ROUND(COALESCE(AVG(e.puntualidad), 0), 2)       AS promedio_puntualidad,
      ROUND(COALESCE(AVG(e.dominio_tema), 0), 2)      AS promedio_dominio,
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
          (
            COALESCE(AVG(e.claridad), 0) +
            COALESCE(AVG(e.puntualidad), 0) +
            COALESCE(AVG(e.dominio_tema), 0) +
            COALESCE(AVG(e.trato_estudiantes), 0)
          ) / 4
        ) >= 8.5 THEN 'Candidato a asignación'
        WHEN (
          (
            COALESCE(AVG(e.claridad), 0) +
            COALESCE(AVG(e.puntualidad), 0) +
            COALESCE(AVG(e.dominio_tema), 0) +
            COALESCE(AVG(e.trato_estudiantes), 0)
          ) / 4
        ) >= 7 THEN 'En valoración'
        ELSE 'Sin asignación'
      END AS estado
    FROM docentes d
    LEFT JOIN evaluaciones e ON e.id_docente = d.id_docente
    LEFT JOIN estudiantes s   ON s.id_estudiante = e.id_estudiante
    WHERE 1=1 ${whereDocSQL} ${whereEstSQL}
    GROUP BY d.id_docente, d.nombre, d.materia, d.carrera_id, d.semestre
    ORDER BY d.nombre ASC
  `;

  db.query(sql, params, (err, results) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    res.json(results);
  });
};

// Métricas (sin cambios)
exports.obtenerMetricas = (req, res) => {
  const queries = {
    totales: `
      SELECT
        COUNT(DISTINCT e.id_estudiante) AS alumnos_que_evaluan,
        COUNT(*)                         AS total_evaluaciones
      FROM evaluaciones e
    `,
    campusQueEvaluan: `
      SELECT c.id_campus, c.nombre AS campus, COUNT(DISTINCT e.id_estudiante) AS alumnos
      FROM campus c
      JOIN estudiantes s ON s.campus_id = c.id_campus
      JOIN evaluaciones e ON e.id_estudiante = s.id_estudiante
      GROUP BY c.id_campus, c.nombre
      ORDER BY c.nombre
    `,
    alumnosPorCarrera: `
      SELECT ca.id_carrera, ca.nombre AS carrera, COUNT(DISTINCT e.id_estudiante) AS alumnos
      FROM carreras ca
      JOIN estudiantes s ON s.carrera_id = ca.id_carrera
      JOIN evaluaciones e ON e.id_estudiante = s.id_estudiante
      GROUP BY ca.id_carrera, ca.nombre
      ORDER BY ca.nombre
    `,
    faltantes: `
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
      ORDER BY c.nombre, ca.nombre, s.semestre
    `
  };

  const result = {};
  db.query(queries.totales, [], (err, r1) => {
    if (err) return res.status(500).json({ success: false, message: "Error métricas" });
    result.totales = r1[0] || {};
    db.query(queries.campusQueEvaluan, [], (err, r2) => {
      if (err) return res.status(500).json({ success: false, message: "Error métricas" });
      result.campus = r2;
      db.query(queries.alumnosPorCarrera, [], (err, r3) => {
        if (err) return res.status(500).json({ success: false, message: "Error métricas" });
        result.carreras = r3;
        db.query(queries.faltantes, [], (err, r4) => {
          if (err) return res.status(500).json({ success: false, message: "Error métricas" });
          result.faltantes = r4;
          res.json(result);
        });
      });
    });
  });
};
