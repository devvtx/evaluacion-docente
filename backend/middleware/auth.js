const jwt = require("jsonwebtoken");
const JWT_SECRET = process.env.JWT_SECRET || "super_secreto_cambia_esto";

module.exports = (req, res, next) => {
  const auth = req.headers.authorization || "";
  const parts = auth.split(" ");
  if (parts.length !== 2 || parts[0] !== "Bearer") {
    return res.status(401).json({ success: false, message: "No autorizado" });
  }
  try {
    const payload = jwt.verify(parts[1], JWT_SECRET);
    req.user = payload; // { id_estudiante, nombre, email }
    next();
  } catch {
    return res.status(401).json({ success: false, message: "Token inválido o expirado" });
  }
};
