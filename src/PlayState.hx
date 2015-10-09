package;

import chopengine.gen.Global;
import choprender.GlobalRender;
import chopengine.gen.State;
import choprender.loader.obj.ObjLoader;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.light.ConeLight;
import choprender.render3d.light.PointLight;
import choprender.render3d.light.SunLight;
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
		super.create();
		
		GlobalRender.cam.pos.y = -3.0;
		GlobalRender.cam.pos.z = 0.5;
		GlobalRender.cam.bgColor.x = 0.0;
		GlobalRender.cam.bgColor.y = 1.0;
		GlobalRender.cam.bgColor.z = 1.0;
		
		var m:Model = new Model();
		m.loadChop("assets/mesh/lowpoly.chopmesh");
		add(m);
		
		//var m2:Model = new Model();
		//m2.loadChop("assets/mesh/corgi.chopmesh");
		//m2.scale.x = 2.0;
		//m2.scale.y = 2.0;
		//m2.scale.z = 2.0;
		//m2.rot.z = 20.0;
		//m2.pos.z = 0.1;
		//m2.pos.x = 5.0;
		//add(m2);
		
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
		cone.pos.y = -4.0;
		cone.dir.x = -1.0;
		cone.dir.z = -0.5;
		cone.dir.y = 0.5;
		cone.energy = 0.5;
		cone.color.x = 1.0;
		cone.color.y = 0.0;
		cone.color.z = 0.0;
		cone.coneAngle = 40.0;
		lights.lights.push(cone);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		#if snow
		if (SnowApp._snow.input.keydown(Key.key_a))
			GlobalRender.cam.pos.x -= 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_d))
			GlobalRender.cam.pos.x += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_w))
			GlobalRender.cam.pos.y += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_s))
			GlobalRender.cam.pos.y -= 5.0 * Elapsed;
		
		if (SnowApp._snow.input.keydown(Key.space))
			GlobalRender.cam.pos.z += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.lctrl))
			GlobalRender.cam.pos.z -= 5.0 * Elapsed;
		#end
	}
}