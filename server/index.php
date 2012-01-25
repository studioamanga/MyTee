<?php
	header('Content-type: application/json');
	
	include_once('script/toolbox.php');
	include_once('script/db.php');

	$database = new mt_database();
	$database->connect();
	
	$request_uri = $_SERVER['REQUEST_URI'];
	
	if(ends_with($request_uri, '/api/store/all'))
	{
		$stores = $database->fetch('mt_store');
		
		foreach ($stores as &$store)
		{
			$store = rename_keys($store, array('sto_id', 'sto_name', 'sto_type', 'sto_address'), array('identifier', 'name', 'type', 'address'), true);
		}
		
		$stores_json = json_encode($stores);
		echo clean_output($stores_json);
	}
	
	$database->disconnect();
?>