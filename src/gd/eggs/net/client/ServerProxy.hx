package gd.eggs.net.client;

import gd.eggs.net.client.INet;
import gd.eggs.utils.DestroyUtils;
import gd.eggs.utils.IInitialize;
import gd.eggs.utils.Validate;
import msignal.Signal.Signal1;

#if flash
typedef SocketConnect<T:IMessage> = SocketConnectFlash<T>;
#else
typedef SocketConnect<T:IMessage> = SocketConnectSys<T>;
#end

/**
 * @author Dukobpa3
 */
class ServerProxy<T:IMessage> implements IInitialize {
	
	//=========================================================================
	//	CONSTANTS
	//=========================================================================
	
	var CONNECTOR_BY_TYPE:Map<EnumValue, IConnector<T>>;
	
	//=========================================================================
	//	PARAMETERS
	//=========================================================================
	
	public var isInited(default, null):Bool;
	
	public var signalConnected(default, null):Signal1<ConnectorEvent>;
	public var signalDisconnected(default, null):Signal1<ConnectorEvent>;
	public var signalError(default, null):Signal1<ConnectorEvent>;
	public var signalLog(default, null):Signal1<ConnectorEvent>;
	public var signalData(default, null):Signal1<T>;
	
	/**
	 * Список доступных вариантов для коннекта
	 */
	var _connections(default, null):Array<ConnectConfig>;
	var _currentConnection:ConnectConfig;
	
	var _connector(default, null):IConnector<T>;
	var _messageQueue(default, null):Array<T>;
	
	//=========================================================================
	//	CONSTRUCTOR
	//=========================================================================
	
	public function new(messageClass:Class<T>, connections:Array<ConnectConfig>) {
		#if debug
		if(Validate.isNull(messageClass)) throw "cls is null";
		if(Validate.isNull(connections)) throw "connections is null";
		#end
		
		CONNECTOR_BY_TYPE = [ 
			ConnectionType.http => new HttpConnect(messageClass), 
			ConnectionType.socket => new SocketConnect(messageClass), 
			ConnectionType.local => new LocalConnect(messageClass) 
		];
		
		_connections = connections;
		
		init();
	}
	
	//=========================================================================
	//	PUBLIC
	//=========================================================================
	
	public function init() {
		_messageQueue = [];
		
		signalConnected = new Signal1<ConnectorEvent>();
		signalDisconnected = new Signal1<ConnectorEvent>();
		signalError = new Signal1<ConnectorEvent>();
		signalLog = new Signal1<ConnectorEvent>();
		signalData = new Signal1<T>();
		
		isInited = true;
	}
	
	public function destroy() {
		_messageQueue = DestroyUtils.destroy(_messageQueue);
		
		signalConnected = DestroyUtils.destroy(signalConnected);
		signalDisconnected = DestroyUtils.destroy(signalDisconnected);
		signalError = DestroyUtils.destroy(signalError);
		signalLog = DestroyUtils.destroy(signalLog);
		signalData = DestroyUtils.destroy(signalData);
		
		isInited = false;
	}
	
	public function connect(connectionId:Int = 0) {
		_currentConnection = _connections[connectionId];
		
		if (Validate.isNotNull(_connector)) {
			DestroyUtils.destroy(_connector);
		}
		
		_connector = CONNECTOR_BY_TYPE[_currentConnection.type];
		
		_connector.init();
		
		_connector.signalConectError.add(onConnectorError);
		_connector.signalConnected.add(onConnectorConnected);
		_connector.signalClosed.add(onConnectorClosed);
		_connector.signalData.add(onConnectorData);
		_connector.signalLog.add(onConnectorLog);
		
		_connector.connect(_currentConnection);
	}
	
	public function sendMessage(message:T) {
		#if debug
		if(Validate.isNull(message)) throw "message is null";
		#end
		
		//TODO Вкрутить очередь сообщений и таймаут между отправкой
		_connector.send(message);
	}
	
	//=========================================================================
	//	HANDLERS
	//=========================================================================
	
	function onConnectorError(event:ConnectorEvent) {
		signalError.dispatch(event);
	}
	
	function onConnectorConnected(event:ConnectorEvent) {
		signalConnected.dispatch(event);
	}
	
	function onConnectorClosed(event:ConnectorEvent) {
		signalDisconnected.dispatch(event);
	}
	
	function onConnectorLog(event:ConnectorEvent) {
		signalLog.dispatch(event);
	}
	
	function onConnectorData(message:T) {
		signalData.dispatch(message);
	}
	
}