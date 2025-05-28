package com.mycompany.covoitme.resources;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DatabaseConnection {

  private static final Logger logger = Logger.getLogger(DatabaseConnection.class.getName());

  public static Connection getConnection() throws ClassNotFoundException, SQLException {
    String dbHost = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
    String dbPort = System.getenv("DB_PORT") != null ? System.getenv("DB_PORT") : "5432";
    String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "covoitme";
    String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "covoitme";
    String dbPassword = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "password";

    String url = "jdbc:postgresql://" + dbHost + ":" + dbPort + "/" + dbName;

    logger.info("Attempting to connect to database: " + dbHost + ":" + dbPort + "/" + dbName);

    Class.forName("org.postgresql.Driver");
    Connection connection = DriverManager.getConnection(url, dbUser, dbPassword);

    logger.info("Database connection established successfully");
    return connection;
  }

  public static void closeConnection(Connection connection) {
    try {
      if (connection != null && !connection.isClosed()) {
        connection.close();
        logger.info("Database connection closed successfully");
      }
    } catch (SQLException e) {
      logger.log(Level.SEVERE, "Failed to close database connection", e);
    }
  }
}
