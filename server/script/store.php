<?php

	function clean_store_from_db($store)
	{
		$store = rename_keys($store, array('sto_id', 'sto_name', 'sto_type', 'sto_address'), array('identifier', 'name', 'type', 'address'), true);
			
		if($store['type']=='Web')
		{
			$store['URL'] = $store['address'];
			unset($store['address']);
		}
		
		return $store;
	}

?>