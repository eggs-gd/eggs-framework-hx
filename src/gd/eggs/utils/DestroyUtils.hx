package gd.eggs.utils;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.utils.ByteArray;
import gd.eggs.display.DisplayObject;
import gd.eggs.display.DisplayObjectContainer;
import gd.eggs.display.MovieClip;

#if msignal
import msignal.Signal;
#end

/**
 * @author SlavaRa
 */
class DestroyUtils{

	/**
	 * @param d => IInitialize, Signal, Итерируемая коллекция, ByteArray, BitmapData, DisplayObject
	 * @return null
	 */
	public static function destroy(d:Dynamic):Dynamic {
		if(Std.is(d, IInitialize)) {
			cast(d, IInitialize).destroy();
		}
		
		#if msignal
		if(Std.is(d, Signal)) {
			cast(d, Signal<Dynamic, Dynamic>).removeAll();
		}
		#end
		
		if(Reflect.hasField(d, "iterator")) {
			var itr = Reflect.callMethod(d, Reflect.field(d, "iterator"), []);
			if(Reflect.hasField(itr, "hasNext")) {
				while (Reflect.callMethod(itr, Reflect.field(itr, "hasNext"), [])) {
					destroy(Reflect.callMethod(itr, Reflect.field(itr, "next"), []));
				}
			}
		}
		
		if(Std.is(d, ByteArray)) {
			cast(d, ByteArray).clear();
		}
		
		if (Std.is(d, BitmapData)) {
			cast(d, BitmapData).dispose();
		}
		
		if(Std.is(d, DisplayObject)) {
			destroyDO(cast(d, DisplayObject));
		}
		
		return null;
	}
	
	static function destroyDO(d:DisplayObject) {
		if(d.stage != null) {
			return;//TODO: throw
		}
		
		if(Std.is(d, Loader)) {
			return;//TODO: дописать разрушение лодера
		}
		
		if(Std.is(d, DisplayObjectContainer)) {
			var container:DisplayObjectContainer = cast(d, DisplayObjectContainer);
			
			if(Std.is(container, MovieClip)) {
				cast(container, MovieClip).stop();
			}
			
			while (container.numChildren != 0) {
				destroyDO(container.removeChildAt(0));
			}
		}
		
		if(Std.is(d, Bitmap)) {
			var bitmap = cast(d, Bitmap);
			if(bitmap.bitmapData != null) {
				bitmap.bitmapData.dispose();
				bitmap.bitmapData = null;
			}
		}
		
		#if flash
		if(Std.is(d, flash.display.Shape)) {
			var s:flash.display.Shape = cast(d, flash.display.Shape);
			if(s.graphics != null) {
				s.graphics.clear();
			}
		}
		
		if(Std.is(d, flash.display.Sprite)) {
			var s:flash.display.Sprite = cast(d, flash.display.Sprite);
			if(s.graphics != null) {
				s.graphics.clear();
			}
			s.hitArea = null;
		}
		
		d.mask = null;
		#end
	}
}