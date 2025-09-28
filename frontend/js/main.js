// =========================
// Config
// =========================
const API = "http://localhost:3000/api";

// =========================
// Helpers de Auth (token en localStorage)
// =========================
const getToken = () => localStorage.getItem("token");
const setToken = (t) => localStorage.setItem("token", t);
const clearToken = () => localStorage.removeItem("token");

function authHeaders() {
  const t = getToken();
  return t ? { "Authorization": `Bearer ${t}` } : {};
}

function ensureAuthOnPage() {
  // En páginas que requieren sesión (evaluar.html)
  if (!getToken()) {
    // Redirige a index para loguearse
    window.location.href = "index.html";
  }
}

function showLogoutIfNeeded() {
  const btn = document.getElementById("btnLogout");
  if (btn) {
    if (getToken()) {
      btn.classList.remove("d-none");
      btn.onclick = () => {
        clearToken();
        window.location.href = "index.html";
      };
    } else {
      btn.classList.add("d-none");
    }
  }
}

// =========================
// Lógica de INDEX: modal de login/registro
// =========================
(function initIndex() {
  const onIndex = location.pathname.endsWith("index.html") || location.pathname.endsWith("/") || location.pathname.endsWith("\\");
  if (!onIndex) return;

  showLogoutIfNeeded();

  // Muestra modal si no hay token
  const needsAuth = !getToken();
  const modalEl = document.getElementById("authModal");
  let modal;
  if (modalEl) modal = new bootstrap.Modal(modalEl, { backdrop: "static", keyboard: false });
  if (needsAuth && modal) modal.show();

  const authMsg = document.getElementById("authMsg");

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
        authMsg.textContent = "✅ Sesión iniciada";
        setTimeout(() => modal.hide(), 600);
        showLogoutIfNeeded();
      } catch (err) {
        authMsg.textContent = "❌ " + err.message;
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
        authMsg.textContent = "✅ Cuenta creada. Sesión iniciada";
        setTimeout(() => modal.hide(), 600);
        showLogoutIfNeeded();
      } catch (err) {
        authMsg.textContent = "❌ " + (err.message || "Error");
      }
    });
  }
})();

// =========================
/* Evaluar: carga docentes y envía evaluación (requiere login) */
// =========================
(function initEvaluar() {
  const onPage = location.pathname.endsWith("evaluar.html");
  if (!onPage) return;

  ensureAuthOnPage();
  showLogoutIfNeeded();

  const userInfo = document.getElementById("userInfo");
  if (userInfo) {
    userInfo.classList.remove("d-none");
    userInfo.textContent = "Estás autenticado. Ya puedes enviar tu evaluación.";
  }

  // Cargar docentes
  const select = document.getElementById("select-docente");
  fetch(`${API}/evaluaciones/docentes`)
    .then(r => r.json())
    .then(list => {
      select.innerHTML = list.map(d => `<option value="${d.id_docente}">${d.nombre} — ${d.materia}</option>`).join("");
    });

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
      alert("✅ Evaluación guardada");
      form.reset();
    } catch (err) {
      alert("❌ " + err.message);
    }
  });
})();

// =========================
// Resultados: pinta tabla y estado
// =========================
(function initResultados() {
  const onPage = location.pathname.endsWith("resultados.html");
  if (!onPage) return;

  showLogoutIfNeeded();

  const tbody = document.getElementById("tabla-resultados");
  fetch(`${API}/evaluaciones/resultados`)
    .then(r => r.json())
    .then(data => {
      tbody.innerHTML = data.map(d => {
        const inactivo = d.estado === "Inactivo";
        const estadoClass = inactivo ? "estado-inactivo" : (d.estado === "Activo" ? "estado-activo" : "");
        const trClass = inactivo ? "inactivo" : "";
        return `
          <tr class="${trClass}">
            <td>${d.nombre}</td>
            <td>${d.materia}</td>
            <td>${Number(d.promedio_claridad).toFixed(2)}</td>
            <td>${Number(d.promedio_puntualidad).toFixed(2)}</td>
            <td>${Number(d.promedio_dominio).toFixed(2)}</td>
            <td>${Number(d.promedio_trato).toFixed(2)}</td>
            <td><strong>${Number(d.calificacion_total).toFixed(2)}</strong></td>
            <td class="${estadoClass}">${d.estado}</td>
          </tr>
        `;
      }).join("");
    })
    .catch(() => {
      tbody.innerHTML = `<tr><td colspan="8" class="text-center text-muted">No se pudieron cargar los resultados</td></tr>`;
    });
})();
