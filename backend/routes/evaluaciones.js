const express = require("express");
const router = express.Router();
const controller = require("../controllers/evaluacionesController");
const auth = require("../middleware/auth");

router.post("/guardar", auth, controller.guardarEvaluacion);
router.get("/docentes", auth, controller.obtenerDocentes);

router.get("/resultados", controller.obtenerResultados);
router.get("/metricas", controller.obtenerMetricas);

module.exports = router;
