package gd.eggs.samples.net;

import flash.utils.ByteArray;
import gd.eggs.net.client.IDecoder;
import gd.eggs.utils.Validate;
import haxe.Json;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;

/**
 * ...
 * @author Dukobpa3
 */

typedef ServerData = { game: { } };
typedef BaseCommand = { command:String };

typedef UserAuth = { > BaseCommand, uid:String };


class SampleDecoder implements IDecoder<BaseCommand, ServerData>
{

	//=====================================================================
	//	CONSTANTS
	//=====================================================================
	static inline var SIZE_NONE:Int = -1;
	static inline var SIZE_HEADER:Int = 4;
	
	//=====================================================================
	//	PARAMETERS
	//=====================================================================
	public var signalInvalidDataType(default, null):Signal0;
	public var signalInvalidPackageSize(default, null):Signal0;
	public var signalInProgress(default, null):Signal0;
	public var signalReceivingHeader(default, null):Signal0;
	public var signalDone(default, null):Signal1<ServerData>;
	
	var _buffer(default, null):ByteArray;
	
	var _size(default, null):Int;
	
	public function new() {
		
		_buffer = new ByteArray();
		
		_size = SIZE_NONE;
		
		signalInvalidDataType = new Signal0();
		signalInvalidPackageSize = new Signal0();
		signalInProgress = new Signal0();
		signalReceivingHeader = new Signal0();
		signalDone = new Signal1<ServerData>();
	}
	
	public function parse(data:ByteArray):Void {
		
		#if debug
		if(Validate.isNull(data)) throw "data is null";
		#end
		
		data.position = 0;
		
		_buffer.position = _buffer.length;
		_buffer.writeBytes(data);
		
		if (_size == SIZE_NONE) {
			if (_buffer.length >= SIZE_HEADER) {
				_buffer.position = 0;
				_size = _buffer.readInt();
			} else {
				signalReceivingHeader.dispatch();
				return;
			}
		}
		
		_buffer.position = SIZE_HEADER;
		
		if (_buffer.bytesAvailable >= _size) {
			var result:String = _buffer.readUTFBytes(_size);
			signalDone.dispatch(Json.parse(result));
			
			var tempBa:ByteArray = new ByteArray();
			tempBa.writeBytes(_buffer, _size + SIZE_HEADER);
			
			_buffer.clear();
			_size = SIZE_NONE;
			
			if (tempBa.length > 0) parse(tempBa);
			
		} else {
			signalInProgress.dispatch();
		}
		
	}
	
	public function pack(command:BaseCommand):ByteArray {
		
		#if debug
		if(Validate.isNull(command)) throw "message is null";
		#end
		
		var data:String = Json.stringify(command);
		
		var buffer:ByteArray = new ByteArray();
		buffer.writeInt(data.length);
		buffer.writeUTFBytes(data);
		
		return buffer;
	}
	
}