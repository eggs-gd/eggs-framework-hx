package gd.eggs.display;
#if (!flash11 || !starling)
import flash.display.MovieClip;
typedef MovieClip = flash.display.MovieClip;
#elseif (starling)
import starling.display.MovieClip;
typedef MovieClip = starling.display.MovieClip;
#end
