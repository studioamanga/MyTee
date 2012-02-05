<?php
	header('Content-type: application/json');
	
	include_once('script/toolbox.php');
	include_once('script/store.php');
	include_once('script/tshirt.php');
	include_once('script/db.php');
	
	if (!isset($_GET['login']) || !isset($_GET['password']))
	{
		header('HTTP/1.0 403 Forbidden');
		die('403 Forbidden, sorry');
	}
	
	$login = $_GET['login'];
	$password = $_GET['password'];
	
	if(!filter_var($login, FILTER_VALIDATE_EMAIL) || !ctype_alnum($password))
	{
		header('HTTP/1.0 403 Forbidden');
		die('403 Forbidden, sorry');
	}

	$database = new mt_database();
	$database->connect();
	
	$users = $database->fetch('mt_user', '`use_email` =  \''.$login.'\' AND `use_password_md5` =  \''.md5($password).'\'');

	if (empty($users))
	{
		header('HTTP/1.0 403 Forbidden');
		die('403 Forbidden, sorry');
	}
	
	$user = $users[0];
	
	$request_uri = $_SERVER['REQUEST_URI'];
	$request_url_components = parse_url($request_uri);
	$request_path = $request_url_components['path'];
	
	$request_elements = explode ('/', $request_path);
	
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
				$stores = $database->fetch('mt_store', '`sto_id`=\''.$api_parameter.'\'');
			
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
				$tshirts = $database->fetch('mt_tshirt', '`tsh_user_id`=\''.$user->use_id.'\' AND `tsh_is_mine`=\'1\'');
		
				foreach ($tshirts as &$tshirt) 
				{
					$tshirt = clean_tshirt_from_db($tshirt);
					$tshirt = fectch_wash_wear_store_for_tshirt($database, $tshirt);
				}
		
				output_json($tshirts);
			}
			if (ctype_alnum($api_parameter))
			{
				$tshirts = $database->fetch('mt_tshirt', '`tsh_id`=\''.$api_parameter.'\' AND `tsh_user_id`=\''.$user->use_id.'\'');
			
				if(count($tshirts)==1)
				{	
					$tshirt = clean_tshirt_from_db($tshirts[0]);
					$tshirt = fectch_wash_wear_store_for_tshirt($database, $tshirt);
					output_json($tshirt);
				}
			}
		}
	}
	
	$database->disconnect();
?>