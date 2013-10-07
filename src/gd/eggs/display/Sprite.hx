package gd.eggs.display;
#if (!flash11 || !starling)
import flash.display.Sprite;
typedef Sprite = flash.display.Sprite;
#elseif (starling)
import starling.display.Sprite;
typedef Sprite = starling.display.Sprite;
#end