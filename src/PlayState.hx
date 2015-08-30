package;

import chop.gen.Global;
import chop.gen.State;
import chop.loader.obj.ObjLoader;
import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.light.ConeLight;
import chop.render3d.light.PointLight;
import chop.render3d.light.SunLight;
import chop.phys.PhysUtil;
import jiglib.physics.RigidBody;
import chop.render3d.shader.ChopProgramMgr;
#if snow
import snow.types.Types.Key;
#end

/**
 * ...
 * @author Ohmnivore
 */
class PlayState extends State
{
	override public function create():Void 
	{
		ChopProgramMgr;
		super.create();
		
		Global.cam.pos.y = -3.0;
		Global.cam.pos.z = 0.5;
		Global.cam.bgColor.x = 0.0;
		Global.cam.bgColor.y = 1.0;
		Global.cam.bgColor.z = 1.0;
		//Global.cam.rot.z = 45.0;
		//Global.cam.rot.y = 45.0;
		//Global.cam.setView(0, 0, 640, 240);
		
		//var cam2:Camera = new Camera();
		//cam2.pos.y = -3.0;
		//cam2.pos.z = 0.5;
		//cam2.bgColor.x = 1.0;
		//cam2.bgColor.y = 0.0;
		//cam2.bgColor.z = 1.0;
		//cam2.setView(0, 240, 640, 240);
		//Global.cams.push(cam2);
		
		var m:Model = new Model();
		var objLoader:ObjLoader = new ObjLoader();
		//objLoader.loadFile("assets/lowpoly.obj");
		//m.loadData(objLoader.data);
		m.loadChop("assets/mesh/lowpoly.chopmesh");
		//m.scale.z = 2.0;
		//m.pos.x = -14.0;
		//m.rot.z = 45.0;
		//m.loadChop("assets/mesh/corgi.chopmesh");
		add(m);
		
		var m2:Model = new Model();
		m2.loadChop("assets/mesh/corgi.chopmesh");
		m2.scale.x = 2.0;
		m2.scale.y = 2.0;
		m2.scale.z = 2.0;
		m2.rot.z = 20.0;
		m2.pos.z = 0.1;
		m2.pos.x = 5.0;
		add(m2);
		
		//var terrain:RigidBody = PhysUtil.meshToMesh(new PhysMesh(m));
		//phys.addBody(terrain);
		//var corgi:RigidBody = PhysUtil.meshToCube(new PhysMesh(m2), 1.0, 1.0, 1.0);
		//corgi.y = 12.0;
		//phys.addBody(corgi);
		
		// simple sun
		var sun:SunLight = new SunLight();
		sun.dir.x = -1.0;
		sun.dir.y = 0.5;
		sun.dir.z = -0.5;
		sun.energy = 0.02;
		sun.color.x = 1.0;
		sun.color.y = 0.433;
		sun.color.z = 0.007;
		lights.lights.push(sun);
		
		// simple point light
		var point:PointLight = new PointLight();
		point.pos.x = -12.0;
		point.pos.z = 6.0;
		point.energy = 1.5;
		point.color.x = 0.0;
		point.color.y = 0.0;
		point.color.z = 1.0;
		point.distance = 15.0;
		lights.lights.push(point);
		
		// simple cone light
		var cone:ConeLight = new ConeLight();
		cone.pos.x = 2.0;
		cone.pos.z = 6.0;
		cone.pos.y = -2.0;
		cone.dir.x = -1.0;
		cone.dir.z = -0.5;
		cone.dir.y = 0.5;
		cone.energy = 0.5;
		cone.color.x = 1.0;
		cone.color.y = 0.0;
		cone.color.z = 0.0;
		lights.lights.push(cone);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		#if snow
		if (SnowApp._snow.input.keydown(Key.key_a))
			Global.cam.pos.x -= 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_d))
			Global.cam.pos.x += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_w))
			Global.cam.pos.y += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_s))
			Global.cam.pos.y -= 5.0 * Elapsed;
		
		if (SnowApp._snow.input.keydown(Key.space))
			Global.cam.pos.z += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.lctrl))
			Global.cam.pos.z -= 5.0 * Elapsed;
		#end
	}
}