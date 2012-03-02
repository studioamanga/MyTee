<?php
	header('Content-type: application/json');
	
	require_once('script/MTEToolbox.php');
	require_once('script/MTEStore.php');
	require_once('script/MTETShirt.php');
	require_once('script/MTEWear.php');
	require_once('script/MTEWash.php');
	require_once('script/MTEUser.php');
	require_once('script/MTEDatabase.php');
	require_once('script/MTEAuthentication.php');
	
	$request_method = $_SERVER['REQUEST_METHOD'];
	
	$login = MTEAuthentication::authentication_login($request_method);
	$password = MTEAuthentication::authentication_password($request_method);
	
	if (!$login || !$password)
	{
		header('HTTP/1.0 403 Forbidden');
		die('403 Forbidden, sorry');
	}
	
	if(!filter_var($login, FILTER_VALIDATE_EMAIL) || !ctype_alnum($password))
	{
		header('HTTP/1.0 403 Forbidden');
		die('403 Forbidden, sorry');
	}

	$database = new MTEDatabase();
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
	
	$request_elements_serialized = substr($request_path, strlen('/mytee/api/'));
	$request_elements = explode('/', $request_elements_serialized);
	
	if (count($request_elements)<2)
	{
		header('Status: 404 Not Found');
		echo '404, sorry';
	}
	else
	{
		$api_resource = $request_elements[0];
		$api_parameter = $request_elements[1];
		
		if ($api_resource=='store')
		{
			if($api_parameter=='all')
			{
				$stores = $database->fetch('mt_store');
		
				foreach ($stores as &$store)
					$store = MTEStore::clean_store_from_db($store);
		
				MTEToolbox::output_json($stores);
			}
			else if (ctype_alnum($api_parameter))
			{
				$stores = $database->fetch('mt_store', '`sto_id`=\''.$api_parameter.'\'');
			
				if(count($stores)==1)
				{
					$store = MTEStore::clean_store_from_db($stores[0]);
					MTEToolbox::output_json($store);
				}
			}	
		}
		elseif ($api_resource=='tshirt')
		{
			if($api_parameter=='all')
			{
				$tshirts = $database->fetch('mt_tshirt', '`tsh_user_id`=\''.$user->use_id.'\' AND `tsh_is_mine`=\'1\'');
		
				foreach ($tshirts as &$tshirt) 
				{
					$tshirt = MTETShirt::clean_tshirt_from_db($tshirt);
					$tshirt = MTETShirt::fectch_wash_wear_store_for_tshirt($database, $tshirt);
				}
		
				MTEToolbox::output_json($tshirts);
			}
			else if (ctype_alnum($api_parameter))
			{
				if ($request_method=='GET')
				{
					$tshirts = $database->fetch('mt_tshirt', '`tsh_id`=\''.$api_parameter.'\' AND `tsh_user_id`=\''.$user->use_id.'\'');
			
					if(count($tshirts)==1)
					{	
						$tshirt = MTETShirt::clean_tshirt_from_db($tshirts[0]);
						$tshirt = MTETShirt::fectch_wash_wear_store_for_tshirt($database, $tshirt);
						MTEToolbox::output_json($tshirt);
					}
				}
				elseif ($request_method=='POST' && isset($request_elements[2]))
				{
					$api_specifier = $request_elements[2];
					
					if ($api_specifier=='wear')
					{
						$post_query = MTEWear::post_request($api_parameter);
						$database->query($post_query);
						
						echo '{}';
					}
					elseif ($api_specifier=='wash')
					{
						$post_query = MTEWash::post_request($api_parameter);
						$database->query($post_query);
						
						echo '{}';	
					}
				}
			}
		}
		elseif ($api_resource=='user')
		{
			if($api_parameter=='me')
			{
				$users = $database->fetch('mt_user', '`use_id`=\''.$user->use_id.'\'');
		
				if(count($users)==1)
				{	
					$user = MTEUser::clean_user_from_db($users[0]);
					MTEToolbox::output_json($user);
				}
			}
		}
	}
	
	$database->disconnect();
?>