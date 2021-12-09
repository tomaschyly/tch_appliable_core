<?php

use Faker\Factory;

require_once 'vendor/autoload.php';

/**
 * Display JSON response.
 */
function JSONResponse (array $data) {
    header ('Content-Type: application/json; charset=utf-8');

    echo json_encode ($data);
    exit;
}

$faker = Factory::create ();

class Person {
    public string $uuid;
    public string $name;
    public string $address;
    public string $phone;

    /**
     * Person initialization with Fake data.
     */
    function __construct () {
        global $faker;

        $this->uuid = $faker->uuid;
        $this->name = $faker->name;
        $this->address = $faker->address;
        $this->phone = $faker->phoneNumber;
    }
}

$connection = new mysqli ('db', 'root', 'development');

$connection->query ('CREATE DATABASE IF NOT EXISTS mock_http_api;');

$connection->query ('use mock_http_api;');

$connection->query ('CREATE TABLE IF NOT EXISTS person (uuid VARCHAR(100) NOT NULL PRIMARY KEY, name TEXT, address TEXT, phone VARCHAR(50) NOT NULL);');

$peopleCount = $connection->query ('SELECT * FROM person LIMIT 1;')->num_rows;

if ($peopleCount < 1) {
    for ($i = 0; $i < 1000; $i++) {
        $person = new Person ();

        $connection->query ("INSERT INTO person (uuid, name, address, phone) VALUE ('" . $person->uuid . "', '" . $person->name . "', '" . $person->address . "', '" . $person->phone . "')");
    }
}

$peopleCount = $connection->query ('SELECT * FROM person;')->num_rows;
