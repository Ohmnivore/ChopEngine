package chop.model;
import chop.gen.Global;
import chop.gen.Object;
import haxe.io.ArrayBufferView.ArrayBufferViewData;
import haxe.io.Bytes;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Quaternion;
import hxmath.math.Vector3;
import chop.loader.chop.ChopLoader;
import chop.math.Util;
import chop.model.data.Face;
import chop.model.data.ModelData;
import chop.model.data.Vertex;
import chop.render3d.GLUtil;
import chop.render3d.light.ConeLight;
import chop.render3d.light.Light;
import chop.render3d.light.PointLight;
import chop.render3d.light.SunLight;

/**
 * ...
 * @author Ohmnivore
 */
class Model extends Object
{
	public var data:ModelData;
	public var anim:AnimController;
	
	public function new() 
	{
		super();
		
		data = new ModelData();
		anim = new AnimController();
	}
	
	public function loadChop(P:String):Void
	{
		var loader:ChopLoader = new ChopLoader();
		loader.loadFile(P);
		loadData(loader.data);
	}
	
	public function loadData(D:ModelData):Void
	{
		data = D;
		anim.data = data;
		var total:Int = 0;
		var lastName:String = "";
		for (i in data.anims.keys())
		{
			total++;
			lastName = i;
		}
		if (total == 1)
			anim.play(lastName, true);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		anim.update(Elapsed);
	}
}