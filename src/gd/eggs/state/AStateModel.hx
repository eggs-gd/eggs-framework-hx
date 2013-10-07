package gd.eggs.state;

import gd.eggs.utils.IAbstractClass;
import gd.eggs.utils.Validate;
import msignal.Signal;

/**
 * @author Dukobpa3
 */
class AStateModel implements IStateModel implements IAbstractClass {
	
	//=========================================================================
	//	PARAMETERS
	//=========================================================================
	
	public var isInited(default, null):Bool;
	
	public var states(default, null):Map<EnumValue, IState>;
	
	public var statePrevious(default, null):IState;
	public var stateCurrent(default, null):IState;
	public var statePending(default, null):IState;
	
	public var stateBeginSignal(default, null):Signal1<Bool>;
	public var stateEndSignal(default, null):Signal1<Bool>;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	
	function new() {
		states = new Map();
		
		stateBeginSignal = new Signal0();
		stateEndSignal = new Signal0();
	}
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	
	public function init();
	public function destroy();
	
	public function stateBegin(state:EnumValue) {
		#if debug
		if(Validate.isNull(state)) throw "state is null";
		#end
		
		var wanted:IState = states.get(state);
		
		if(!Lambda.has(wanted.statesAvaliable, st)) {
			stateBeginSignal.dispatch(false);
			return;
		}
		
		statePrevious = stateCurrent;
		stateCurrent = null;
		statePending = wanted;
		
		stateBeginSignal.dispatch(true);
	}
	
	public function stateEnd() {
		stateCurrent = statePending;
		statePending = null;
		
		stateEndSignal.dispatch(true);
	}
	
}