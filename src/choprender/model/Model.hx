package choprender.model;

import chop.gen.Object;
import choprender.model.AnimController;
import choprender.model.Model;
import choprender.render3d.shader.ChopProgramMgr;
import chop.math.Vec3;
import choprender.loader.chop.ChopLoader;
import choprender.model.data.ModelData;

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
		anim.data = data;
	}
	
	static public function copy(D:Model, S:Model):Void
	{
		Object.copy(D, S);
		D.anim.copy(S.anim);
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