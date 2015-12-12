//package;
//
//import chop.math.Quat;
//import chop.math.Util;
//import glm.Vec4;
//import chop.util.Color;
//import chopengine.input.Mouse;
//import choprender.GlobalRender;
//import chopengine.gen.State;
//import choprender.model.loader.obj.ObjLoader;
//import choprender.model.Model;
//import choprender.model.QuadModel;
//import choprender.render3d.Camera;
//import choprender.render3d.cubemap.Cubemap;
//import choprender.render3d.light.ConeLight;
//import choprender.render3d.light.PointLight;
//import choprender.render3d.light.SunLight;
//import choprender.render3d.shader.ForwardProgramMgr;
//import choprender.text.loader.FontBuilderNGL;
//import choprender.text.Text;
//import mint.focus.Focus;
//import mint.layout.margins.Margins;
//import snow.types.Types.Key;
//
//import mint.*;
//
///**
 //* ...
 //* @author Ohmnivore
 //*/
//class PlayState extends State
//{
	//override public function create():Void 
	//{
		//super.create();
		//
		//GlobalRender.cam.pos.z = 3.0;
		//GlobalRender.cam.pos.y = 0.5;
		//GlobalRender.cam.bgColor.x = 0.0;
		//GlobalRender.cam.bgColor.y = 1.0;
		//GlobalRender.cam.bgColor.z = 1.0;
		//
		//layout = new Margins();
		//canvas = new mint.Canvas({
			//name:'canvas',
			//rendering: Main.rendering,
			//options: {
				//group: this,
				//cams: [],
				//font: null
			//},
			//x: 0, y:0, w: SnowApp._snow.window.width, h: SnowApp._snow.window.height
		//});
		//focus = new Focus(canvas);
		//
		//var dMgr:ForwardProgramMgr = cast GlobalRender.cam.mgr;
		//dMgr.skyBoxLegacyProgram.loadSkyBoxFile("assets/img/cubemap_4k.png");
		//
		//// simple sun light
		//var displace:Vec4 = new Vec4(0, 0, -1, 0);
		//displace.transMat4(Util.eulerDegToMatrix4x4(
			//0, 0, -25
		//));
		//var sun:SunLight = new SunLight();
		//sun.dir.x = displace.x;
		//sun.dir.y = displace.y;
		//sun.dir.z = displace.z;
		//sun.dir = sun.dir.norm();
		//sun.energy = 0.02;
		//sun.color.x = 0.7;
		//sun.color.y = 0.5;
		//sun.color.z = 0.3;
		//sun.useSpecular = false;
		//lights.lights.push(sun);
		//
		//var ground:QuadModel = new QuadModel();
		////ground.setSize(2, 2);
		////ground.pos.z = -12.0;
		////ground.pos.x = -1.0;
		////ground.pos.y = 1.0;
		//ground.rot.z = -90;
		//add(ground);
	//}
	//
	//override public function update(Elapsed:Float):Void 
	//{
		//super.update(Elapsed);
		//
		//if (SnowApp._snow.input.keydown(Key.key_a))
			//GlobalRender.cam.pos.x -= 1.0 * Elapsed;
		//if (SnowApp._snow.input.keydown(Key.key_d))
			//GlobalRender.cam.pos.x += 1.0 * Elapsed;
		//if (SnowApp._snow.input.keydown(Key.key_w))
			//GlobalRender.cam.pos.z -= 1.0 * Elapsed;
		//if (SnowApp._snow.input.keydown(Key.key_s))
			//GlobalRender.cam.pos.z += 1.0 * Elapsed;
		//
		//if (SnowApp._snow.input.keydown(Key.space))
			//GlobalRender.cam.pos.y += 1.0 * Elapsed;
		//if (SnowApp._snow.input.keydown(Key.lctrl))
			//GlobalRender.cam.pos.y -= 1.0 * Elapsed;
		//
		//if (Main.game.mouse.rightPressed)
			//GlobalRender.cam.rot.y -= Main.game.mouse.xRel / 2.0;
	//}
//}

package;

import glm.GLM;
import glm.Quat;
import glm.Vec4;
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
	override public function create():Void 
	{
		super.create();
		
		GlobalRender.cam.pos.z = 3.0;
		GlobalRender.cam.pos.y = 0.5;
		GlobalRender.cam.bgColor.x = 0.0;
		GlobalRender.cam.bgColor.y = 1.0;
		GlobalRender.cam.bgColor.z = 1.0;
		
		var uiCam:Camera = new Camera(0, 0, GlobalRender.cam.width, GlobalRender.cam.height);
		uiCam.isOrtho = true;
		uiCam.pos.z = 199.0;
		uiCam.shouldClearColor = false;
		uiCam.shouldClearDepth = true;
		GlobalRender.cams.push(uiCam);
		
		var f:FontBuilderNGL = new FontBuilderNGL();
		f.loadFile("assets/font/04b03_regular_8.xml");
		layout = new Margins();
		canvas = new mint.Canvas({
			name:'canvas',
			rendering: Main.rendering,
			options: {
				group: this,
				cams: [uiCam],
				font: f.font
			},
			x: 0, y:0, w: SnowApp._snow.window.width, h: SnowApp._snow.window.height
		});
		focus = new Focus(canvas);
		
		var dMgr:ForwardProgramMgr = cast GlobalRender.cam.mgr;
		dMgr.skyBoxLegacyProgram.loadSkyBoxFile("assets/img/cubemap_4k.png");
		
		var panel:Panel = new Panel({
			options: {},
            parent: canvas,
            name: "test_panel",
			x: 0, y: 0, w: 256, h: 256
		});
		var progress:Progress = new Progress({
			options: { color: Color.fromValues(1, 1, 1) },
            parent: canvas,
            name: "test_panel",
			x: 64, y: 0, w: 128, h: 12,
			progress: 0.33
		});
		var slider:Slider = new Slider({
			options: { color: Color.fromValues(1, 1, 1) },
            parent: canvas,
            name: "test_slider",
			x: 244, y: 0, w: 12, h: 128,
			value: 0.75,
			vertical: true
		});
		var window:Window = new Window({
			options: {},
            parent: canvas,
            name: "test_window",
			x: 266, y: 0, w: 256, h: 256,
			collapsible: true
		});
		var image:Image = new Image({
			options: { sizing: "cover" },
            parent: window,
            name: "test_image",
			x: 0, y: 64, w: 256, h: 256 - 64,
			path: "assets/img/squirrel.png"
		});
		var textEdit:TextEdit = new TextEdit({
			options: {},
            parent: window,
            name: "test_textEdit",
            x: 0, y: 28, w: 256, h: 32
        });
		var check:Checkbox = new Checkbox({
			options: {},
            parent: canvas,
            name: "test_checkbox",
            x: 0, y: 0, w: 32, h: 32
        });
		var btn:Button = new Button({
			options: {},
            parent: canvas,
            name: "test_btn",
			text: "Test btn",
            x: 64, y: 64, w: 128, h: 32
		});
		var scroll:Scroll = new Scroll({
			options: {},
            parent: canvas,
            name: "test_scroll",
            x: 128, y: 128, w: 64, h: 32
		});
		var label2:Label = new Label({
			options: {},
            parent: scroll,
            name: "test_label2",
			text: "Label 2",
			x: 0, y: 0, w: 128, h: 128
		});
		
		var ddown:Dropdown = new Dropdown({
			options: {},
            parent: canvas,
            name: "test_ddown",
			text: "Testddown",
			x: 0, y: 128, w: 96, h: 32
		});
		var dlist:Array<String> = ["item1", "item2", "item3", "item4", "item5", "item6", "item7", "item8"];
		inline function add_plat(name:String) {
            var first = dlist.indexOf(name) == 0;
            ddown.add_item(
                new mint.Label( {
					options: {},
                    parent: ddown, text: '$name',
                    name: 'plat-$name', w:64, h:24, text_size: 14
                }),
                10, (first) ? 0 : 10
            );
        }
        for(d in dlist) add_plat(d);
		
		var text0:Text = new Text(f.font);
		text0.pos.set(0, 1, 0);
		text0.setMetrics(Text.AUTO_WIDTH, Text.ALIGN_CENTER, 8 / SnowApp._snow.window.width);
		text0.setText("Winter is coming,\nso is ChopEngine. Chop.");
		add(text0);
		
		var text1:Text = new Text(f.font);
		text1.pos.set(0, 2, 0);
		text1.setMetrics(Text.CHAR_WRAP, Text.ALIGN_CENTER, 8 / SnowApp._snow.window.width, 64 / SnowApp._snow.window.width);
		text1.setText("Winter is coming,\nso is ChopEngine. Chop.");
		add(text1);
		
		var text2:Text = new Text(f.font);
		text2.pos.set(0, 3, 0);
		text2.setMetrics(Text.WORD_WRAP, Text.ALIGN_CENTER, 8 / SnowApp._snow.window.width, 64 / SnowApp._snow.window.width);
		text2.setText("Winter is coming,\nso is ChopEngine. Chop.");
		add(text2);
		
		var m:Model = new Model();
		var objLoader:ObjLoader = new ObjLoader();
		objLoader.loadFile("assets/obj/lowpoly.obj", "assets/obj/lowpoly.mtl");
		m.loadData(objLoader.data);
		//m.loadChop("assets/mesh/lowpoly.chopmesh");
		add(m);
		
		var m2:Model = new Model();
		//var objLoader:ObjLoader = new ObjLoader();
		//objLoader.loadFile("assets/obj/corgi.obj", "assets/obj/corgi.mtl");
		//m2.loadData(objLoader.data);
		m2.loadChop("assets/mesh/corgi.chopmesh");
		m2.scale.x = 2.0;
		m2.scale.y = 2.0;
		m2.scale.z = 2.0;
		m2.rot.y = 2.0;
		m2.pos.y = 0.1;
		m2.pos.x = 5.0;
		for (mat in m2.data.materials)
		{
			mat.transparency = 0.85;
		}
		add(m2);
		
		// simple sun light
		var displace:Vec4 = new Vec4(0, -0.5, -1, 0);
		var sun:SunLight = new SunLight();
		sun.dir.x = displace.x;
		sun.dir.y = displace.y;
		sun.dir.z = displace.z;
		sun.dir = sun.dir.normalize();
		sun.energy = 0.02;
		sun.color.x = 0.7;
		sun.color.y = 0.5;
		sun.color.z = 0.3;
		sun.useSpecular = false;
		lights.lights.push(sun);
		
		// simple point light
		var point:PointLight = new PointLight();
		point.pos.x = 3.6;
		point.pos.y = 3.96;
		point.energy = 1.0;
		point.color.x = 1.0;
		point.color.y = 0.0;
		point.color.z = 0.0;
		point.distance = 25.0;
		point.useSpecular = false;
		//point.constant = 1.0;
		point.quadratic = 2.0;
		//point.linear = 3.4;
		lights.lights.push(point);
		
		// simple cone light
		var cone:ConeLight = new ConeLight();
		cone.pos.x = -12.0;
		cone.pos.y = 1.5;
		cone.pos.z = 10;
		cone.dir.x = 0.0;
		cone.dir.y = 0.0;
		cone.dir.z = -1.0;
		cone.energy = 2;
		cone.color.x = 0.0;
		cone.color.y = 0.0;
		cone.color.z = 1.0;
		cone.coneAngle = 35.0;
		cone.distance = 400;
		cone.useSpecular = true;
		//cone.constant = 1.0;
		cone.quadratic = 3.0;
		//cone.linear = 3.4;
		lights.lights.push(cone);
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