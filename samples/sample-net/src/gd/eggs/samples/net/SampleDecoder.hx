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

typedef BaseCommand = { command:String };
typedef UserAuth = { > BaseCommand, uid:String };
 
class SampleDecoder implements IDecoder<BaseCommand>
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
	public var signalDone(default, null):Signal1<BaseCommand>;
	
	static var _buffer:String;
	var _size(default, null):Int;
	
	public function new() {
		
		_buffer = '';
		_size = SIZE_NONE;
		
		signalInvalidDataType = new Signal0();
		signalInvalidPackageSize = new Signal0();
		signalInProgress = new Signal0();
		signalReceivingHeader = new Signal0();
		signalDone = new Signal1<BaseCommand>();
	}
	
	/**
	 * Бронированная система для чтения чего попало как угодно.
	 * 1. Получает некий набор байтов. Пытается считать длину.
	 * 2. Если длина недополучена (хардкод 4 байте, интегер) ждет полного заголовка длины
	 * 3. Считывает длину. Дальше ждет полного месаджа, пока не получит.
	 * 4. Если на руках есть полные месадж, парсит его и диспатчит доне.
	 * 5. Так же может обрабатывать "смежные" пакеты. 
	 * 		Когда в одном пакете пришел конец предыдущего сообщения и начало следующего.
	 * 		Если видит что после чтения в буфере что-то осталось - рекурсивно пытается парсить это.
	 * @param	data
	 */
	public function parse(data:ByteArray):Void {
		
		#if debug
		if(Validate.isNull(data)) throw "data is null";
		#end
		
		data.position = 0;
		
		if (_size == SIZE_NONE) { // если размер не считали
			if (data.length < SIZE_HEADER) { // если в буфере не достаточно байтов для получения длины
				signalReceivingHeader.dispatch();
				return;
			} else {
				_size = data.readInt(); // если байтов для получения длины хватает - читаем ее
				data.position = SIZE_HEADER;
			}
		}
		
		var str:String;
		
		if ((data.length - data.position) < _size) {
			str = data.readUTFBytes(data.bytesAvailable);
			_buffer += str;
		} else {
			str = data.readUTFBytes(_size);
			_buffer += str;
		}
		
		if (_buffer.length < _size) {
			signalInProgress.dispatch(); // ждем еще данных
		} else {
			signalDone.dispatch(Json.parse(_buffer));
			_buffer = '';
			_size = SIZE_NONE;
		}
		
		if ((data.length - data.position) > 0) {
			var tmpBa:ByteArray = new ByteArray();
			tmpBa.writeBytes(data, data.position, data.bytesAvailable);
			data.clear();
			parse(tmpBa);
		}
		
	}
	
	public function pack(message:BaseCommand):ByteArray {
		
		#if debug
		if(Validate.isNull(message)) throw "message is null";
		#end
		
		var data:String = Json.stringify(message);
		
		var buffer:ByteArray = new ByteArray();
		var length:Int = data.length;
		buffer.writeInt(length);
		buffer.writeUTFBytes(data);
		
		return buffer;
	}
	
}