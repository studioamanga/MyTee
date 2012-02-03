<?php

	function clean_tshirt_from_db($tshirt)
	{
		$tshirt_alt_image = $tshirt->tsh_img;
		
		$tshirt = rename_keys($tshirt, array('tsh_id', 'tsh_name', 'tsh_size', 'tsh_color', 'tsh_condition', 'tsh_rating', 'tsh_tags', 'tsh_store_id', 'tsh_note', 'tsh_img_close'), array('identifier', 'name', 'size', 'color', 'condition', 'rating', 'tags', 'store_id', 'note', 'image_url'), true);
		
		$img_url_relative = 'img/tshirts/'.$tshirt['identifier'].'/'.$tshirt['image_url'];
		if(!file_exists('../'.$img_url_relative))
		{
			$img_url_relative = str_replace('.jpg', '_300px.jpg', $img_url_relative);
			
			if(!file_exists('../'.$img_url_relative))
			{
				$img_url_relative = 'img/tshirts/'.$tshirt['identifier'].'/'.$tshirt_alt_image;
				
				if(!file_exists('../'.$img_url_relative))
				{
					$img_url_relative = str_replace('.jpg', '_300px.jpg', $img_url_relative);
				}
			}
		}
		
		$tshirt['image_url'] = 'http://www.studioamanga.com/mytee/'.$img_url_relative;
		
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
	
	function fectch_wash_wear_store_for_tshirt($database, $tshirt)
	{
		$wears = $database->fetch('mt_wear', 'wea_tshirt_id='.$tshirt['identifier'].'');
		foreach($wears as &$wear)
			$wear = clean_wear_from_db($wear);
		$tshirt['wear'] = $wears;
					
		$washs = $database->fetch('mt_wash', 'was_tshirt_id='.$tshirt['identifier'].'');
		foreach($washs as &$wash)
			$wash = clean_wash_from_db($wash);
		$tshirt['wash'] = $washs;
					
		$stores = $database->fetch('mt_store', '`sto_id`=\''.$tshirt['store_id'].'\'');
		if (count($stores)==1)
		{
			$tshirt['store'] = clean_store_from_db($stores[0]);
		}
		unset($tshirt['store_id']);
		
		return $tshirt;
	}
	
?>