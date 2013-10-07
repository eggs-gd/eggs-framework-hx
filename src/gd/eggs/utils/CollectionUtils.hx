package gd.eggs.utils;

/**
 * @author SlavaRa
 */
class CollectionUtils{

	public static inline function clearArray(a:Array<Dynamic>) {
		if(Validate.isNull(a)) {
			return;
		}
		for (it in a) {
			a.remove(it);
		}
	}
	
	public static inline function clearMap(m:Map<Dynamic, Dynamic>) {
		if(Validate.isNull(m)) {
			return;
		}
		for (it in m) {
			m.remove(it);
		}
	}
}