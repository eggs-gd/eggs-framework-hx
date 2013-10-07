package gd.eggs.utils;

/**
 * @author SlavaRa
 */
interface IInitialize {
	var isInited(default, null):Bool;
	
	function init():Void;
	function destroy():Void;
}