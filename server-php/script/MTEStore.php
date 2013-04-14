<?php

	class MTEStore
	{
		static function clean_store_from_db($store)
		{
			$store = MTEToolbox::rename_keys($store, array('sto_id', 'sto_name', 'sto_type', 'sto_address'), array('identifier', 'name', 'type', 'address'), true);
			
			if($store['type']=='Web')
			{
				$store['url'] = $store['address'];
				unset($store['address']);
			}
		
			return $store;
		}
	}

?>