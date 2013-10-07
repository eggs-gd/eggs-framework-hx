package gd.eggs.mvc.view;

import gd.eggs.utils.IInitialize;
import msignal.Signal.Signal1;
import msignal.Signal.Signal2;

/**
 * @author Dukobpa3
 */
interface IView extends IInitialize {
	
	//=========================================================================
	//	VARIABLES
	//=========================================================================
	
	var signals(default, null):Map<EnumValue, Signal1<Dynamic>>;
	var changeSignal(default, null):Signal2<EnumValue, Dynamic>;
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	function show():Void;
	function hide():Void;
	function invalidate():Void;
	function dispatch(type:EnumValue, ?data:Dynamic):Void;
}