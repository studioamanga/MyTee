<?php

	function clean_user_from_db($user)
	{
		$user = rename_keys($user, array('use_id', 'use_name', 'use_email'), array('identifier', 'name', 'email'), true);
		
		return $user;
	}

?>