package gd.eggs.net.client;

import gd.eggs.utils.IInitialize;
import msignal.Signal;

/**
 * @author Dukobpa3
 */
enum ConnectionType {
	socket;
	http;
	local;
}

typedef ConnectConfig = {
	type:EnumValue,
	server:String,
	port:Int,
	?id:String
}

typedef ConnectorEvent = {
	message:String,
	config:ConnectConfig
}

interface IMessage {
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	#if flash
	function parse(data:flash.utils.ByteArray):Bool;
	function pack():flash.utils.ByteArray;
	#elseif sys
	function parse(data:haxe.io.Bytes):Bool;
	function pack():haxe.io.Bytes;
	#end
}

interface IConnector<T:IMessage> extends IInitialize {
	
	//=========================================================================
	//	VARIABLES
	//=========================================================================
	
	var isOnline(default, null):Bool;
	
	var messageClass(default, null):Class<T>;
	
	var signalConectError(default, null):Signal1<ConnectorEvent>;
	var signalConnected(default, null):Signal1<ConnectorEvent>;
	var signalClosed(default, null):Signal1<ConnectorEvent>;
	var signalLog(default, null):Signal1<ConnectorEvent>;
	var signalData(default, null):Signal1<T>;
	
	//=========================================================================
	//	METHODS
	//=========================================================================
	
	function connect(config:ConnectConfig):Void;
	function send(data:T):Void;
	function close():Void;
}