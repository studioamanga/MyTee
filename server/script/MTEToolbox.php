<?php

	class MTEToolbox
	{
		static function starts_with($haystack, $needle)
		{
			$length = strlen($needle);
			return (substr($haystack, 0, $length) === $needle);
		}
	
		static function ends_with($haystack, $needle)
		{
			$length = strlen($needle);
			$start  = $length * -1; //negative
			return (substr($haystack, $start) === $needle);
		}
		
		static function rename_keys($array, $from_keys, $to_keys, $trim_others = false)
		{
			$new_array = array();
			
			foreach ($array as $key => $value)
			{
				for ($i = 0 ; $i < count($from_keys) ; $i++)
				{
					if ($key==$from_keys[$i])
					{
						$new_array[$to_keys[$i]] = $value;
					}
					else if (!$trim_others)
					{
						$new_array[$key] = $value;
					}
				}
			}
			
			return $new_array;
		}
			
		static function clean_output($output)
		{
			$output = str_replace('\/', '/', $output);
			return $output;
		}
	
		static function output_json($object)
		{
			$tshirt_json = json_encode($object);
			echo MTEToolbox::clean_output($tshirt_json);
		}
	}
	
?>