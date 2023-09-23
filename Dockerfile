# Use the official PHP image as your base image
FROM php:8.2-fpm

# Arguments defined in docker-compose.yml
ARG USER
ARG UID

# Set working directory

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $UID -d /home/$USER $USER
RUN mkdir -p /home/$USER/.composer && \
    chown -R $USER:$USER /home/$USER

RUN mkdir -p sql-data && \
    chown -R $USER:$USER sql-data

# Switch to the app_user
USER $USER

# RUN /bin/bash -c '/opt/src/scripts/script.sh'

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
