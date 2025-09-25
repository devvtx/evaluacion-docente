# Teacher Evaluation System

This is a simple **Teacher Evaluation Web Application** built with **Node.js, Express, MySQL, HTML, CSS, and JavaScript**.  
The system allows students to evaluate their teachers anonymously and view the results in a user-friendly dashboard.

---

## Features
- Evaluate teachers with multiple criteria:
  - Clarity
  - Punctuality
  - Subject Mastery
  - Student Treatment
- Write optional comments in evaluations.
- Results are stored in a **MySQL database**.
- View average scores and statistics per teacher.
- Interactive bar chart for overall averages (using Chart.js).
- Clean and responsive UI built with **Bootstrap**.

---

## Tech Stack
- **Frontend:** HTML, CSS (Bootstrap), JavaScript (Chart.js)
- **Backend:** Node.js, Express
- **Database:** MySQL
- **Version Control:** Git + GitHub

---

## Project Structure

teacher-evaluation/
│── backend/ # Node.js + Express server
│ ├── models/ # DB connection
│ ├── routes/ # API routes
│ └── server.js # App entry point
│
│── database/ # SQL schema & scripts
│
│── frontend/ # Static frontend
│ ├── css/ # Stylesheets
│ ├── img/ # Images
│ ├── js/ # Frontend logic
│ ├── index.html # Home page
│ ├── evaluar.html # Evaluation form
│ └── resultados.html# Results dashboard
│
└── README.md

## Installation & Setup

1. Clone the repository
```bash
git clone https://github.com/devvtx/teacher-evaluation.git
cd teacher-evaluation

2. Install backend dependencies
cd backend
npm install

3. Configure the database

Import the SQL schema from the database/ folder into your MySQL server.

Update backend/models/db.js with your MySQL credentials:

const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "evaluacion_docentes"
});

4. Run the backend server
node server.js

Server will run on:
👉 http://localhost:3000

5. Open the frontend

Simply open frontend/index.html in your browser.

Or serve it with a live server (e.g., VS Code extension).
