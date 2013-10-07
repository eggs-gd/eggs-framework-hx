package test.gd.eggs.mvc.model;

import gd.eggs.mvc.model.AJsonModel;
import haxe.Json;
import massive.munit.Assert;

/**
 * ...
 * @author Dukobpa3
 */

class TestChildModel extends AJsonModel {
	public var array:Array<Int>;
	public var string:String;
	public var bool:Bool;
	
	public function new() {
		super();
		init();
	}
	
	override public function init() {
		isInited = true;
	}
	
	override public function destroy() {
		isInited = false;
	}
}
 
class TestParentModel extends AJsonModel {
	public var array:Array<Int>;
	public var string:String;
	public var bool:Bool;
	public var child:TestChildModel;
	
	public function new () {
		super();
		init();
	}
	
	override public function init() {
		child = new TestChildModel();
		isInited = true;
	}
	
	override public function destroy() {
		isInited = false;
	}
}


 
class AJsonModelTest 
{
	
	@Test
	public function jsonObjectParseTest():Void 
	{
		var data:String='{"array":[0,1],"string":"test"}';
		var res:{array:Array<Int>,string:String} = haxe.Json.parse(data);
		
		Assert.areEqual(0, res.array[0]);
		Assert.areEqual("test", res.string);
	}
	
	@Test
	public function fillNoChildClearTest() {
		var data = { array:[1, 2], string:"test", bool:true };
		var model = new TestChildModel();
		
		model.fillData(data);
		Assert.areEqual(1, model.array[0]);
		Assert.areEqual("test", model.string);
		Assert.areEqual(true, model.bool);
	}
	
	@Test
	public function fillNoChildOverkeysTest() {
		var data = { array:[1, 2], string:"test", some:10.2 };
		var model = new TestChildModel();
		
		model.fillData(data);
		Assert.areEqual(2, model.array[1]);
		Assert.areEqual("test", model.string);
	}
	
	@Test
	public function fillParentChildOverkeysTest() {
		var data = { 
			array:[1, 2], 
			string:"test",
			bool:true,
			some:10.2, 
			child: {
				array:[3, 4], 
				string:"testChild",
				bool:false
			}
		};
		
		var model = new TestParentModel();
		
		model.fillData(data);
		Assert.areEqual(2, model.array[1]);
		Assert.areEqual("test", model.string);
		Assert.areEqual(true, model.bool);
		Assert.isTrue(Std.is(model.child, TestChildModel));
		
		Assert.areEqual("testChild", model.child.string);
		Assert.areEqual(false, model.child.bool);
	}
	
	@Test
	public function fillParentChildOverkeysFromStringTest() {
		var data = '{ "array":[1, 2], "string":"test", "some":10.2, "child": { "array":[3, 4], "string":"testChild"}}';
		
		var model = new TestParentModel();
		
		model.fillData(data);
		Assert.areEqual(2, model.array[1]);
		Assert.areEqual("test", model.string);
		Assert.isTrue(Std.is(model.child, TestChildModel));
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
	
}