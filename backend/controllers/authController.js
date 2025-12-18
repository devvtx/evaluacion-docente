const db = require("../models/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "super_secreto_cambia_esto";

// Registro:
// - Todos (incluye intercambio): campus, carrera y semestre obligatorios.
// - Intercambio: además universidad_origen y programa_origen obligatorios.
exports.register = (req, res) => {
  const {
    nombre,
    email,
    password,
    campus_id,
    carrera_id,
    semestre,
    es_intercambio,
    universidad_origen,
    programa_origen
  } = req.body;

  const intercambio = Number(es_intercambio) === 1;

  if (!nombre || !email || !password || !campus_id || !carrera_id || !semestre) {
    return res.status(400).json({
      success: false,
      message: "Nombre, correo, contraseña, campus, carrera y semestre son obligatorios"
    });
  }

  if (intercambio && (!universidad_origen || !programa_origen)) {
    return res.status(400).json({
      success: false,
      message: "Universidad y programa de origen son obligatorios para intercambio"
    });
  }

  const q1 = "SELECT id_estudiante FROM estudiantes WHERE email = ?";
  db.query(q1, [email], (err, rows) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    if (rows.length > 0) {
      return res.status(409).json({ success: false, message: "El correo ya está registrado" });
    }

    const password_hash = bcrypt.hashSync(password, 10);

    const q2 = `
      INSERT INTO estudiantes (
        nombre, email, password_hash,
        campus_id, carrera_id, semestre,
        es_intercambio, universidad_origen, programa_origen
      )
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;

    db.query(
      q2,
      [
        nombre,
        email,
        password_hash,
        Number(campus_id),
        Number(carrera_id),
        Number(semestre),
        intercambio ? 1 : 0,
        intercambio ? universidad_origen : null,
        intercambio ? programa_origen : null
      ],
      (err2, result) => {
        if (err2) return res.status(500).json({ success: false, message: "Error al registrar" });

        const id_estudiante = result.insertId;
        const payload = {
          id_estudiante,
          nombre,
          email,
          campus_id: Number(campus_id),
          carrera_id: Number(carrera_id),
          semestre: Number(semestre),
          es_intercambio: intercambio ? 1 : 0
        };

        const token = jwt.sign(payload, JWT_SECRET, { expiresIn: "7d" });
        res.json({ success: true, token, user: payload });
      }
    );
  });
};

// Login
exports.login = (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Email y contraseña requeridos" });
  }

  const q = "SELECT * FROM estudiantes WHERE email = ?";
  db.query(q, [email], (err, rows) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    if (rows.length === 0) return res.status(401).json({ success: false, message: "Credenciales inválidas" });

    const user = rows[0];
    const ok = bcrypt.compareSync(password, user.password_hash);
    if (!ok) return res.status(401).json({ success: false, message: "Credenciales inválidas" });

    const payload = {
      id_estudiante: user.id_estudiante,
      nombre: user.nombre,
      email: user.email,
      campus_id: Number(user.campus_id),
      carrera_id: Number(user.carrera_id),
      semestre: Number(user.semestre),
      es_intercambio: user.es_intercambio ? 1 : 0
    };

    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: "7d" });
    res.json({ success: true, token, user: payload });
  });
};
