package;

import chop.math.Quat;
import chop.math.Util;
import chop.math.Vec4;
import chopengine.input.Mouse;
import choprender.GlobalRender;
import chopengine.gen.State;
import choprender.model.loader.obj.ObjLoader;
import choprender.model.Model;
import choprender.model.QuadModel;
import choprender.render3d.Camera;
import choprender.render3d.light.ConeLight;
import choprender.render3d.light.PointLight;
import choprender.render3d.light.SunLight;
import choprender.text.loader.FontBuilderNGL;
import choprender.text.Text;
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
		
		//var m:Model = new Model();
		//m.loadChop("assets/mesh/lowpoly.chopmesh");
		//for (mat in m.data.materials)
		//{
			////mat.transparency = 0.75;
		//}
		//add(m);
		
		//var check:Checkbox = new Checkbox({
			//options: { group: this },
            //parent: canvas,
            //name: "test_check",
            //x: 0, y: 0, w: 32, h: 32
        //});
		//var btn:Button = new Button({
			//options: { group: this },
            //parent: canvas,
            //name: "test_btn",
			//text: "Test btn",
            //x: 64, y: 64, w: 64, h: 32
		//});
		//var ddown:Dropdown = new Dropdown({
			//options: { group: this },
            //parent: canvas,
            //name: "test_ddown",
			//text: "Test ddown",
			//x: 128, y: 128, w: 64, h: 32
		//});
		//var dlist:Array<String> = ["item1", "item2", "item3"];
		
		var f:FontBuilderNGL = new FontBuilderNGL();
		f.loadFile("assets/font/04b03_regular_8.xml");
		
		//var q:QuadModel = new QuadModel();
		//q.mat.useShading = false;
		//q.pos.x = 0;
		//q.pos.z = 2;
		//q.setSize(2.0, 1.0);
		//add(q);
		
		var text0:Text = new Text(f.font);
		text0.pos.set(0, 1, 0);
		text0.setMetrics(Text.AUTO_WIDTH, Text.ALIGN_LEFT, 0.02, 0);
		text0.setText("Winter is coming, so is ChopEngine. Chop.");
		add(text0);
		
		var text1:Text = new Text(f.font);
		text1.pos.set(0, 2, 0);
		text1.setMetrics(Text.CHAR_WRAP, Text.ALIGN_LEFT, 0.02, 64);
		text1.setText("Winter is coming,\nso is ChopEngine. Chop.");
		add(text1);
		
		var text2:Text = new Text(f.font);
		text2.pos.set(0, 3, 0);
		text2.setMetrics(Text.WORD_WRAP, Text.ALIGN_LEFT, 0.02, 64);
		text2.setText("Winter is coming,\nso is ChopEngine. Chop.");
		add(text2);
		
		//var t:Text = new Text(f.font);
		//t.pos.x = 0;
		//t.pos.y = 4;
		//t.setText("ChopEngine is chopping.\nIt's also far from completed.", 0.02);
		//t.setText("ChopEngine is chopping.\nIt's also far from done.", 0.02);
		//add(t);
		//
		//var t2:Text = new Text(f.font);
		//t2.textWidth = 64;
		//t2.pos.x = 5;
		//t2.pos.y = 4;
		//t2.setText("ChopEngine is chopping.\nIt's also far from completed.", 0.02);
		//add(t2);
		//
		//var t3:Text = new Text(f.font);
		//t3.textWidth = 64;
		//t3.wordWrap = true;
		//t3.pos.x = 10;
		//t3.pos.y = 4;
		//t3.setText("ChopEngine is chopping.\nIt's also far from completed.", 0.02);
		//add(t3);
		//
		//var t4:Text = new Text(f.font);
		//t4.textWidth = 64;
		//t4.wordWrap = true;
		////t4.alignment = "right";
		//t4.pos.x = 0;
		//t4.pos.y = 5;
		//t4.setText("ChopEngine is chopping.\nIt's also far from completed.", 0.02);
		//add(t4);
		
		//var mQuad:QuadModel = new QuadModel();
		//mQuad.loadTexFile("assets/font/04b03_regular_8.png");
		//mQuad.scale.set(1.28, 1.0, 0.64);
		//mQuad.mat.diffuseColor.set(0, 0, 0);
		//add(mQuad);
		
		//var m2:Model = new Model();
		////m2.loadChop("assets/mesh/corgi.chopmesh");
		//var objLoader:ObjLoader = new ObjLoader();
		//objLoader.loadFile("assets/obj/corgi.obj", "assets/obj/corgi.mtl");
		////objLoader.loadFile("assets/obj/lowpoly.obj", "assets/obj/lowpoly.mtl");
		//m2.loadData(objLoader.data);
		//m2.scale.x = 2.0;
		//m2.scale.y = 2.0;
		//m2.scale.z = 2.0;
		//m2.rot.y = 20.0;
		//m2.pos.y = 0.1;
		//m2.pos.x = 7.0;
		//for (mat in m2.data.materials)
		//{
			//mat.transparency = 0.75;
		//}
		//add(m2);
		
		var displace:Vec4 = Vec4.fromValues(0, 0, -1, 0);
		displace.transMat4(Util.eulerDegToMatrix4x4(
			0, 0, -25
		));
		// simple sun light
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
		
		// simple point light
		var point:PointLight = new PointLight();
		point.pos.x = 3.6;
		point.pos.y = 3.96;
		point.energy = 0.8;
		point.color.x = 1.0;
		point.color.y = 0.0;
		point.color.z = 0.0;
		point.distance = 15.0;
		point.useSpecular = false;
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
		lights.lights.push(cone);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		
		if (SnowApp._snow.input.keydown(Key.key_a))
			GlobalRender.cam.pos.x -= 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_d))
			GlobalRender.cam.pos.x += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_w))
			GlobalRender.cam.pos.z -= 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.key_s))
			GlobalRender.cam.pos.z += 5.0 * Elapsed;
		
		if (SnowApp._snow.input.keydown(Key.space))
			GlobalRender.cam.pos.y += 5.0 * Elapsed;
		if (SnowApp._snow.input.keydown(Key.lctrl))
			GlobalRender.cam.pos.y -= 5.0 * Elapsed;
		
		if (Main.game.mouse.rightPressed)
			GlobalRender.cam.rot.y -= Main.game.mouse.xRel / 2.0;
	}
}