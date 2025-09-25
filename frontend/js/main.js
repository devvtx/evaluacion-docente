// =========================
// 📌 Enviar evaluación con menú interactivo
// =========================
const form = document.getElementById("form-evaluacion");
if (form) {
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const data = Object.fromEntries(new FormData(form));

    try {
      const res = await fetch("http://localhost:3000/api/evaluaciones/guardar", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data)
      });

      const result = await res.json();
      if (res.ok) {
        // Menú interactivo después de guardar
        const opcion = confirm(`${result.message}\n\n¿Deseas ver los resultados?\n\nAceptar = Ver resultados\nCancelar = Elegir otra acción`);

        if (opcion) {
          // Ir a resultados
          window.location.href = "resultados.html";
        } else {
          const siguiente = confirm("¿Quieres hacer una nueva evaluación?\n\nAceptar = Nueva evaluación\nCancelar = Menú principal");
          if (siguiente) {
            form.reset(); // limpia el formulario para otra evaluación
          } else {
            window.location.href = "index.html"; // volver al inicio
          }
        }
      } else {
        alert("❌ Error: " + result.message);
      }
    } catch (error) {
      console.error("Error al enviar evaluación:", error);
      alert("❌ No se pudo enviar la evaluación. Revisa el servidor.");
    }
  });
}

// =========================
// 📌 Cargar docentes dinámicamente en evaluar.html
// =========================
const selectDocente = document.getElementById("docente");
if (selectDocente) {
  fetch("http://localhost:3000/api/evaluaciones/docentes")
    .then(res => res.json())
    .then(data => {
      selectDocente.innerHTML = ""; // Limpia opciones previas
      if (data.length === 0) {
        const option = document.createElement("option");
        option.textContent = "No hay docentes registrados";
        option.disabled = true;
        option.selected = true;
        selectDocente.appendChild(option);
      } else {
        data.forEach(d => {
          const option = document.createElement("option");
          option.value = d.id_docente;
          option.textContent = `${d.nombre} - ${d.materia}`;
          selectDocente.appendChild(option);
        });
      }
    })
    .catch(err => console.error("❌ Error cargando docentes:", err));
}

// =========================
// 📌 Mostrar resultados (resultados.html)
// =========================
const tabla = document.getElementById("tabla-resultados");
const ctx = document.getElementById("graficaResultados");

if (tabla) {
  fetch("http://localhost:3000/api/evaluaciones/resultados")
    .then(res => res.json())
    .then(data => {
      tabla.innerHTML = ""; // Limpia antes

      let promedios = { claridad: 0, puntualidad: 0, dominio: 0, trato: 0 };
      let totalDocentes = 0;

      data.forEach(row => {
        const tr = document.createElement("tr");
        tr.innerHTML = `
          <td>${row.nombre}</td>
          <td>${row.materia}</td>
          <td>${row.total_evaluaciones}</td>
          <td>${row.promedio_claridad ? parseFloat(row.promedio_claridad).toFixed(2) : "-"}</td>
          <td>${row.promedio_puntualidad ? parseFloat(row.promedio_puntualidad).toFixed(2) : "-"}</td>
          <td>${row.promedio_dominio ? parseFloat(row.promedio_dominio).toFixed(2) : "-"}</td>
          <td>${row.promedio_trato ? parseFloat(row.promedio_trato).toFixed(2) : "-"}</td>
        `;
        tabla.appendChild(tr);

        // Solo sumamos promedios de los que sí tienen evaluaciones
        if (row.total_evaluaciones > 0) {
          promedios.claridad += parseFloat(row.promedio_claridad);
          promedios.puntualidad += parseFloat(row.promedio_puntualidad);
          promedios.dominio += parseFloat(row.promedio_dominio);
          promedios.trato += parseFloat(row.promedio_trato);
          totalDocentes++;
        }
      });

      if (totalDocentes > 0 && ctx) {
        promedios = {
          claridad: promedios.claridad / totalDocentes,
          puntualidad: promedios.puntualidad / totalDocentes,
          dominio: promedios.dominio / totalDocentes,
          trato: promedios.trato / totalDocentes
        };

        new Chart(ctx, {
          type: "bar",
          data: {
            labels: ["Claridad", "Puntualidad", "Dominio", "Trato"],
            datasets: [{
              label: "Promedio Global",
              data: [
                promedios.claridad.toFixed(2),
                promedios.puntualidad.toFixed(2),
                promedios.dominio.toFixed(2),
                promedios.trato.toFixed(2)
              ],
              backgroundColor: ["#0d6efd", "#198754", "#ffc107", "#dc3545"]
            }]
          },
          options: { 
            responsive: true, 
            plugins: { legend: { display: false } } 
          }
        });
      }
    })
    .catch(err => console.error("❌ Error mostrando resultados:", err));
}
