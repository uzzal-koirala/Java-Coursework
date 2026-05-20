# Gunaso Management System

A web-based complaint (Gunaso) management portal built using **Java EE, JSP, Servlet, JDBC, MySQL, and MVC Architecture**.

## Technology Stack

| Layer       | Technology              |
|-------------|-------------------------|
| Frontend    | JSP, Custom CSS, JS     |
| Backend     | Java EE Servlet         |
| Database    | MySQL (via JDBC)        |
| Server      | Apache Tomcat 9+        |
| Architecture| MVC Pattern             |

> ⚠️ **DO NOT** use `server.py`, Flask, Django, Node.js, PHP, or any other non-Java backend to serve this project.  
> This project **must** run on **Apache Tomcat**.

---

## Project Structure

```
GunasoManagementSystem/
├── src/
│   ├── controller/       # Servlet controllers
│   ├── model/            # Java model/entity classes
│   ├── dao/              # Database Access Objects
│   ├── service/          # Business logic layer
│   ├── filter/           # Servlet filters (auth, roles)
│   ├── listener/         # Application listeners
│   └── util/             # Utility classes (DBConnection, etc.)
├── WebContent/
│   ├── WEB-INF/
│   │   └── web.xml       # Servlet mappings
│   ├── css/              # Custom stylesheets
│   ├── js/               # JavaScript files
│   ├── images/           # Static images
│   ├── admin/            # Admin-only JSP pages
│   ├── superadmin/       # Super Admin JSP pages
│   ├── user/             # Citizen/User JSP pages
│   ├── auth/             # Login, register pages
│   ├── error/            # Error pages (403, 404, 500)
│   ├── index.jsp         # Home page
│   ├── about.jsp         # About page
│   └── contact.jsp       # Contact page
└── database/
    └── gunaso.sql        # MySQL schema and seed data
```

---

## How to Run (Apache Tomcat)

### Prerequisites
- JDK 11 or higher
- Apache Tomcat 9.x or 10.x
- MySQL 8.x
- Eclipse IDE for Enterprise Java (or IntelliJ IDEA Ultimate)
- MySQL Connector/J JAR (`mysql-connector-j-*.jar`)

### Steps

1. **Import the project** into Eclipse as a *Dynamic Web Project*.

2. **Set up the database:**
   ```sql
   -- In MySQL Workbench or CLI:
   SOURCE /path/to/database/gunaso.sql;
   ```

3. **Configure DB credentials** in `src/util/DBConnection.java`:
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/gunaso_db";
   private static final String USER = "root";
   private static final String PASSWORD = "your_password";
   ```

4. **Add MySQL Connector JAR** to `WebContent/WEB-INF/lib/`.

5. **Add Tomcat Server** in Eclipse:
   - Window → Preferences → Server → Runtime Environments → Add Apache Tomcat

6. **Run on Server:**
   - Right-click project → Run As → Run on Server → Select Tomcat

7. **Access the app** at:
   ```
   http://localhost:8080/GunasoManagementSystem/
   ```

---

## User Roles

| Role          | Dashboard            |
|---------------|----------------------|
| Citizen/User  | user-dashboard.jsp   |
| Wada Adakshya | admin-dashboard.jsp  |
| Nagar Pramukh | admin-dashboard.jsp  |
| Prime Minister | admin-dashboard.jsp |
| Super Admin   | super-dashboard.jsp  |

---

## Features

- ✅ Role-based authentication & authorization
- ✅ Complaint CRUD (Create, Read, Update, Delete)
- ✅ Complaint status tracking
- ✅ Reply/response system
- ✅ Priority & category management
- ✅ Search and filter complaints
- ✅ Responsive glassmorphism UI
- ✅ Session management
- ✅ MVC Architecture
- ✅ Database normalization

---

## ⚠️ Important Rules

- All pages **must be `.jsp`** — no `.html` files for frontend pages.
- Server must be **Apache Tomcat only**.
- No Bootstrap — use **custom CSS only**.
- No Python, Node.js, PHP, or any non-Java backend.
