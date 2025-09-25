const express = require("express");
const router = express.Router();
const controller = require("../controllers/evaluacionesController");

// Rutas
router.post("/guardar", controller.guardarEvaluacion);
router.get("/resultados", controller.obtenerResultados);
router.get("/docentes", controller.obtenerDocentes); // 👈 asegúrate que exista en el controller

module.exports = router;
