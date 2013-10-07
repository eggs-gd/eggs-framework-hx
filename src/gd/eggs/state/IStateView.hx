package gd.eggs.state;

/**
 * @author Dukobpa3
 */
interface IStateView {
	
	//=========================================================================
	//	VARIABLES
	//=========================================================================
	
	var stateModel(default, null):IStateModel;
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	function onStateBegin():Void;
	function onStateEnd():Void;
}