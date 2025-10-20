const express = require("express");
const router = express.Router();
const controller = require("../controllers/evaluacionesController");
const auth = require("../middleware/auth");

// Rutas de evaluación
router.post("/guardar", auth, controller.guardarEvaluacion);

// Docentes disponibles para el alumno autenticado
router.get("/docentes", auth, controller.obtenerDocentes);

// Resultados públicos con filtros
router.get("/resultados", controller.obtenerResultados);

// Métricas
router.get("/metricas", controller.obtenerMetricas);

module.exports = router;
