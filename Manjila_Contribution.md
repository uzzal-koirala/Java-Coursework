# 6.1.1 Team Member Manjila Shrestha

**a) Advanced Backend DAO & Service Implementation**
In this project, my primary focus was designing and implementing the core data access objects (DAO) and business services that power the system's administration and real-time notification features. I created `DashboardDAO.java` and `SuperAdminDAO.java` to act as the direct communication layer between the Java application and the MySQL database. My goal was to compute complex Key Performance Indicators (KPIs) such as the 'Monthly Resolution Rate' and 'Average Response Time' for government officials. To achieve this, I wrote highly optimized SQL queries using `PreparedStatement` to protect against SQL injection vulnerabilities and to speed up execution time.

Figure 66 DashboardDAO.java

To ensure the system remains scalable, I separated the raw data extraction from the business logic by introducing a `DashboardService.java` layer. This service layer receives the raw data from the DAO, calculates percentage distributions, formats the data structures, and prepares it cleanly for the frontend View. I also implemented `NotificationService.java` which dynamically triggers alerts (e.g., when a grievance status changes or a new assignment occurs) without bogging down the main execution thread.

Figure 67 DashboardService.java

Citation:
(Oracle Java, 2026) https://docs.oracle.com/javase/tutorial/jdbc/basics/prepared.html

**b) UI/UX Design for Notification System**
To enhance the user experience on the frontend, I was responsible for designing and implementing the dynamic notification bell and dropdown menu located within `navbar.jsp`. Instead of relying on static page reloads, I used CSS and JavaScript to create an interactive dropdown that displays real-time system alerts and grievance updates to the user. I created a custom red badge indicator that accurately reflects the count of unread notifications fetched securely from the backend `NotificationDAO`.

Figure 68 navbar.jsp Notification Dropdown Implementation

The design ensures that when a citizen or government official receives an update, it is visible immediately across all dashboard views without breaking the layout. I utilized CSS positioning (`position: absolute;`) and z-index layering to ensure the dropdown elegantly overlays the existing dashboard elements. 

Figure 69 CSS Dropdown Styling

Citation:
(W3Schools, 2026) https://www.w3schools.com/css/css_dropdowns.asp

**c) Database Architecture & Schema Design**
Data integrity is the backbone of the "Mero Sarkar" system. I contributed heavily to extending the system's backend database architecture by introducing the `notifications` table schema. To ensure we didn't disrupt the existing, functioning database, I wrote a modular SQL script (`notification_schema.sql`) specifically tailored for this feature.

Figure 70 notification_schema.sql

My design strictly adhered to relational database best practices. I applied Foreign Key constraints linking the `user_id` in the notifications table to the core `users` table. Crucially, I implemented the `ON DELETE CASCADE` rule. This guarantees that if a user account is deleted from the system, all of their associated notifications are automatically purged by the database engine itself, preventing database bloating and orphaned records.

Citation:
(MySQL, 2023) https://dev.mysql.com/doc/refman/8.0/en/create-table-foreign-keys.html

**d) Critical Analysis**

**Challenges**
*   **Challenge 1: Implementing Complex Dashboard Analytics**
    *   **Problem:** Calculating system-wide KPIs, such as average response times and monthly grievance resolution rates, required complex SQL operations. I needed to join multiple large tables (`gunaso`, `replies`) and compute time differences. Doing this inefficiently inside the Java memory could cause severe lag and slow down the entire admin dashboard.
    
    Figure 71 Complex SQL Query in DashboardDAO
    
    *   **How I overcame it:** I tackled this by shifting the computational heavy lifting directly to the MySQL database engine. I rewrote the SQL queries in `DashboardDAO` to utilize optimized aggregate functions like `COUNT()` and `AVG(TIMESTAMPDIFF(HOUR, g.created_at, r.created_at))`. By abstracting this logic, the database only returns a single, lightweight numerical value to the Java application. I then used the `DashboardService` layer to format this data. This significantly reduced memory consumption and dramatically improved the dashboard's load time.

    Citation:
    (MySQL, 2023) https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

**Problem Faced**
*   **Problem 1: Model-Schema Mismatch & Compilation Errors**
    *   **Description:** During the final integration testing of the Notification feature, the system suddenly crashed during the build process, throwing severe Java compilation errors (`cannot find symbol: method setMessage(String)`). The frontend and backend were attempting to communicate, but the data structures were out of sync.
    
    Figure 72 Compilation Error Logs
    
    *   **How I did it:** I carefully analyzed the Java compilation stack trace and immediately pinpointed the root cause: a mismatch between the physical SQL table definition and the object-oriented Java POJO class. While my new `notifications` table had a `message` column, the `Notification.java` model class was missing this corresponding property. I resolved this by refactoring `Notification.java`, explicitly adding the `private String message;` field along with its public getter and setter methods. This restored strict object-relational alignment and permanently resolved the compilation issues.

    Figure 73 Notification.java Model Fix

    Citation:
    (Stack Overflow, 2018) https://stackoverflow.com/questions/cannot-find-symbol-java-error
