<?php

	class MTEDatabase
	{
		private $db_connection = null;
		
		public function connect()
		{
			// Load (secret) parameters from configuration file
			$db_parameters_json = file_get_contents('script/db_parameters.json');
			$db_parameters = json_decode($db_parameters_json, true);
		
			if(!$db_parameters)
  			die('[!] Unable to load database parameters.');
  	
	  	// Connect to database
 			$this->db_connection = mysql_connect($db_parameters['db_url'], $db_parameters['db_login'], $db_parameters['db_password'])
				or die('[!] Unable to connect to the database.');
			mysql_select_db($db_parameters['db_name'], $this->db_connection) or die ('[!] Unable to connect to the database.');
		
			return true;
		}
		
		public function disconnect()
		{
			mysql_close($this->db_connection);
		}
		
		public function fetch($table_name, $condition = null)
		{
			$request = 'SELECT * FROM '.$table_name;
			if($condition)
			{
				$request .= ' WHERE '.$condition;
			}
			
			$result = mysql_query($request, $this->db_connection);
			
			$tabs = array();
			
			if($result)
			{
				while ($tab = mysql_fetch_object($result))
				{
					$tabs[] = $tab;
				}
			}
			
			return $tabs;
		}
	}

?>