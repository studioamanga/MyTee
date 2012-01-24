<?php
	echo 'Hello World';

	include_once('script/db.php');
	$db_connection = db_connect();
	
	$request_uri $_SERVER['REQUEST_URI'];
	
	db_disconnect($db_connection);
?>