<?php
	include_once dirname(__FILE__).DIRECTORY_SEPARATOR.'..'.DIRECTORY_SEPARATOR.'script'.DIRECTORY_SEPARATOR.'toolbox.php';
		
	class MTEToolboxTest extends PHPUnit_Framework_TestCase
	{
		function setUp()
		{
		}
		
		function tearDown()
		{
		}
		
		// starts_with
		
		function testStartsWithPositive()
		{
			$result = starts_with('abcdefg', 'abc');
    	$this->assertTrue($result);
    }
    
    function testStartsWithNegativeNotFound()
    {
    	$result = starts_with('abcdefg', 'xyz');
    	$this->assertFalse($result);
    }
    
    function testStartsWithNegativeNotBeginning()
    {
    	$result = starts_with('abcdefg', 'efg');
    	$this->assertFalse($result);
    }
    
    // ends_with
    
    function testEndsWithPositive()
    {
    	$result = ends_with('abcdefg', 'efg');
    	$this->assertTrue($result);
    }
    
    function testEndsWithNegativeNotFound()
    {
    	$result = ends_with('abcdefg', 'xyz');
    	$this->assertFalse($result);
    }
    
    function testEndsWithNegativeNotBeginning()
    {
    	$result = ends_with('abcdefg', 'abc');
    	$this->assertFalse($result);
    }
	}
	
?>