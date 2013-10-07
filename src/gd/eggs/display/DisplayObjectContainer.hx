package gd.eggs.display;
#if (!flash11 || !starling)
import flash.display.DisplayObjectContainer;
typedef DisplayObjectContainer = flash.display.DisplayObjectContainer;
#elseif (starling)
import starling.display.DisplayObjectContainer;
typedef DisplayObjectContainer = starling.display.DisplayObjectContainer;
#end