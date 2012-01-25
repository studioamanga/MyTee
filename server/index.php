<?php
	header('Content-type: application/json');
	
	include_once('script/toolbox.php');
	include_once('script/store.php');
	include_once('script/db.php');

	$database = new mt_database();
	$database->connect();
	
	$request_uri = $_SERVER['REQUEST_URI'];
	
	$store_uri = '/api/store/';
	if (strpos($request_uri, $store_uri) !== false)
	{
		$store_id = substr($request_uri, strpos($request_uri, $store_uri)+strlen($store_uri));
		
		if($store_id=='all')
		{
			$stores = $database->fetch('mt_store');
		
			foreach ($stores as &$store)
			{
				$store = clean_store_from_db($store);
			}
		
			$stores_json = json_encode($stores);
			echo clean_output($stores_json);
		}
		else if (ctype_alnum($store_id))
		{
			$stores = $database->fetch('mt_store', 'sto_id='.$store_id.'');
			
			if(count($stores)==1)
			{
				$store = clean_store_from_db($stores[0]);
				$store_json = json_encode($store);
				echo clean_output($store_json);
			}
		}
		else
		{
			header('Status: 404 Not Found');
		}
	}
	
	$database->disconnect();
?>