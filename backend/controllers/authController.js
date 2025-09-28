const db = require("../models/db");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET || "super_secreto_cambia_esto";

exports.register = (req, res) => {
  const { nombre, email, password } = req.body;
  if (!nombre || !email || !password) {
    return res.status(400).json({ success: false, message: "Todos los campos son obligatorios" });
  }

  const q1 = "SELECT id_estudiante FROM estudiantes WHERE email = ?";
  db.query(q1, [email], (err, rows) => {
    if (err) return res.status(500).json({ success: false, message: "Error en el servidor" });
    if (rows.length > 0) {
      return res.status(409).json({ success: false, message: "El correo ya está registrado" });
    }

    const password_hash = bcrypt.hashSync(password, 10);
    const q2 = "INSERT INTO estudiantes (nombre, email, password_hash) VALUES (?, ?, ?)";
    db.query(q2, [nombre, email, password_hash], (err, result) => {
      if (err) return res.status(500).json({ success: false, message: "Error al registrar" });

      const id_estudiante = result.insertId;
      const token = jwt.sign({ id_estudiante, nombre, email }, JWT_SECRET, { expiresIn: "7d" });
      res.json({ success: true, token, user: { id_estudiante, nombre, email } });
    });
  });
};

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

    const token = jwt.sign({ id_estudiante: user.id_estudiante, nombre: user.nombre, email: user.email }, JWT_SECRET, { expiresIn: "7d" });
    res.json({ success: true, token, user: { id_estudiante: user.id_estudiante, nombre: user.nombre, email: user.email } });
  });
};
