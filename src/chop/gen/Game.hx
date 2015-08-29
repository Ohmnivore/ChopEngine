package chop.gen;

import chop.render3d.Camera;
import chop.render3d.shader.ChopProgram;
import chop.render3d.shader.ChopProgramMgr;
//import snow.modules.opengl.GL;
import lime.graphics.opengl.GL;
import jiglib.cof.JConfig;

/**
 * ...
 * @author Ohmnivore
 */
class Game
{
	public var defaultMgr:ChopProgramMgr;
	
	public function new(S:State) 
	{
		defaultMgr = new ChopProgramMgr();
		var gBufferProgram:ChopProgram = new ChopProgram();
		defaultMgr.progs.push(gBufferProgram);
		defaultMgr.init();
		
		Global.game = this;
		Global.state = S;
		
		Global.cam = new Camera();
		Global.cams.push(Global.cam);
		
		JConfig.solverType = "FAST";
		JConfig.doShockStep = true;
		Global.state.create();
	}
	
	public function update(Delta:Float):Void
	{
		for (cam in Global.cams)
			cam.update(Delta);
		Global.state.update(Delta);
	}
	
	public function draw(Delta:Float):Void
	{
		GL.clear(GL.COLOR_BUFFER_BIT);
		GL.clear(GL.DEPTH_BUFFER_BIT);
		
		Global.state.draw(Delta);
		for (cam in Global.cams)
		{
			cam.preDraw(Delta);
			cam.postDraw(Delta);
		}
	}
}