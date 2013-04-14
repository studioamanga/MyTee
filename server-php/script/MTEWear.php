<?php

	class MTEWear
	{
		static function post_request($tshirt_id)
		{
			return 'INSERT INTO mt_wear (wea_tshirt_id, wea_date) VALUES (\''.$tshirt_id.'\', NOW())';
		}
	}
	
?>