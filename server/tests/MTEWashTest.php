<?php

	require_once dirname(__FILE__).'/../script/MTEWash.php';
	
	class MTEWashTest extends PHPUnit_Framework_TestCase
	{
		function testPostRequest()
		{
			$output = MTEWash::post_request('TSHIRT_ID');	
			$this->assertEquals($output, 'INSERT INTO mt_wash (was_tshirt_id, was_date) VALUES (\'TSHIRT_ID\', NOW())');
		}
	}
	
?>