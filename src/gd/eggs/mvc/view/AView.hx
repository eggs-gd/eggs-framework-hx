package gd.eggs.mvc.view;

import gd.eggs.display.Sprite;
import gd.eggs.utils.DestroyUtils;
import gd.eggs.utils.IAbstractClass;
import gd.eggs.utils.Validate;
import msignal.Signal;

/**
 * @author Dukobpa3
 */
enum ViewSignal {
	inited;
	opening;
	opened;
	closing;
	closed;
	invalidated;
}

class AView extends Sprite implements IView implements IAbstractClass {
	
	//=========================================================================
	//	PARAMETERS
	//=========================================================================
	
	public var isInited(default, null):Bool;
	
	public var signals(default, null):Map<EnumValue, Signal1<Dynamic>>;
	public var changeSignal(default, null):Signal2<EnumValue, Dynamic>;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	
	private function new() {
		super();
		init();
	}
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	
	public function init() {
		signals = new Map();
		changeSignal = new Signal2<EnumValue, Dynamic>();
		
		signals.set(ViewSignal.inited, new Signal1<Void>());
		signals.set(ViewSignal.opening, new Signal1<Void>());
		signals.set(ViewSignal.opened, new Signal1<Void>());
		signals.set(ViewSignal.closing, new Signal1<Void>());
		signals.set(ViewSignal.closed, new Signal1<Void>());
		signals.set(ViewSignal.invalidated, new Signal1<Void>());
		
		isInited = true;
		
		dispatch(ViewSignal.inited);
	}
	
	public function destroy() {
		signals = DestroyUtils.destroy(signals);
		changeSignal = DestroyUtils.destroy(changeSignal);
		
		isInited = false;
	}
	
	public function show() visible = true;
	
	public function hide() {
		visible = false;
		dispatch(ViewSignal.closed);
	}
	
	public function invalidate() dispatch(ViewSignal.invalidated);
	
	public function dispatch(type:EnumValue, ?data:Dynamic) {
		#if debug
		if(Validate.isNull(type)) throw "type is null";
		if(!signals.exists(type)) throw "!signals.exists(type), type: " + type;
		#end
		
		signals.get(type).dispatch(data);
		changeSignal.dispatch(type, data);
	}
	
}