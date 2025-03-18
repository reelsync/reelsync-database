# **ReelSync Database**

**ReelSync Database** is the core **PostgreSQL database** for the **ReelSync** project, responsible for storing and managing video metadata efficiently. This repository contains the schema, migration scripts, and database management tools required for the ReelSync system.

## **Features**
- **PostgreSQL Schema** – Well-structured relational design for video metadata storage.
- **Flyway Migrations** – Ensures database consistency across environments.
- **Docker Support** – Easy deployment using Docker and Docker Compose.
- **Scalability** – Optimized for large video collections and efficient querying.
- **Security Best Practices** – Follows best practices for authentication and access control.

## **Project Structure**
```
ReelSync Database/
│── sql/               # SQL scripts for schema and migrations
│   ├── migrations/    # Flyway migration scripts
│   ├── V0_0_0__initial_setup.sql
│   ├── V0_0_1__initial_data.sql
│── config/            # Configuration files for database and migrations
│   ├── flyway.conf    # Flyway configuration file
│── docker-compose.yml # Docker Compose configuration
│── README.md          # Project documentation
```

## **Getting Started**

### **1. Clone the Repository**
```sh
git clone https://github.com/ReelSync/Database.git
cd Database
```

### **2. Set Up and Run with Docker**
Ensure **Docker** and **Docker Compose** are installed, then run:
```sh
docker-compose up -d
```
This starts a **PostgreSQL** instance with the defined schema and migrations applied.

### **3. Database Configuration**
Modify `.env` or `config/flyway.conf` for environment-specific settings. Default values:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=reelsync
DB_USER=reelsync_user
DB_PASSWORD=securepassword
```

### **4. Applying Migrations Manually**
```sh
flyway migrate -configFiles=config/flyway.conf
```

## **Development Workflow**
- **Trunk-Based Development** – Changes are merged directly into `main` with small, incremental commits.
- **Migrations First** – Schema changes should always be made through Flyway migrations.
- **Testing** – Automated database tests will be added to ensure consistency.

## **Contributing**
This project is currently a **solo development effort**, but contributions may be considered in the future. Please follow best practices for database migrations and schema changes.

## **License**
ReelSync Database is licensed under the **MIT License**.

---

# ReelSync Database

This repository contains the database schema and migration scripts for ReelSync, a video metadata management system.

## Database Schema

The database schema includes the following components:
- **Tables**: Define core entities.
- **Constraints**: Enforce data integrity.
- **Indexes**: Optimize query performance.
- **Views**: Provide simplified access to data.
- **Triggers**: Automate system behaviors.

## Initial Setup

The initial setup script (`V0_0_0__initial_setup.sql`) defines the baseline schema for the ReelSync database. This script includes the creation of tables, constraints, indexes, views, and triggers.

## Migrations

We use Flyway for database migrations. The migration scripts are located in the `sql/migrations` directory.

### Running Migrations

To run the migrations, use the following command:

```sh
flyway migrate -configFiles=config/flyway.conf
```

### Baseline Version

The baseline version is defined in the `V0_0_0__initial_setup.sql` file with the following metadata:
- **Version**: 0.0.0
- **Description**: Initial setup

### Initial Data

The initial data script (`V0_0_1__initial_data.sql`) populates the database with realistic test data. This script includes the insertion of categories, studios, storage device types, storage devices, videos, files, tags, video tags, file tags, persons, roles, video roles, log levels, logs, metadata sources, metadata types, and metadata.

## Contributing

Please follow the guidelines below when contributing to this repository:
1. Ensure all SQL scripts are idempotent.
2. Use meaningful commit messages.
3. Test your changes thoroughly before submitting a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

