<?php

require_once '../utils.php';

global $connection;
global $peopleCount;

$page = isset ($_GET['page']) ? intval ($_GET['page']) : 1;
$limit = isset ($_GET['limit']) ? intval ($_GET['limit']) : 10;
$offset = ($page - 1) * $limit;

$people = $connection->query ("SELECT * FROM person LIMIT $limit OFFSET $offset")->fetch_all (MYSQLI_ASSOC);

JSONResponse ([
    'list' => $people,
    'total' => $peopleCount,
    'pages' => ceil ($peopleCount / $limit)
]);
