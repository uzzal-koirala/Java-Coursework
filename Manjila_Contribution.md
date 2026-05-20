# 6.1.1 Team Member Manjila Shrestha

**a. Advanced Backend DAO & Service Implementation**
I designed and implemented the core data access objects and business services for the system's administration and notification features. I created `SuperAdminDAO.java` to handle role management and system-wide metrics, and `DashboardDAO.java` combined with `DashboardService.java` to compute complex KPIs such as 'Monthly Resolution Rate' and 'Average Response Time'. I utilized proper encapsulation, robust SQL queries (using `PreparedStatement`), and strict exception handling to ensure data integrity, prevent SQL injection, and keep the application secure.

**b. UI/UX Design for Notification System**
I implemented a dynamic notification bell and dropdown menu in the `navbar.jsp` to display real-time system alerts and grievance updates to the user. Using custom CSS styling, I created an intuitive red badge indicator for unread notification counts and a clean, accessible dropdown list to show recent updates. I integrated this view directly with the backend `NotificationDAO` to fetch the user's unread data securely and dynamically display it without breaking the layout of existing pages.

**c. Database Architecture & Schema Design**
I contributed to extending the system's backend database architecture safely without disrupting the existing core tables. I introduced the new `notifications` table schema (`notification_schema.sql`) specifically tailored for relational integrity. I applied foreign key constraints linking to the `users` table with `ON DELETE CASCADE`, guaranteeing that if a user is removed from the system, all their associated notifications are automatically cleared to prevent database bloating and orphaned records.

**d. Critical Analysis**

*   **Challenges**
    *   **Challenge 1: Implementing Complex Dashboard Analytics**
        *   **Problem:** Calculating system-wide KPIs, such as average response times and monthly grievance resolution rates, required complex SQL operations and joining multiple large tables (`gunaso`, `replies`). Doing this inefficiently could slow down the entire admin dashboard.
        *   **How I overcame it:** I tackled this by abstracting the complex SQL operations within `DashboardDAO` using optimized aggregate functions like `COUNT()` and `AVG(TIMESTAMPDIFF())`. To keep the code clean, I built a `DashboardService` layer to separate the business logic from the database queries. The service layer handles computing the final percentages and formatting the data structure, ensuring the frontend JSP only receives clean, ready-to-render data.

*   **Problem Faced**
    *   **Problem 1: Model-Schema Mismatch & Compilation Errors**
        *   **Problem:** During the integration of the Notification feature, the system began throwing Java compilation errors (`cannot find symbol`) because the `Notification.java` POJO class lacked the `message` field that was present in the newly designed `notifications` database schema. The frontend and backend were communicating, but the data structure was out of sync.
        *   **How I overcame it:** I analyzed the Java compilation logs and immediately pinpointed the mismatch between the physical SQL table definition and the object-oriented Java POJO class. I refactored `Notification.java` by adding the private `message` string field along with its public getter and setter methods. This restored strict alignment with the database architecture and permanently resolved the compilation and data-binding issues.
