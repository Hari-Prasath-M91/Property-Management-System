# Property Management System

Welcome to the **Property Management System** - a comprehensive web application for managing real estate properties built with Streamlit and Oracle database. This README provides instructions for setting up and running the application.

> **For a detailed overview of the project design, features, and technical insights, please see the [Report.pdf](Report.pdf).**

## Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Installation & Setup](#installation--setup)
- [Running the Project](#running-the-project)
- [User Roles](#user-roles)
- [Database Structure](#database-structure)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview

The Property Management System (PMS) facilitates property transactions between buyers and sellers with administrative oversight. The system provides property listing, search functionality, user registration, and secure communication channels.

## Requirements

Before you begin, ensure you have the following installed:

1. **Python 3**  
   Available from https://www.python.org/

2. **Oracle Instant Client**  
   - Download the Oracle Instant Client (e.g., instantclient_23_5)
   - Configure path in code (see Installation section)

3. **Oracle Database**  
   An accessible Oracle database instance

4. **Python Libraries**  
   - streamlit
   - pandas
   - cx_Oracle
   - base64
   - urllib.parse

   All libraries are listed in the requirements.txt file.

## Installation & Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/Property-Management-System.git
   cd Property-Management-System
   ```

2. **Set Up a Virtual Environment (Recommended)**
   ```bash
   python -m venv venv
   
   # On Windows
   venv\Scripts\activate
   
   # On macOS/Linux
   source venv/bin/activate
   ```

3. **Install Required Packages**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure Oracle Connection**
   - In both Photo Upload.py and Home.py, update the Oracle client path:
     ```python
     cx_Oracle.init_oracle_client(lib_dir=r"D:\Programs\oracle\instantclient_23_5")
     ```
   - Update the database connection parameters (host, port, SID, username, password)

5. **Set Up the Database**
   - Run the Backend.sql file using your Oracle client to create tables and schema
   - Run Photo Upload.py once to initialize the database with sample images

## Running the Project

There are two steps to get the website up and running:

### 1. Initialize the Database (One-time Setup)
```bash
# First run Backend.sql in your Oracle client

# Then run the photo upload script
python "Photo Upload.py"
```

### 2. Launch the Web Interface
```bash
streamlit run Home.py
```

Your default web browser will open with the Property Management System interface.

## User Roles

The system supports three user types:
- **Buyers**: Search and browse properties, make inquiries
- **Sellers**: List properties with details and images
- **Admins**: Validate properties and manage user requests

For detailed information about user roles and system features, please refer to the [Report.pdf](Report.pdf).

## Database Structure

The system uses a fully normalized Oracle database with tables for:
- Users (Admin, Buyer, Seller)
- Properties and Property Photos
- Enquiries and Conversations
- Payments and Registrations

For complete database schema and normalization details, please refer to the [Report.pdf](Report.pdf).

## Troubleshooting

- **Oracle Client Issues**  
  Verify that the Oracle Instant Client path is correctly set in the scripts

- **Database Connection Errors**  
  Check the connection parameters (host, port, SID, username, password)

- **Missing Libraries**  
  Run `pip install -r requirements.txt` to install required packages

- **Streamlit Browser Issues**  
  If the interface doesn't open automatically, copy the URL from your terminal

## Contributing

We welcome contributions to improve the Property Management System:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add new feature'`)
5. Push to the branch (`git push origin feature-branch`)
6. Open a Pull Request

Please ensure your code follows the project's coding standards and includes appropriate tests.

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

## Contact

If you have questions, suggestions, or issues, please:

- Open an issue on GitHub
- Contact the project maintainers at [your.email@example.com](mailto:your.email@example.com)

For more details about the project's design, features, and implementation, please refer to the [Report.pdf](Report.pdf).
