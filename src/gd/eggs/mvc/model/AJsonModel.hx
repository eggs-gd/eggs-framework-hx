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
	
	public var isInited(default, null):Bool;
	
	var _uid(default, null):String;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	private function new() { }
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	/* INTERFACE gd.eggs.mvc.model.IModel */
	
	public function init() {};
	public function destroy() {};
	
	public function fillData(data:Dynamic, ?uid:String) {
		
		// установить уид
		if (uid != null) _uid = uid;
		
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
				
				if (Std.is(fieldRef, AJsonModel)) { // Если поле - это одчерняя модель
					Reflect.callMethod(fieldRef, Reflect.field(fieldRef, "fillData"), [fieldData]);
				} else if (Std.is(fieldRef, StringMap)) { // Если это словарь
					var map:StringMap<Dynamic> = cast fieldRef;
					// получить тип
					var meta = Meta.getFields(Type.getClass(this));
					var fieldMeta = Reflect.field(meta, field);
					var typeArr:Array<Dynamic> = null;
					var type = null;
					var mapChild = null;
					if (fieldMeta != null) typeArr = Reflect.field(fieldMeta, "collectionType");
					if (typeArr != null && typeArr.length > 0) type = Type.resolveClass(typeArr[0]);
					
					for (field2 in Reflect.fields(fieldData)) { // Проходим по всем детям мапы
						if (type != null) mapChild = Type.createInstance(type, []);
						
						if (mapChild != null && Std.is(mapChild, AJsonModel)) { // если тип - наследник жсон-модели то пройтись по детям
							Reflect.callMethod(mapChild, Reflect.field(mapChild, "fillData"), [Reflect.field(fieldData, field2)]);
							map.set(field2, mapChild);
							mapChild = null;
						} else { // Иначе - заполняем по дефолту
							map.set(field2, Reflect.field(fieldData, field2));
						}
					}
				// TODO проверка типа массива
				} else if (Std.is(fieldRef, Array)) {
					var array:Array<Dynamic> = cast fieldRef;
					// получить тип
					var meta = Meta.getFields(Type.getClass(this));
					var fieldMeta = Reflect.field(meta, field);
					var typeArr:Array<Dynamic> = null;
					var type = null;
					var arrayChild = null;
					if (fieldMeta != null) typeArr = Reflect.field(fieldMeta, "collectionType");
					if (typeArr != null && typeArr.length > 0) type = Type.resolveClass(typeArr[0]);
					
					for (field2 in Reflect.fields(fieldData)) { // Проходим по всем детям мапы
						if (type != null) arrayChild = Type.createInstance(type, []);
						
						if (arrayChild != null && Std.is(arrayChild, AJsonModel)) { // если тип - наследник жсон-модели то пройтись по детям
							Reflect.callMethod(arrayChild, Reflect.field(arrayChild, "fillData"), [Reflect.field(fieldData, field2)]);
							array.insert(cast field2, arrayChild);
							arrayChild = null;
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