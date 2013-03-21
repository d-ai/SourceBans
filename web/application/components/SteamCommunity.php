<?php
require_once 'SteamGame.php';
require_once 'SteamGroup.php';
require_once 'SteamProfile.php';

/**
 * Steam Community Data and Web API
 * 
 * @author GameConnect
 * @copyright (C)2007-2013 GameConnect.net.  All rights reserved.
 * @link http://www.sourcebans.net
 * 
 * @property string $apiKey
 * @property integer $requestTimeout
 * 
 * @package sourcebans.components
 * @since 2.0
 */
class SteamCommunity
{
	/**
	 * @var integer Request timeout in seconds
	 */
	public static $requestTimeout = 2;
	
	/**
	 * @var string Steam Web API Key
	 */
	private static $_apiKey;
	
	
	/**
	 * Normalizes an API request
	 * 
	 * @param string $interface
	 * @param string $method
	 * @param integer $version
	 * @param array $data
	 * @return string
	 */
	public static function apiRequest($interface, $method, $version, $data = array())
	{
		$data['key'] = self::$_apiKey;
		
		$url = sprintf('http://api.steampowered.com/%s/%s/v%04d', $interface, $method, $version);
		return self::_request($url, $data);
	}
	
	/**
	 * Normalizes a data request
	 * 
	 * @param string $path
	 * @param array $data
	 * @return string
	 */
	public static function request($path, $data = array())
	{
		$data['xml'] = 1;
		
		$url = 'http://steamcommunity.com/' . $path;
		return self::_request($url, $data);
	}
	
	/**
	 * Sets the Steam Web API Key
	 * 
	 * @param string $apiKey The Steam Web API Key
	 */
	public static function setApiKey($apiKey)
	{
		$this->_apiKey = $apiKey;
	}
	
	
	/**
	 * Builds a query string and requests the URL
	 * 
	 * @param string $url
	 * @param array $data
	 * @return string
	 */
	private static function _request($url, $data = array())
	{
		$url .= '/?' . http_build_query($data);
		
		if(function_exists('curl_init'))
		{
			$ch = curl_init();
			curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
			curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($ch, CURLOPT_TIMEOUT, self::$requestTimeout);
			curl_setopt($ch, CURLOPT_URL, $url);
			
			$result = curl_exec($ch);
			$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
			if($httpCode == 200)
				return $result;
		}
		else if(ini_get('allow_url_fopen'))
		{
			$ctx = stream_context_create(array(
				'http' => array(
					'timeout' => self::$requestTimeout,
				),
			));
			
			return @file_get_contents($url, false, $ctx);
		}
		
		return null;
	}
}