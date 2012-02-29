<?php
	
	class MTEAuthentication
	{
		static function authentication_credential($credential_name, $request_method)
		{
			if ($request_method=='POST')
			{
				if (isset($_POST[$credential_name]))
					return $_POST[$credential_name];
				else
					return null;
			}
			if ($request_method=='GET')
			{
				if (isset($_GET[$credential_name]))
					return $_GET[$credential_name];
				else
					return null;
			}
			
			return null;
		}
		
		static function authentication_login($request_method)
		{
			return MTEAuthentication::authentication_credential('login', $request_method);
		}
		
		static function authentication_password($request_method)
		{
			return MTEAuthentication::authentication_credential('password', $request_method);
		}
	}
?>