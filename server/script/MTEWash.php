<?php

	class MTEWash
	{
		static function post_request($tshirt_id)
		{
			return 'INSERT INTO mt_wash (was_tshirt_id, was_date) VALUES (\''.$tshirt_id.'\', NOW())';
		}
	}
	
?>