package gd.eggs.net.client;

import gd.eggs.net.client.INet;
import gd.eggs.utils.Validate;

/**
 * @author Dukobpa3
 */
class LocalConnect<T:IMessage> extends BaseConnector<T> implements IConnector<T> {
	
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
	
	public function connect(config:ConnectConfig) {
	}
	
	public function close() {
	}
	
	public function send(data:T) {
	}
	
}