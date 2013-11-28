package gd.eggs.samples.net;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import flash.utils.Timer;
import gd.eggs.net.client.IConnection.ConnectConfig;
import gd.eggs.net.client.IConnection.ConnectionType;
import gd.eggs.net.client.IConnection.ConnectorEvent;
import gd.eggs.net.client.ServerProxy;
import gd.eggs.samples.net.SampleDecoder;
import haxe.Json;


/**
 * @author Dukobpa3
 */

class Main extends Sprite  {
	
	var _serverProxy(default, null):ServerProxy;
	
	public static function main() {
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	var _initialized:Bool;
	
	function onAddedToStage(_) {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		stage.addEventListener(Event.RESIZE, onStageResize);
		#if ios
		haxe.Timer.delay(initialize, 100); // iOS 6
		#else
		initialize();
		#end
	}
	
	function onStageResize(_) {
		if (!_initialized) {
			initialize();
		} else {
			
		}
	}
	
	function initialize() {
		if (_initialized) {
			return;
		}
		
		trace('start our app');
		
		var decoder = new SampleDecoder();
		
		_serverProxy = new ServerProxy(decoder);
		
		_serverProxy.signalConnected.add(onServerConnect);
		_serverProxy.signalDisconnected.add(onServerDisonnect);
		_serverProxy.signalError.add(onServerError);
		_serverProxy.signalLog.add(onServerLog);
		_serverProxy.signalData.add(onServerData);
		
		var connection:ConnectConfig = {
			type:ConnectionType.socket,
			server:'eggs.gd',
			port:9342 
		}
		
		_serverProxy.connect(connection);
		
		_initialized = true;
	}
	
	function onServerConnect(event:ConnectorEvent) {
		trace("-- server connected: " + event.message);
		var command:UserAuth;
		command = { command:'user.auth', uid:'uid0' };
		trace(">> message: " + Json.stringify(command));
		_serverProxy.sendMessage(command);
	}
	
	function onServerDisonnect(event:ConnectorEvent) {
		trace("-- server disconnected: " + event.message);
	}
	
	function onServerError(event:ConnectorEvent) {
		trace("-- server error: " + event.message);
	}
	
	function onServerLog(event:ConnectorEvent) {
		trace("-- server log: " + event.message);
	}
	
	function onServerData(msg:Dynamic):Void {
		trace("<< message: " + Json.stringify(msg));
	}
}