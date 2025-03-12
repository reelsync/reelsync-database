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
│── migrations/        # Flyway migration scripts
│── schema/            # Database schema definitions
│── docker/            # Docker configuration files
│── config/            # Environment configurations
│── scripts/           # Database utility scripts
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
Modify `.env` or `config/database.yml` for environment-specific settings. Default values:
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

Let me know if you’d like additional sections or refinements!

