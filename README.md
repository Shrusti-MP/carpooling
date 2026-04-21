# Java Carpooling Application

A full-stack web application built with Java Servlets, JSP, and MySQL that allows users to offer, search, and book rides. This platform connects drivers with empty seats to passengers traveling in the same direction, promoting a cost-effective and eco-friendly travel solution.

## Features

- **User Authentication:** Secure registration and login functionality for all users.
- **Ride Management:** Drivers can easily offer rides by specifying source, destination, date, time, available seats, pricing, and vehicle details.
- **Search Functionality:** Passengers can search for available rides based on their travel requirements.
- **Booking System:** Seamless process for passengers to book seats on available rides, with real-time seat availability updates.
- **Session Management:** Secure user sessions using standard Java Servlet session handling.
- **Responsive UI:** Clean and intuitive user interface built with Bootstrap 5.

## Tech Stack

- **Backend:** Java 11, Java Servlets, JSP (JavaServer Pages)
- **Database:** MySQL 8.x
- **Frontend:** HTML5, CSS3, Bootstrap 5, Vanilla JavaScript
- **Build Tool:** Maven
- **Server:** Apache Tomcat 9+
- **Architecture:** MVC (Model-View-Controller) Pattern

## Prerequisites

Before you begin, ensure you have met the following requirements:

- **Java Development Kit (JDK):** Version 11 or higher
- **Maven:** Version 3.6+
- **Database:** MySQL Server 8.0+
- **IDE:** Eclipse IDE for Enterprise Java Web Developers (or IntelliJ IDEA Ultimate)
- **Web Server:** Apache Tomcat 9.0 or higher

## Database Setup

1. Open your MySQL client (e.g., MySQL Workbench, Command Line).
2. Execute the `database.sql` script located in the root directory to create the `carpool_db` database and necessary tables.
   ```sql
   source /path/to/carpooling/database.sql;
   ```
   *Note: This script will create the `users`, `rides`, and `bookings` tables.*

3. Update the database connection credentials in your Java application (typically in a utility class like `DBConnection.java` or `db.properties`):
   ```java
   // Example configuration
   String url = "jdbc:mysql://localhost:3306/carpool_db";
   String user = "your_mysql_username";
   String password = "your_mysql_password";
   ```

## Installation and Setup

### Using Eclipse

1. **Clone/Import the project:**
   - Open Eclipse and go to `File > Import > Maven > Existing Maven Projects`.
   - Browse to the `carpooling` directory and select it. Click Finish.

2. **Configure Tomcat Server:**
   - Go to the `Servers` tab (Window > Show View > Servers).
   - Right-click > `New > Server`. Select `Apache Tomcat v9.0` (or your version).
   - Locate your Tomcat installation directory and click Finish.

3. **Deploy the Application:**
   - Right-click on the Tomcat server instance.
   - Click `Add and Remove...`.
   - Move `carpooling` (or `CarpoolingApp`) from the "Available" to the "Configured" column. Click Finish.

4. **Run the Application:**
   - Right-click the server and select `Start` (or `Debug`).
   - Open your browser and navigate to `http://localhost:8080/CarpoolingApp`.

### Using Maven Command Line

1. Open a terminal in the project root directory.
2. Build the WAR file:
   ```bash
   mvn clean install
   ```
3. Deploy the generated WAR file:
   Copy `target/CarpoolingApp.war` to your Tomcat's `webapps` directory and start Tomcat.

## Project Structure

```text
carpooling/
├── pom.xml                 # Maven dependencies and build configuration
├── database.sql            # Database schema and initial setup script
└── src/
    └── main/
        ├── java/           # Java source code (Servlets, Models, DAO, Utils)
        │   └── com/carpool/
        │       ├── controller/  # Servlets handling HTTP requests
        │       ├── model/       # Java classes representing database entities
        │       ├── dao/         # Data Access Objects for database operations
        │       └── util/        # Utility classes (e.g., DBConnection)
        └── webapp/         # Web resources
            ├── WEB-INF/
            │   └── web.xml # Application configuration (if not using annotations)
            ├── css/        # Custom stylesheets
            ├── js/         # Client-side JavaScript
            ├── jsp/        # View templates (.jsp files)
            └── index.jsp   # Application entry point
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License.
