package choprender.render3d;

import chop.gen.Basic;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.shader.ChopProgram;
import choprender.render3d.shader.ForwardProgramMgr;
import choprender.render3d.shaderexp.ShaderFXAA;
import choprender.render3d.shaderexp.ShaderGBuffer;
import choprender.render3d.shaderexp.ShaderDeferredLights;
import choprender.render3d.shaderexp.ShaderRGBAToLuma;
import chop.math.Mat4;
import chop.math.Vec2;
import chop.math.Vec3;
import chop.math.Vec4;
import chop.math.Util;
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
	public var pos:Vec3;
	public var rot:Vec3;
	public var bgColor:Vec3;
	
	public var projectionMatrix:Mat4;
	public var viewMatrix:Mat4;
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0) 
	{
		super();
		
		screenPos = Vec2.fromValues(0, 0);
		
		if (Width == 0)
			Width = SnowApp._snow.window.width;
		if (Height == 0)
			Height = SnowApp._snow.window.height;
		setView(X, Y, Width, Height);
		
		FOV = 40.0;
		displayMin = 0.1;
		displayMax = 200.0;
		pos = Vec3.fromValues(0.0, 0.0, 0.0);
		rot = Vec3.fromValues(0.0, 0.0, 0.0);
		bgColor = Vec3.fromValues(1.0, 1.0, 1.0);
		projectionMatrix = Mat4.newZero();
		viewMatrix = Mat4.newZero();
		
		createProgramMgrs();
	}
	
	private function createProgramMgrs():Void
	{
		mgr = new ForwardProgramMgr(this);
		mgr.init();
	}
	
	public function setView(ScreenX:Int, ScreenY:Int, Width:Int, Height:Int, Ratio:Int = -1):Void
	{
		screenPos.x = ScreenX;
		screenPos.y = ScreenY;
		width = Width;
		height = Height;
		if (Ratio == -1)
			ratio = cast(width, Float) / cast(height, Float);
		else
			ratio = Ratio;
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
	
	private function computeProjectionMatrix():Void
	{
		projectionMatrix = new Mat4().perspective(Util.degToRad(FOV), ratio, displayMin, displayMax);
	}
	
	public function computeViewMatrix():Void
	{
		var nPos:Vec3 = pos;
		var nRot:Vec3 = rot;
		
		var direction:Vec3 = Vec3.fromValues(0.0, 0.0, 1.0);
		direction.x = Math.sin(Util.degToRad(nRot.y)) * Math.cos(Util.degToRad(nRot.x));
		direction.y = Math.sin(Util.degToRad(nRot.x));
		direction.z = Math.cos(Util.degToRad(nRot.x)) * Math.cos(Util.degToRad(nRot.y));
		
		var upVec:Vec4 = Vec4.fromValues(0.0, 1.0, 0.0, 1.0).transMat4(Util.eulerDegToMatrix4x4(nRot.x, nRot.y, nRot.z));
		
		//viewMatrix = new Mat4().lookAt(nPos, nPos - direction, Vec3.fromValues(upVec.x, upVec.y, upVec.z));
		viewMatrix = new Mat4().lookAt(nPos, nPos - direction, Vec3.fromValues(0.0, 1.0, 0.0));
	}
}