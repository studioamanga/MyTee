<?php
	header('Content-type: application/json');
	
	include_once('script/toolbox.php');
	include_once('script/store.php');
	include_once('script/tshirt.php');
	include_once('script/db.php');

	$database = new mt_database();
	$database->connect();
	
	$request_uri = $_SERVER['REQUEST_URI'];
	$request_elements = explode ('/', $request_uri);
	
	$api_index = array_search('api', $request_elements);
	
	if($api_index===false || $api_index!=(count($request_elements)-3))
	{
		header('Status: 404 Not Found');
		echo '404, sorry';
	}
	else
	{
		$api_resource = $request_elements[$api_index+1];
		$api_parameter = $request_elements[$api_index+2];
		
		if ($api_resource=='store')
		{
			if($api_parameter=='all')
			{
				$stores = $database->fetch('mt_store');
		
				foreach ($stores as &$store)
					$store = clean_store_from_db($store);
		
				output_json($stores);
			}
			else if (ctype_alnum($api_parameter))
			{
				$stores = $database->fetch('mt_store', 'sto_id='.$api_parameter.'');
			
				if(count($stores)==1)
				{
					$store = clean_store_from_db($stores[0]);
					output_json($store);
				}
			}	
		}
		if ($api_resource=='tshirt')
		{
			if($api_parameter=='all')
			{
				$tshirts = $database->fetch('mt_tshirt');
		
				foreach ($tshirts as &$tshirt) 
				{
					$tshirt = clean_tshirt_from_db($tshirt);
					$tshirt = fectch_wash_wear_for_tshirt($database, $tshirt);
				}
		
				output_json($tshirts);
			}
			if (ctype_alnum($api_parameter))
			{
				$tshirts = $database->fetch('mt_tshirt', 'tsh_id='.$api_parameter.'');
			
				if(count($tshirts)==1)
				{	
					$tshirt = clean_tshirt_from_db($tshirts[0]);
					$tshirt = fectch_wash_wear_for_tshirt($database, $tshirt);
					output_json($tshirt);
				}
			}
		}
	}
	
	$database->disconnect();
?>