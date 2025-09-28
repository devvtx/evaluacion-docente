const express = require("express");
const router = express.Router();
const controller = require("../controllers/evaluacionesController");
const auth = require("../middleware/auth");

// Rutas
router.post("/guardar", auth, controller.guardarEvaluacion);
router.get("/resultados", controller.obtenerResultados);
router.get("/docentes", controller.obtenerDocentes);

module.exports = router;
