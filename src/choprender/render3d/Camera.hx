package choprender.render3d;

import chop.gen.Basic;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.shader.ForwardProgramMgr;
import glm.GLM;
import glm.Mat4;
import glm.Projection;
import glm.Vec2;
import glm.Vec3;
import glm.Vec4;
import choprender.model.Model;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLProgram;
import choprender.render3d.opengl.GL.GLShader;
import chop.render3d.shader.*;

/**
 * ...
 * @author Ohmnivore
 */
class Camera extends Basic
{
	public var mgr:ChopProgramMgr;
	
	public var screenPos:Vec2;
	public var width:Int;
	public var height:Int;
	public var FOV:Float;
	public var ratio:Float;
	public var displayMin:Float;
	public var displayMax:Float;
	public var isOrtho:Bool;
	public var pos:Vec3;
	public var rot:Vec3;
	public var bgColor:Vec3;
	public var shouldClearColor:Bool;
	public var shouldClearDepth:Bool;
	
	public var projectionMatrix:Mat4;
	public var viewMatrix:Mat4;
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0) 
	{
		super();
		
		screenPos = new Vec2(0, 0);
		
		if (Width == 0)
			Width = SnowApp._snow.window.width;
		if (Height == 0)
			Height = SnowApp._snow.window.height;
		
		FOV = 40.0;
		displayMin = 0.1;
		displayMax = 200.0;
		pos = new Vec3(0.0, 0.0, 0.0);
		rot = new Vec3(0.0, 0.0, 0.0);
		isOrtho = false;
		bgColor = new Vec3(1.0, 1.0, 1.0);
		shouldClearColor = true;
		shouldClearDepth = true;
		projectionMatrix = Mat4.zero();
		viewMatrix = Mat4.zero();
		
		setView(X, Y, Width, Height);
	}
	
	public function setView(ScreenX:Int, ScreenY:Int, Width:Int, Height:Int, Ratio:Int = -1):Void
	{
		screenPos.x = ScreenX;
		screenPos.y = ScreenY;
		width = Width;
		height = Height;
		if (Ratio == -1)
			ratio = Std.int(width) / Std.int(height);
		else
			ratio = Ratio;
		createProgramMgrs();
	}
	
	public function setViewport():Void
	{
		GL.viewport(Std.int(screenPos.x), Std.int(SnowApp._snow.window.height - screenPos.y - height), width, height);
	}
	public function setScissor():Void
	{
		GL.scissor(Std.int(screenPos.x), Std.int(SnowApp._snow.window.height - screenPos.y - height), width, height);
	}
	
	private function createProgramMgrs():Void
	{
		mgr = new ForwardProgramMgr(this);
		mgr.init();
	}
	
	public function preDraw(Elapsed:Float):Void
	{
		mgr.preDraw(Elapsed);
	}
	
	public function postDraw(Elapsed:Float):Void
	{
		mgr.postDraw(Elapsed);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		computeProjectionMatrix();
		computeViewMatrix();
	}
	
	public function computeProjectionMatrix():Void
	{
		if (isOrtho)
			projectionMatrix = Projection.ortho(-1, 1, -1 / ratio, 1 / ratio, displayMin, displayMax);
		else
			projectionMatrix = Projection.perspective(FOV*GLM.degToRad, ratio, displayMin, displayMax);
	}
	
	public function computeViewMatrix():Void
	{
		var direction:Vec3 = new Vec3(0.0, 0.0, -1.0);
		//direction.x = Math.sin(rot.y*GLM.degToRad) * Math.cos(rot.x*GLM.degToRad);
		//direction.y = Math.sin(rot.x*GLM.degToRad);
		//direction.z = Math.cos(rot.x*GLM.degToRad) * Math.cos(rot.y*GLM.degToRad);
		
		viewMatrix = Projection.lookAt(pos, pos - direction, new Vec3(0.0, 1.0, 0.0));
		//viewMatrix = Mat4.identity();
	}
}