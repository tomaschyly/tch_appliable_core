<?php

require_once '../utils.php';

global $connection;

$uuid = isset ($_GET['uuid']) ? $_GET['uuid'] : null;

$person = $connection->query ("SELECT * FROM person WHERE uuid = '$uuid'")->fetch_assoc ();

if ($person) {
    JSONResponse ([
        'person' => $person,
    ]);
} else {
    JSONResponse ([
        'error' => true,
    ]);
}
