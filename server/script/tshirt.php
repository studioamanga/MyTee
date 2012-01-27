<?php

	function clean_tshirt_from_db($tshirt)
	{
		$tshirt = rename_keys($tshirt, array('tsh_id', 'tsh_name', 'tsh_size', 'tsh_color', 'tsh_condition', 'tsh_rating', 'tsh_tags', 'tsh_store_id', 'tsh_note', 'tsh_img'), array('identifier', 'name', 'size', 'color', 'condition', 'rating', 'tags', 'store_id', 'note', 'image_url'), true);
		
		$tshirt['image_url'] = 'http://www.studioamanga.com/mytee/img/tshirts/'.$tshirt['identifier'].'/'.$tshirt['image_url'];
		
		return $tshirt;
	}
	
	function clean_wear_from_db($wear)
	{
		$wear = rename_keys($wear, array('wea_id', 'wea_date'), array('identifier', 'date'), true);
		
		return $wear;
	}
	
	function clean_wash_from_db($wash)
	{
		$wash = rename_keys($wash, array('was_id', 'was_date'), array('identifier', 'date'), true);
		
		return $wash;
	}
	
	function fectch_wash_wear_for_tshirt($database, $tshirt)
	{
		$wears = $database->fetch('mt_wear', 'wea_tshirt_id='.$tshirt['identifier'].'');
		foreach($wears as &$wear)
			$wear = clean_wear_from_db($wear);
		$tshirt['wear'] = $wears;
					
		$washs = $database->fetch('mt_wash', 'was_tshirt_id='.$tshirt['identifier'].'');
		foreach($washs as &$wash)
			$wash = clean_wash_from_db($wash);
		$tshirt['wash'] = $washs;
		
		return $tshirt;
	}
	
?>