<?php

	require_once dirname(__FILE__).'/../script/MTEToolbox.php';
		
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
			$result = MTEToolbox::starts_with('abcdefg', 'abc');
    	$this->assertTrue($result);
    }
    
    function testStartsWithNegativeNotFound()
    {
    	$result = MTEToolbox::starts_with('abcdefg', 'xyz');
    	$this->assertFalse($result);
    }
    
    function testStartsWithNegativeNotBeginning()
    {
    	$result = MTEToolbox::starts_with('abcdefg', 'efg');
    	$this->assertFalse($result);
    }
    
    // ends_with
    
    function testEndsWithPositive()
    {
    	$result = MTEToolbox::ends_with('abcdefg', 'efg');
    	$this->assertTrue($result);
    }
    
    function testEndsWithNegativeNotFound()
    {
    	$result = MTEToolbox::ends_with('abcdefg', 'xyz');
    	$this->assertFalse($result);
    }
    
    function testEndsWithNegativeNotBeginning()
    {
    	$result = MTEToolbox::ends_with('abcdefg', 'abc');
    	$this->assertFalse($result);
    }
    
    // clean_output
    
    function testCleanOutput()
    {
    	$output = MTEToolbox::clean_output('abc\/ def/ ij\\ klm\/ nop');	
    	$this->assertEquals($output, 'abc/ def/ ij\\ klm/ nop');
    }
    
    // output_json
    
    function testOutputJSON()
    {
    	$obj['abc'] = 'xyz';
    	$this->expectOutputString('{"abc":"xyz"}');
    	MTEToolbox::output_json($obj);
    }
	}
	
?>