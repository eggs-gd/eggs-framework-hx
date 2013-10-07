package gd.eggs.mvc.application;

import gd.eggs.utils.Validate;
import gd.eggs.mvc.model.IModel;

/**
 * @author Dukobpa3
 */
class ModelManager {
	
	static var _models(default, null):Map<EnumValue, IModel> = new Map();
	
	public static function addModel(modelName:EnumValue, model:IModel) {
		#if debug
		if(Validate.isNull(modelName)) throw "modelName is null";
		if(Validate.isNull(model)) throw "model is null";
		if(_models.exists(modelName)) throw "_models.exists(modelName), modelName: " + modelName;
		#end
		
		_models.set(modelName, model);
	}
	
	public static function getModel(modelName:EnumValue):IModel {
		#if debug
		if(Validate.isNull(modelName)) throw "modelName is null";
		if(!_models.exists(modelName)) throw "!_models.exists(modelName), modelName: " + modelName;
		#end
		
		return _models.get(modelName);
	}
}