package gd.eggs.utils;

/**
 * @author SlavaRa
 */
class Validate {
	public static inline function isNull(d:Null<Dynamic>):Bool {
		return d == null;
	}
	
	public static inline function isNotNull(d:Null<Dynamic>):Bool {
		return d != null;
	}
	
	//TODO Я бы сюда добавил и проверку коллекций, 
	//плюс не понимаю зачем по два зеркальных метода на каждую проверку.
	public static inline function stringIsNullOrEmpty(s:Null<String>):Bool {
		return (s == null) || (s.length == 0);
	}
	
	public static inline function stringIsNotEmpty(s:Null<String>):Bool {
		return (s != null) && (s.length > 0);
	}
	
}