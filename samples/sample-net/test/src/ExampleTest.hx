package;

import flash.utils.ByteArray;
import gd.eggs.samples.net.SampleDecoder;
import haxe.Json;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

/**
* Auto generated ExampleTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class ExampleTest 
{
	private var timer:Timer;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function testExample():Void
	{
		
		var decoder:SampleDecoder = new SampleDecoder();
		
		decoder.signalReceivingHeader.add(onDecoderReceivingHeader);
		decoder.signalInProgress.add(onDecoderProgress);
		decoder.signalDone.add(onDecoderDone);
		
		var messageStr = '{"one":';
		var messageStr2 = '1}';
		
		var ba1:ByteArray = new ByteArray();
		ba1.writeInt(9);
		ba1.writeUTFBytes(messageStr);
		
		decoder.parse(ba1);
		
		var ba2:ByteArray = new ByteArray();
		ba2.writeUTFBytes(messageStr2);
		
		decoder.parse(ba2);
		
		Assert.isTrue(true);
	}
	
	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}
	
	function onDecoderReceivingHeader() 
	{
		trace('header');
	}
	
	function onDecoderProgress() 
	{
		trace('progress');
	}
	
	function onDecoderDone(data:Dynamic) 
	{
		trace('done');
		trace(Json.stringify(data));
	}
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}