<?php

	function db_connect() {
		// Load (secret) parameters from configuration file
		$db_parameters_json = file_get_contents('script/db_parameters.json');
		$db_parameters = json_decode($db_parameters_json, true);
		
		if(!$db_parameters)
  		die('[!] Unable to load database parameters.');
  	
  	// Connect to database
 		$db_connection = mysql_connect($db_parameters['db_url'], $db_parameters['db_login'], $db_parameters['db_password'])
				or die('[!] Unable to connect to the database.');
		mysql_select_db($db_parameters['db_name'], $db_connection) or die ('[!] Unable to connect to the database.');
		
		return $db_connection;
	}
	
	function db_disconnect($db_connection) {
		mysql_close($db_connection);
	}
?>