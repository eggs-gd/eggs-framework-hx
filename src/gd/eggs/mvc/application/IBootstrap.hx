package gd.eggs.mvc.application;
import gd.eggs.mvc.controller.IController;
import gd.eggs.utils.IInitialize;

/**
 * @author Dukobpa3
 */
interface IBootstrap extends IInitialize {
	//=========================================================================
	//	VARIABLES
	//=========================================================================
	
	var appController(default, null):IController;
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	function registerModels():Void;
	function registerViews():Void;
	function registerNotifications():Void;
	function registerControllers():Void;
}