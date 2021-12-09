<?php

require_once 'utils.php';

$person = $connection->query ("SELECT * FROM person LIMIT 1")->fetch_assoc ();

?>

<!DOCTYPE html>
<html lang="en">

	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		
		<title data-title="Futurity Savings">Mock Http API</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">

        <style>
            html, body { padding: 0; margin: 0; }
        </style>
	</head>

	<body class="d-flex justify-content-center align-items-center">
        <div id="content">
            <h1>Mock Http API</h1>

            <p><strong>List of available endpoints for API</strong></p>

            <ul>
                <li>List of people, supports pagination: <a href="http://localhost:8080/people/" target="_blank">http://localhost:8080/people/</a></li>
                <li>
                    Single person: <a href="http://localhost:8080/person/?uuid=<?= $person['uuid']; ?>" target="_blank">http://localhost:8080/person/?uuid=<?= $person['uuid']; ?></a>
                </li>
            </ul>
        </div>
	</body>

</html>
