# syntax=docker/dockerfile:1

FROM php:7.4.25-apache

WORKDIR /var/www/html/

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
