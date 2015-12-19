package;

import chop.math.Quat;
import chop.math.Util;
import chop.math.Vec4;
import chop.util.Color;
import chopengine.input.Mouse;
import choprender.GlobalRender;
import chopengine.gen.State;
import choprender.model.loader.obj.ObjLoader;
import choprender.model.Model;
import choprender.model.QuadModel;
import choprender.render3d.Camera;
import choprender.render3d.cubemap.Cubemap;
import choprender.render3d.light.ConeLight;
import choprender.render3d.light.PointLight;
import choprender.render3d.light.SunLight;
import choprender.render3d.shader.ForwardProgramMgr;
import choprender.text.loader.FontBuilderNGL;
import choprender.text.Text;
import jiglib.math.Vector3D;
import jiglib.physics.RigidBody;
import mint.focus.Focus;
import mint.layout.margins.Margins;
import snow.types.Types.Key;

import mint.*;

/**
 * ...
 * @author Ohmnivore
 */
class PlayState extends State
{
	private var groundRB:RigidBody;
	private var boxRB1:RigidBody;
	private var boxRB2:RigidBody;
	
	override public function create():Void 
	{
		super.create();
		
		GlobalRender.cam.pos.z = 3.0;
		GlobalRender.cam.pos.y = 0.5;
		GlobalRender.cam.bgColor.x = 0.0;
		GlobalRender.cam.bgColor.y = 1.0;
		GlobalRender.cam.bgColor.z = 1.0;
		
		layout = new Margins();
		canvas = new mint.Canvas({
			name:'canvas',
			rendering: Main.rendering,
			options: {
				group: this,
				cams: [],
				font: null
			},
			x: 0, y:0, w: SnowApp._snow.window.width, h: SnowApp._snow.window.height
		});
		focus = new Focus(canvas);
		
		var dMgr:ForwardProgramMgr = cast GlobalRender.cam.mgr;
		dMgr.skyBoxLegacyProgram.loadSkyBoxFile("assets/img/cubemap_4k.png");
		
		// simple sun light
		var displace:Vec4 = Vec4.fromValues(0, 0, 1, 1);
		displace.transMat4(Util.eulerDegToMatrix4x4(
			25, 25, 25
		));
		var sun:SunLight = new SunLight();
		sun.dir.x = displace.x;
		sun.dir.y = displace.y;
		sun.dir.z = displace.z;
		sun.dir = sun.dir.norm();
		sun.energy = 0.02;
		sun.color.x = 0.7;
		sun.color.y = 0.5;
		sun.color.z = 0.3;
		sun.useSpecular = false;
		lights.lights.push(sun);
		
		var ground:QuadModel = new QuadModel();
		ground.setSize(24, 24);
		ground.pos.z = -12;
		ground.pos.x = -12;
		ground.rot.x = -90;
		add(ground);
		groundRB = phys.createGround(ground);
		
		var box1:Model = new Model();
		var objLoader:ObjLoader = new ObjLoader();
		objLoader.loadFile("assets/obj/cube.obj", "assets/obj/cube.mtl");
		box1.loadData(objLoader.data);
		//box1.loadChop("assets/mesh/cube.chopmesh");
		box1.data.materials[0].diffuseColor.set(0.7, 0.7, 0.3);
		box1.pos.z = -4;
		box1.pos.y = 2;
		add(box1);
		boxRB1 = phys.createCube(box1, 2);
		
		var box2:Model = new Model();
		var objLoader:ObjLoader = new ObjLoader();
		objLoader.loadFile("assets/obj/cube.obj", "assets/obj/cube.mtl");
		box2.loadData(objLoader.data);
		//box2.loadChop("assets/mesh/cube.chopmesh");
		box2.data.materials[0].diffuseColor.set(0.3, 0.7, 0.7);
		box2.pos.z = -4;
		box2.pos.y = 2;
		box2.pos.x = 5;
		add(box2);
		boxRB2 = phys.createCube(box2, 2);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		if (SnowApp._snow.input.keydown(Key.key_a))
			GlobalRender.cam.pos.x -= 2.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_d))
			GlobalRender.cam.pos.x += 2.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_w))
			GlobalRender.cam.pos.z -= 2.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_s))
			GlobalRender.cam.pos.z += 2.0 * Elapsed;
		
		if (SnowApp._snow.input.keydown(Key.space))
			GlobalRender.cam.pos.y += 2.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.lctrl))
			GlobalRender.cam.pos.y -= 2.0 * Elapsed;
		
		if (Main.game.mouse.rightPressed)
			GlobalRender.cam.rot.y -= Main.game.mouse.xRel / 2.0;
		
		if (SnowApp._snow.input.keydown(Key.left))
			boxRB2.addWorldForce(new Vector3D(-25, 0, 0), boxRB2.currentState.position);
		if (SnowApp._snow.input.keydown(Key.right))
			boxRB1.addWorldForce(new Vector3D(25, 0, 0), boxRB1.currentState.position);
		//if (SnowApp._snow.input.keydown(Key.up))
			//GlobalRender.cam.pos.z -= 1.0 * Elapsed;
		//if (SnowApp._snow.input.keydown(Key.down))
			//GlobalRender.cam.pos.z += 1.0 * Elapsed;
	}
}