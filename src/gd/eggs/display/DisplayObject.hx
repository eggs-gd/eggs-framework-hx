package gd.eggs.display;
#if (!flash11 || !starling)
import flash.display.DisplayObject;
typedef DisplayObject = flash.display.DisplayObject;
#elseif (starling)
import starling.display.DisplayObject;
typedef DisplayObject = starling.display.DisplayObject;
#end