package gd.eggs.net.client;

import gd.eggs.net.client.INet;
import gd.eggs.utils.Validate;
import haxe.Json;
import haxe.Timer;
import haxe.io.Bytes;
import haxe.io.Eof;
import sys.net.Host;
import sys.net.Socket;

#if cpp
import cpp.vm.Thread;
#elseif neko
import neko.vm.Thread;
#end

/**
 * @author Dukobpa3
 */
class SocketConnectSys<T:IMessage> extends BaseConnector<T> implements IConnector<T> {
	
	//=========================================================================
	//	PARAMETERS
	//=========================================================================
	
	var _socket:Socket;
	var _connectConfig:ConnectConfig;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	
	public function new(cls:Class<T>) {
		#if debug
		if(Validate.isNull(cls)) throw "cls is null";
		#end
		
		super(cls);
	}
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	
	override public function init() {
		_socket = new Socket();
		super.init();
	}
	
	public function connect(config:ConnectConfig) {
		#if debug
		if(Validate.isNull(config)) throw "config is null";
		#end
		
		_connectConfig = config;
		
		try {
			_socket.connect(new Host(_connectConfig.server), _connectConfig.port);
			onSocketConnected();
			
			var sendThread:Thread = Thread.create(threadRead);
			sendThread.sendMessage(Thread.current());
		} catch (error:Dynamic) {
			onSocketError(error);
		}
	}
	
	public function close() {
		isOnline = false;
		_socket.close();
		signalClosed.dispatch( { message:"socket closed", config:_connectConfig } );
	}
	
	public function send(message:T) {
		try {
			var bytes:Bytes = message.pack();
			_socket.output.writeBytes(bytes, 0, bytes.length);
			
			log({sended:message});
		} catch (error:Dynamic) {
			onSocketError(error);
		}
	}
	
	//=========================================================================
	//	PRIVATE
	//=========================================================================
	
	function threadRead() {
		// wait for mainThreadLink from outside
		var mainThread:Thread = Thread.readMessage(true);
		
		// now go to working
		while (isOnline) {
			try {
				var sockArray:Array<Socket> = [_socket];
				var result = Socket.select(sockArray, null, null);
				for (s in result.read) {
					//log(s);
					//var data:Bytes = Bytes.alloc(1);
					//s.input.readBytes(data, 0, 1);
					//log({received:message});
					//mainThread.sendMessage(onSocketData.bind(data));
				}
			} catch (error:Dynamic) {
				if (!Std.is(error, Eof)) {
					mainThread.sendMessage(onSocketError.bind(error));
				} else {
					mainThread.sendMessage(close);
				}
			}
		}
	}
	
	function log(data:Dynamic) {
		signalLog.dispatch( { message:Json.stringify(data), config:_connectConfig } );
	}
	
	//=========================================================================
	//	HANDLERS
	//=========================================================================
	
	function onSocketConnected() {
		isOnline = true;
		signalConnected.dispatch( { message:"Connected", config:_connectConfig } );
	}
	
	function onSocketData(message:T) {
		signalData.dispatch(message);
	}
	
	function onSocketError(event:Dynamic) {
		signalConectError.dispatch( { message:Json.stringify(event), config:_connectConfig } );
	}
	
}