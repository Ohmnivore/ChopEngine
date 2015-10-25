package chopengine.gen;

import chopengine.input.Mouse;
import choprender.GlobalRender;
import choprender.render3d.Camera;
import choprender.render3d.shader.ChopProgram;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.opengl.GL;

/**
 * ...
 * @author Ohmnivore
 */
class Game
{
	public var mouse:Mouse;
	public var state:State;
	
	public function new(S:State) 
	{
		mouse = new Mouse();
		
		state = S;
		
		GlobalRender.cam = new Camera();
		GlobalRender.cams.push(GlobalRender.cam);
		GlobalRender.members = state.members;
		
		state.create();
		
		GlobalRender.lights = state.lights;
	}
	
	public function update(Delta:Float):Void
	{
		for (cam in GlobalRender.cams)
			cam.update(Delta);
		state.update(Delta);
		mouse.update();
	}
	
	public function draw(Delta:Float):Void
	{
		GL.clear(GL.COLOR_BUFFER_BIT);
		GL.clear(GL.DEPTH_BUFFER_BIT);
		
		state.draw(Delta);
		for (cam in GlobalRender.cams)
		{
			cam.preDraw(Delta);
			cam.postDraw(Delta);
		}
	}
}