# My Bullion - Laravel Back End

## Overview

A web application built with Laravel, designed to provide a robust API for managing users' gold and silver investments. This backend service allows users to securely sign up, log in, and track their precious metal holdings, whether as individual items (e.g., coins) or as total weights. It provides endpoints for fetching real-time spot prices and tracking the portfolio's value over time, helping users to monitor gains and losses effectively.

-   Developer: Jack Fitzgibbon (@fitzgibbonjack)
-   Deployment: tbc

## Requirements

-   Docker

## Running the application locally

-   Duplicate .env.example file and call it .env
    -   Database credentials
    -   SMTP credentials
    -   S3 credentials
-   Run `docker-compose up -d`
-   Run `docker-compose exec app bash`
    -   Run `composer install`
    -   Run `php artisan storage:link`
-   Create database
    -   create local database named `my-bullion`
    -   `docker-compose exec app php artisan migrate:fresh --seed`
-   Visit the local url specified in [access](#access) section
    -   Should return a Laravel 404 page

## Access

| Environment |                    URL                     |
| ----------: | :----------------------------------------: |
|       Local | https://my-bullion.local.designbysweet.com |
