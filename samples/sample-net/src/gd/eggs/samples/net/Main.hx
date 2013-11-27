package gd.eggs.samples.net;
import flash.display.Sprite;
import flash.events.Event;
import flash.Lib;
import gd.eggs.net.client.IConnection.ConnectConfig;
import gd.eggs.net.client.IConnection.ConnectionType;
import gd.eggs.net.client.IConnection.ConnectorEvent;
import gd.eggs.net.client.ServerProxy;
import gd.eggs.samples.net.SampleDecoder.ServerData;
import haxe.Json;


/**
 * @author Dukobpa3
 */

 
typedef BaseCommand = { command:String };
typedef UserAuth = { > BaseCommand, uid:String };
 
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
		
		_serverProxy = new ServerProxy(new SampleDecoder());
		
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
		var command:UserAuth = { command:'user.auth', uid:'uid312121212' };
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
	
	function onServerData(msg:ServerData):Void {
		trace("<< message: " + Json.stringify(msg));
	}
}