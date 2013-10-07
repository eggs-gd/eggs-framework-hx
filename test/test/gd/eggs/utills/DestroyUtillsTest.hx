package test.gd.eggs.utills;

import massive.munit.Assert;

import msignal.Signal;

import gd.eggs.utils.DestroyUtils;

/**
 * ...
 * @author Dukobpa3
 */
class DestroyUtillsTest 
{
	
	@Test
	public function testExample():Void 
	{
		var signal:Signal1<Bool> = new Signal1<Bool>();
		signal.add(handler);
		signal.dispatch(true);
		
		DestroyUtils.destroy(signal);
		
		signal.dispatch(true);
	}
	
	function handler(val:Bool):Void { trace(val); }
	
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
	
}