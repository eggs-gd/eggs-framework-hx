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

typedef ServerData = { game: { }};
 
class SampleDecoder implements IDecoder<ServerData>
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
		
		_buffer.position = _buffer.length; // передвигаем курсор в конец
		_buffer.writeBytes(data); // дописываем в буфер то что получили
		data.clear(); // очищаем то что получили
		_buffer.position = 0;
		
		if (_size == SIZE_NONE) { // если размер не считали
			if (_buffer.length < 4) { // если в буфере не достаточно байтов для получения длины
				signalReceivingHeader.dispatch();
				return;
			}
			_size = _buffer.readInt(); // если байтов для получения длины хватает - читаем ее
		} else {
			_buffer.position = 4;
		}
		
		if (_buffer.bytesAvailable < _size) { // если от курсора до конца меньше байт чем указано в длине
			signalInProgress.dispatch(); // ждем еще данных
			return;
		} else { // иначе читаем пакет
			// воспользуемся датой повтороно. Но она сейчас пустая, это просто временный буффер
			data.writeBytes(_buffer, _buffer.position, _size); // всунем хвост буффера в данные
			
			data.position = 0; // парсим данные
			var message:Dynamic = Json.parse(data.readUTFBytes(_size));
			signalDone.dispatch(message);
			
			_buffer.position += _size;
			_size = SIZE_NONE;
			data.clear(); // дальше обнуляем, воспользуемся повторно в качестве нового месаджа
			
			if (_buffer.bytesAvailable != 0) {
				data.writeBytes(_buffer, _buffer.position);  // всунем в данные хвост буффера
				data.position = 0;
				_buffer.clear(); // очистим буффер (в след цикле хвост в него допишется)
				parse(data);
			}
			_buffer.clear(); // очистим буффер (в след цикле хвост в него допишется)
		}	
		
	}
	
	public function pack(message:ServerData):ByteArray {
		
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