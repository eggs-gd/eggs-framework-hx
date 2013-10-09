package gd.eggs.mvc.model;

import gd.eggs.utils.IAbstractClass;
import haxe.ds.StringMap;
import haxe.Json;
import haxe.rtti.Meta;

/**
 * ...
 * @author Dukobpa3
 */
class AJsonModel implements IModel implements IAbstractClass
{
	//=========================================================================
	//	PARAMETERS
	//=========================================================================
	
	public var _id_(default, null):String;
	
	public var isInited(default, null):Bool;
	
	var _meta(default, null):Dynamic;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	private function new() { 
		_meta = Meta.getFields(Type.getClass(this));
	}
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	/* INTERFACE gd.eggs.mvc.model.IModel */
	
	public function init() {};
	public function destroy() {};
	
	public function fillData(data:Dynamic, ?id:String) {
		
		// установить уид
		if (id != null) this._id_ = id;
		
		// Распарсить объект если тут строка
		var object;
		if (Std.is(data, String)) {
			object = Json.parse(data);
		} else {
			object = data;
		}
		
		// начинаем проход по полям объекта
		for (field in Reflect.fields(object)) {
			
			if (Reflect.hasField(this, field)) { // Если у нас есть такое поле
				
				var fieldRef = Reflect.field(this, field); // Сохраняем ссылку на поле в переменную
				var fieldData = Reflect.field(object, field); // Сохраняем данные поля в переменную
				var fieldMeta = Reflect.field(_meta, field);
				
				var fieldTypesArr:Array<Dynamic> = null;
				var fieldType = null;
				var collectionItem = null;
				
				if (fieldMeta != null) fieldTypesArr = Reflect.field(fieldMeta, "collectionType");
				if (fieldTypesArr != null && fieldTypesArr.length > 0) fieldType = Type.resolveClass(fieldTypesArr[0]);
				
				if (Std.is(fieldRef, AJsonModel)) { // Если поле - это одчерняя модель
					Reflect.callMethod(fieldRef, Reflect.field(fieldRef, "fillData"), [fieldData]);
				} else if (Std.is(fieldRef, StringMap)) { // Если это словарь
					var map:StringMap<Dynamic> = cast fieldRef;
					
					for (field2 in Reflect.fields(fieldData)) { // Проходим по всем детям мапы
						if (fieldType != null) collectionItem = Type.createInstance(fieldType, []);
						
						if (collectionItem != null && Std.is(collectionItem, AJsonModel)) { // если тип - наследник жсон-модели то пройтись по детям
							Reflect.callMethod(collectionItem, Reflect.field(collectionItem, "fillData"), [Reflect.field(fieldData, field2), field2]);
							map.set(field2, collectionItem);
							collectionItem = null;
						} else { // Иначе - заполняем по дефолту
							map.set(field2, Reflect.field(fieldData, field2));
						}
					}
				} else if (Std.is(fieldRef, Array)) {
					var array:Array<Dynamic> = cast fieldRef;
					
					for (field2 in Reflect.fields(fieldData)) { // Проходим по всем детям массива
						if (fieldType != null) collectionItem = Type.createInstance(fieldType, []);
						
						if (collectionItem != null && Std.is(collectionItem, AJsonModel)) { // если тип - наследник жсон-модели то пройтись по детям
							Reflect.callMethod(collectionItem, Reflect.field(collectionItem, "fillData"), [Reflect.field(fieldData, field2), field2]);
							array.insert(cast field2, collectionItem);
							collectionItem = null;
						} else { // Иначе - заполняем по дефолту
							array.insert(cast field2, Reflect.field(fieldData, field2));
						}
					}
				} else { // Иначе тупо устанавливаем
					Reflect.setField(this, field, fieldData);
				}
			}
		}
	}
	
}