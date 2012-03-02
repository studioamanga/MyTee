<?php

	require_once dirname(__FILE__).'/../script/MTEWear.php';
	
	class MTEWearTest extends PHPUnit_Framework_TestCase
	{
		function testPostRequest()
		{
			$output = MTEWear::post_request('TSHIRT_ID');	
			$this->assertEquals($output, 'INSERT INTO mt_wear (wea_tshirt_id, wea_date) VALUES (\'TSHIRT_ID\', NOW())');
		}
	}
	
?>