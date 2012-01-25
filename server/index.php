<?php
	echo 'Hello World';

	include_once('script/db.php');
	$database = new mt_database();
	$database->connect();
	
	$request_uri = $_SERVER['REQUEST_URI'];
	
	$database->disconnect();
?>