package gd.eggs.state;

import gd.eggs.mvc.model.IModel;
import msignal.Signal.Signal1;

/**
 * @author Dukobpa3
 */
interface IStateModel extends IModel {
	
	//=========================================================================
	//	VARIABLES
	//=========================================================================
	
	/** map of states implementations */
	var states(default, null):Map<EnumValue, IState>;
	
	/** states history */
	var statePrevious(default, null):IState;
	var stateCurrent(default, null):IState;
	var statePending(default, null):IState;
	
	/** dispatch [success | fail] when state beginning */
	var stateBeginSignal(default, null):Signal1<Bool>;
	
	/** dispatch [success | fail] when state setted */
	var stateEndSignal(default, null):Signal1<Bool>;
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	/** action to begin transition to state */
	function stateBegin(state:EnumValue):Void;
	
	/** complete transition */
	function stateEnd():Void;
}