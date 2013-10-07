package gd.eggs.mvc.application;

import gd.eggs.display.DisplayObjectContainer;
import gd.eggs.mvc.view.AView;
import gd.eggs.utils.Validate;

/**
 * @author Dukobpa3
 */
class ViewManager {
	
	static var _scopes(default, null):Map<EnumValue, DisplayObjectContainer> = new Map();
	static var _views(default, null):Map<EnumValue, AView> = new Map();
	
	public static function addScope(scope:EnumValue, container:DisplayObjectContainer) {
		#if debug
		if(Validate.isNull(scope)) throw "scope is null";
		if(Validate.isNull(container)) throw "container is null";
		if(_scopes.exists(scope)) throw "_scopes.exists(scope), scope: " + scope;
		#end
		
		_scopes.set(scope, container);
	}
	
	public static function addView(scope:EnumValue, viewName:EnumValue, view:AView) {
		#if debug
		if(Validate.isNull(scope)) throw "scope is null";
		if(Validate.isNull(viewName)) throw "viewName is null";
		if(Validate.isNull(view)) throw "view is null";
		if(_views.exists(viewName)) throw "_views.exists(viewName), viewName: " + viewName;
		if(!_scopes.exists(scope)) throw "!_scopes.exists(scope), scope: " + scope;
		#end
		
		_views.set(viewName, view);
		_scopes.get(scope).addChild(view);
		view.hide();
	}
	
	public static function getView(viewName:EnumValue):AView {
		#if debug
		if(Validate.isNull(viewName)) throw "viewName is null";
		if(!_views.exists(viewName)) throw "!_views.exists(viewName), viewName: " + viewName;
		#end
		
		return _views.get(viewName);
	}
	
	public static function show(viewName:EnumValue) {
		#if debug
		if(Validate.isNull(viewName)) throw "viewName is null";
		if(!_views.exists(viewName)) throw "!_views.exists(viewName), viewName: " + viewName;
		#end
		
		_views.get(viewName).show();
	}
	
	public static function hide(viewName:EnumValue)	{
		#if debug
		if(Validate.isNull(viewName)) throw "viewName is null";
		if(!_views.exists(viewName)) throw "!_views.exists(viewName), viewName: " + viewName;
		#end
		
		_views.get(viewName).hide();
	}
	
	public static function hideAll() for(it in _views) it.hide();
	
}