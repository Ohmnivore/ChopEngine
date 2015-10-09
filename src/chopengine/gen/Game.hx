package chopengine.gen;

import choprender.GlobalRender;
import choprender.render3d.Camera;
import choprender.render3d.shader.ChopProgram;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.shader.ShaderGBuffer;
import choprender.render3d.shader.ShaderQuadTexture;
import choprender.render3d.opengl.GL;
//import jiglib.cof.JConfig;

/**
 * ...
 * @author Ohmnivore
 */
class Game
{
	public function new(S:State) 
	{
		Global.game = this;
		Global.state = S;
		
		GlobalRender.cam = new Camera();
		GlobalRender.cams.push(GlobalRender.cam);
		GlobalRender.members = Global.state.members;
		
		//JConfig.solverType = "FAST";
		//JConfig.doShockStep = true;
		Global.state.create();
		
		GlobalRender.lights = Global.state.lights;
	}
	
	public function update(Delta:Float):Void
	{
		for (cam in GlobalRender.cams)
			cam.update(Delta);
		Global.state.update(Delta);
	}
	
	public function draw(Delta:Float):Void
	{
		GL.clear(GL.COLOR_BUFFER_BIT);
		GL.clear(GL.DEPTH_BUFFER_BIT);
		
		Global.state.draw(Delta);
		for (cam in GlobalRender.cams)
		{
			cam.preDraw(Delta);
			cam.postDraw(Delta);
		}
	}
}