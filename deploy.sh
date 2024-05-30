#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Node.js, npm, and Git
sudo apt install -y nodejs npm git

# Install MySQL Server
sudo apt install -y mysql-server

# Start MySQL service
sudo systemctl start mysql

# Set root password and create database and user
sudo mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_root_password';
FLUSH PRIVILEGES;
SET GLOBAL validate_password.policy = LOW;
SET GLOBAL validate_password.length = 4;
CREATE DATABASE IF NOT EXISTS ecommerce;
DROP USER IF EXISTS 'yourusername'@'localhost';
CREATE USER 'yourusername'@'localhost' IDENTIFIED BY 'yourpassword';
GRANT ALL PRIVILEGES ON ecommerce.* TO 'yourusername'@'localhost';
FLUSH PRIVILEGES;
EOF

# Clone the repository
git clone https://github.com/your-repo.git
cd your-repo

# Install backend dependencies
cd backend
npm install

# Install frontend dependencies and build
cd ../frontend
npm install
chmod +x node_modules/.bin/react-scripts
npm run build
cd ..

# Setup environment variables
cat <<EOF > backend/.env
DB_HOST=localhost
DB_USER=yourusername
DB_PASS=yourpassword
DB_NAME=ecommerce
JWT_SECRET=your_jwt_secret
EOF

# Set permissions for uploads directory
cd backend
mkdir -p uploads
sudo chmod -R 755 uploads
sudo chown -R www-data:www-data uploads
sudo chmod 777 /home
sudo chmod 777 /home/ubuntu
sudo chmod 777 /home/ubuntu/classproject
sudo chmod 777 /home/ubuntu/classproject/backend
sudo chmod 777 /home/ubuntu/classproject/uploads
cd ..



# Install and configure Nginx
sudo apt install -y nginx
sudo bash -c 'cat <<EOF > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name your-ec2-ip;

    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }

    location /uploads/ {
        alias /home/ubuntu/classproject/backend/uploads/;
        autoindex on;
        allow all;
    }
}
EOF'

sudo nginx -t
sudo systemctl restart nginx

# Run backend
cd backend
npm start 
