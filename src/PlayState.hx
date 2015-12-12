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
	private var ground:QuadModel;
	
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
		var displace:Vec4 = Vec4.fromValues(0, 0, -1, 0);
		displace.transMat4(Util.eulerDegToMatrix4x4(
			0, 0, -25
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
		
		ground = new QuadModel();
		ground.setSize(64, 64);
		ground.pos.z = -32;
		ground.pos.x = -32;
		ground.rot.x = -90;
		add(ground);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		if (SnowApp._snow.input.keydown(Key.key_a))
			GlobalRender.cam.pos.x -= 1.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_d))
			GlobalRender.cam.pos.x += 1.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_w))
			GlobalRender.cam.pos.z -= 1.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_s))
			GlobalRender.cam.pos.z += 1.0 * Elapsed;
		
		if (SnowApp._snow.input.keydown(Key.space))
			GlobalRender.cam.pos.y += 1.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.lctrl))
			GlobalRender.cam.pos.y -= 1.0 * Elapsed;
		
		if (Main.game.mouse.rightPressed)
			GlobalRender.cam.rot.y -= Main.game.mouse.xRel / 2.0;
	}
}