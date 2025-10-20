const API = "http://localhost:3000/api";

const getToken = () => localStorage.getItem("token");
const setToken = (t) => localStorage.setItem("token", t);
const clearToken = () => localStorage.removeItem("token");

function authHeaders() {
  const t = getToken();
  return t ? { "Authorization": `Bearer ${t}` } : {};
}
function ensureAuthOnPage() {
  if (!getToken()) window.location.href = "index.html";
}
function showLogoutIfNeeded() {
  const btn = document.getElementById("btnLogout");
  if (!btn) return;
  if (getToken()) {
    btn.classList.remove("d-none");
    btn.onclick = () => { clearToken(); window.location.href = "index.html"; };
  } else btn.classList.add("d-none");
}

// Decodificar payload del JWT para usar carrera_id y semestre en UI
function getUserFromToken() {
  const t = getToken();
  if (!t) return null;
  const parts = t.split(".");
  if (parts.length !== 3) return null;
  try {
    const json = atob(parts[1].replace(/-/g, "+").replace(/_/g, "/"));
    return JSON.parse(json);
  } catch { return null; }
}

// Helpers de catálogo
async function loadCampus(selectId) {
  const sel = document.getElementById(selectId);
  const rows = await fetch(`${API}/catalogos/campus`).then(r=>r.json());
  sel.innerHTML = rows.map(r=>`<option value="${r.id_campus}">${r.nombre}</option>`).join("");
}
async function loadCarreras(selectId) {
  const sel = document.getElementById(selectId);
  const rows = await fetch(`${API}/catalogos/carreras`).then(r=>r.json());
  sel.innerHTML = rows.map(r=>`<option value="${r.id_carrera}">${r.nombre}</option>`).join("");
}
async function loadDocentesAutorizados(selectId) {
  const sel = document.getElementById(selectId);
  const rows = await fetch(`${API}/evaluaciones/docentes`, { headers: { ...authHeaders() } }).then(r=>r.json());
  sel.innerHTML = rows.map(d=>`<option value="${d.id_docente}">${d.nombre} — ${d.materia}</option>`).join("");
}

// ============ INDEX (login/registro)
(function initIndex(){
  const onIndex = location.pathname.endsWith("index.html") || location.pathname.endsWith("/") || location.pathname.endsWith("\\");
  if (!onIndex) return;

  showLogoutIfNeeded();
  const needsAuth = !getToken();
  const modalEl = document.getElementById("authModal");
  let modal;
  if (modalEl) modal = new bootstrap.Modal(modalEl, { backdrop: "static", keyboard: false });
  if (needsAuth && modal) modal.show();

  const authMsg = document.getElementById("authMsg");

  loadCampus("reg-campus");
  loadCarreras("reg-carrera");

  // Login
  const formLogin = document.getElementById("form-login");
  if (formLogin) {
    formLogin.addEventListener("submit", async (e) => {
      e.preventDefault();
      authMsg.textContent = "";
      const data = Object.fromEntries(new FormData(formLogin));
      try {
        const res = await fetch(`${API}/auth/login`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(data)
        });
        const json = await res.json();
        if (!json.success) throw new Error(json.message || "Error al iniciar sesión");
        setToken(json.token);
        authMsg.textContent = "Sesión iniciada";
        setTimeout(() => modal.hide(), 600);
        showLogoutIfNeeded();
      } catch (err) {
        authMsg.textContent = err.message;
      }
    });
  }

  // Registro
  const formRegister = document.getElementById("form-register");
  if (formRegister) {
    formRegister.addEventListener("submit", async (e) => {
      e.preventDefault();
      authMsg.textContent = "";
      const data = Object.fromEntries(new FormData(formRegister));
      try {
        const res = await fetch(`${API}/auth/register`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(data)
        });
        const json = await res.json();
        if (!json.success) throw new Error(json.message || "Error al registrar");
        setToken(json.token);
        authMsg.textContent = "Cuenta creada";
        setTimeout(() => modal.hide(), 600);
        showLogoutIfNeeded();
      } catch (err) {
        authMsg.textContent = err.message || "Error";
      }
    });
  }
})();

// ============ EVALUAR (bloqueo a carrera/semestre del alumno)
(function initEvaluar(){
  const onPage = location.pathname.endsWith("evaluar.html");
  if (!onPage) return;

  ensureAuthOnPage();
  showLogoutIfNeeded();

  const u = getUserFromToken(); // { carrera_id, semestre, campus_id, ... }
  // Controles
  const selCarrera = document.getElementById("flt-carrera");
  const selSem = document.getElementById("flt-semestre");
  const docenteSel = document.getElementById("select-docente");

  // Fijar filtros a lo del alumno y bloquearlos
  loadCarreras("flt-carrera").then(() => {
    if (u?.carrera_id) selCarrera.value = String(u.carrera_id);
    selCarrera.setAttribute("disabled", "disabled");
  });
  if (u?.semestre) selSem.value = String(u.semestre);
  selSem.setAttribute("disabled", "disabled");

  // Cargar solo docentes autorizados por backend
  loadDocentesAutorizados("select-docente");

  // Enviar evaluación
  const form = document.getElementById("form-evaluacion");
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(form));
    try {
      const res = await fetch(`${API}/evaluaciones/guardar`, {
        method: "POST",
        headers: { "Content-Type": "application/json", ...authHeaders() },
        body: JSON.stringify(data)
      });
      const json = await res.json();
      if (!json.success) throw new Error(json.message || "Error al guardar");
      alert("Evaluación guardada");
      form.reset();
      // Volver a cargar docentes por si cambió algo
      await loadDocentesAutorizados("select-docente");
    } catch (err) {
      alert(err.message);
    }
  });
})();

// ============ RESULTADOS (igual que antes)
(function initResultados(){
  const onPage = location.pathname.endsWith("resultados.html");
  if (!onPage) return;

  showLogoutIfNeeded();

  loadCampus("res-campus");
  loadCarreras("res-carrera");

  const tbody = document.getElementById("tabla-resultados");
  const metCampus = document.getElementById("met-campus");
  const metTotales = document.getElementById("met-totales");
  const metCarreras = document.getElementById("met-carreras");
  const metFaltantes = document.getElementById("met-faltantes");

  async function cargarResultados(){
    const qs = new URLSearchParams();
    const campus_id = document.getElementById("res-campus").value;
    const carrera_id = document.getElementById("res-carrera").value;
    const semestre = document.getElementById("res-semestre").value;

    if (campus_id) qs.set("campus_id", campus_id);
    if (carrera_id) qs.set("carrera_id", carrera_id);
    if (semestre)   qs.set("semestre", semestre);

    const data = await fetch(`${API}/evaluaciones/resultados?${qs.toString()}`).then(r=>r.json());
    tbody.innerHTML = data.map(d=>{
      const estadoClass =
        d.estado === "Candidato a asignación" ? "estado-activo" :
        d.estado === "En valoración" ? "" :
        d.estado === "Sin asignación" ? "estado-inactivo" : "";
      const trClass = d.estado === "Sin asignación" ? "inactivo" : "";
      return `
        <tr class="${trClass}">
          <td>${d.nombre}</td>
          <td>${d.materia}</td>
          <td>${d.carrera_id}</td>
          <td>${d.semestre}</td>
          <td>${Number(d.promedio_claridad).toFixed(2)}</td>
          <td>${Number(d.promedio_puntualidad).toFixed(2)}</td>
          <td>${Number(d.promedio_dominio).toFixed(2)}</td>
          <td>${Number(d.promedio_trato).toFixed(2)}</td>
          <td><strong>${Number(d.calificacion_total).toFixed(2)}</strong></td>
          <td class="${estadoClass}">${d.estado}</td>
        </tr>
      `;
    }).join("");
  }

  async function cargarMetricas(){
    const json = await fetch(`${API}/evaluaciones/metricas`).then(r=>r.json());
    metTotales.textContent = `Alumnos que evalúan: ${json.totales.alumnos_que_evaluan ?? 0} | Total de evaluaciones: ${json.totales.total_evaluaciones ?? 0}`;
    metCampus.innerHTML = json.campus.map(r=>`<li>${r.campus}: ${r.alumnos}</li>`).join("");
    metCarreras.innerHTML = json.carreras.map(r=>`<li>${r.carrera}: ${r.alumnos}</li>`).join("");
    metFaltantes.innerHTML = json.faltantes.map(r=>`<li>${r.campus} — ${r.carrera} — Sem ${r.semestre}: ${r.alumnos_sin_evaluar}</li>`).join("");
  }

  document.getElementById("btn-filtrar").addEventListener("click", cargarResultados);

  cargarResultados();
  cargarMetricas();
})();
