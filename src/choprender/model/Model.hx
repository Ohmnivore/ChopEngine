package choprender.model;

import chop.gen.Object;
import glm.Vec4;
import choprender.model.AnimController;
import choprender.model.Model;
import choprender.render3d.opengl.ChopProgramMgr;
import glm.Vec3;
import choprender.model.loader.chop.ChopLoader;
import choprender.model.data.ModelData;
import choprender.render3d.Camera;

/**
 * ...
 * @author Ohmnivore
 */
class Model extends Object
{
	public var data:ModelData;
	public var anim:AnimController;
	public var cams:Array<Camera>;
	public var clip:Vec4;
	
	public function new() 
	{
		super();
		
		data = new ModelData();
		anim = new AnimController();
		anim.data = data;
		cams = [GlobalRender.cam];
		clip = null;
	}
	
	static public function copy(D:Model, S:Model):Void
	{
		Object.copy(D, S);
		D.anim.copy(S.anim);
		for (c in S.cams)
			D.cams.push(c);
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