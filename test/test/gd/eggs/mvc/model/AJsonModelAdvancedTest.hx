package test.gd.eggs.mvc.model;

import gd.eggs.mvc.model.AJsonModel;
import haxe.ds.HashMap;
import haxe.ds.StringMap;
import haxe.rtti.Meta;
import massive.munit.Assert;

/**
 * ...
 * @author Dukobpa3
 */
class TestChildModel2 extends AJsonModel {
	public var arrayInt:Array<Int>;
	public var arrayBool:Array<Bool>;
	public var arrayString:Array<String>;
	
	public var hashInt:StringMap<Int>;
	
	public function new () {
		super();
		init();
	}
	
	override public function init() {
		hashInt = new StringMap<Int>();
		isInited = true;
	}
	
	override public function destroy() {
		isInited = false;
	}
	
}
 
class TestParentModel2 extends AJsonModel {
	@collectionType("test.gd.eggs.mvc.model.TestChildModel2")
	public var hashChild:StringMap<TestChildModel2>;
	
	@collectionType("test.gd.eggs.mvc.model.TestChildModel2")
	public var arrayChild:Array<TestChildModel2>;
	
	public function new () {
		super();
		init();
	}
	
	override public function init() {
		hashChild = new StringMap<TestChildModel2>();
		arrayChild = [];
		isInited = true;
	}
	
	override public function destroy() {
		isInited = false;
	}
}
 
class AJsonModelAdvancedTest 
{
	
	@Test
	public function hashSimpleTest():Void 
	{
		var data = { arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} };
		var model = new TestChildModel2();
		
		model.fillData(data);
		
		Assert.areEqual(model.arrayInt[0] ,1);
		Assert.areEqual(2, model.hashInt.get("two"));
	}
	
	@Test
	public function hashTypeTest():Void {
		var model = new TestParentModel2();
		var meta = Meta.getFields(TestParentModel2);
		
		var cl = Type.resolveClass(meta.hashChild.collectionType[0]);
		Assert.areEqual(cl, TestChildModel2);
	}
	
	
	@Test
	public function hashTypedTest():Void 
	{
		var data = { 
			hashChild: { 
				one:{ arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} }, 
				two:{ arrayInt:[3, 4], hashInt:{four:4, five:5, six:6} } 
			} 
		};
		var model = new TestParentModel2();
		
		model.fillData(data);
		
		var child = model.hashChild.get("two");
		Assert.isNotNull(child);
		Assert.isTrue(Std.is(child, TestChildModel2));
		Assert.areEqual(child.hashInt.get("four"), 4);
	}
	
	@Test
	public function arrayTypedTest():Void 
	{
		var data = { 
			arrayChild: { 
				"0":{ arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} }, 
				"1":{ arrayInt:[3, 4], hashInt:{four:4, five:5, six:6} } 
			} 
		};
		
		var data2 = { 
			arrayChild: [ 
				{ arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} }, 
				{ arrayInt:[3, 4], hashInt:{one:1, two:2, three:3} } 
			]
		};
		var model = new TestParentModel2();
		
		model.fillData(data);
		
		var child = model.arrayChild[1];
		Assert.isNotNull(child);
		Assert.isTrue(Std.is(child, TestChildModel2));
		Assert.areEqual(child.hashInt.get("four"), 4);
		
		model.fillData(data2);
		
		var child = model.arrayChild[0];
		Assert.isNotNull(child);
		Assert.isTrue(Std.is(child, TestChildModel2));
		Assert.areEqual(child.hashInt.get("two"), 2);
	}
	
	@Test
	public function arrayTypedTestWithId():Void 
	{
		var data = { 
			arrayChild: { 
				"0":{ arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} }, 
				"1":{ arrayInt:[3, 4], hashInt:{four:4, five:5, six:6} } 
			} 
		};
		
		var data2 = { 
			arrayChild: [ 
				{ arrayInt:[1, 2], hashInt:{one:1, two:2, three:3} }, 
				{ arrayInt:[3, 4], hashInt:{one:1, two:2, three:3} } 
			]
		};
		var model = new TestParentModel2();
		
		model.fillData(data);
		
		var child = model.arrayChild[1];
		Assert.isNotNull(child);
		Assert.isTrue(Std.is(child, TestChildModel2));
		Assert.areEqual(child._id_, 1);
		
		
		model.fillData(data2);
		
		var child = model.arrayChild[0];
		Assert.isNotNull(child);
		Assert.isTrue(Std.is(child, TestChildModel2));
		Assert.areEqual(child._id_, 0);
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