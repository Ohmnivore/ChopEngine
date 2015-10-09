package choprender.render3d;

import chop.gen.Basic;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.shader.ChopProgram;
import choprender.render3d.shader.DefaultProgramMgr;
import choprender.render3d.shader.ShaderFXAA;
import choprender.render3d.shader.ShaderGBuffer;
import choprender.render3d.shader.ShaderLights;
import choprender.render3d.shader.ShaderRGBAToLuma;
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
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.ChopGL_FFI;

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
		
		FOV = 45.0;
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
		mgr = new DefaultProgramMgr(this);
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
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LEQUAL);
		GL.clearDepth(1.0);
		
		GL.viewport(Std.int(screenPos.x), Std.int(SnowApp._snow.window.height - screenPos.y - height), width, height);
		GL.clearColor(bgColor.x, bgColor.y, bgColor.z, 1.0);
		GL.clear(GL.DEPTH_BUFFER_BIT);
	}
	
	public function postDraw(Elapsed:Float):Void
	{
		// TODO: mgr array
		for (p in mgr.progs)
		{
			if (p.type == ChopProgram.MULTIPLE)
			{
				var toRender:Array<Model> = [];
				for (basic in GlobalRender.members)
				{
					if (Std.is(basic, Model))
					{
						var m:Model = cast basic;
						//if (m.mgr == mgr)
						//{
							toRender.push(m);
						//}
					}
				}
				p.preRender(mgr);
				p.render(toRender, this, mgr);
			}
			else if (p.type == ChopProgram.ONESHOT)
			{
				p.preRender(mgr);
				p.render(null, this, mgr);
			}
		}
		
		GL.disable(GL.CULL_FACE);
		GL.disable(GL.DEPTH_TEST);
	}
	
	override public function update(Elapsed:Float):Void 
	{
		super.update(Elapsed);
		computeProjectionMatrix();
		computeViewMatrix();
	}
	
	private function computeProjectionMatrix():Void
	{
		projectionMatrix = new Mat4().perspective(FOV, ratio, displayMin, displayMax);
	}
	
	public function computeViewMatrix():Void
	{
		var nPos:Vec3 = Util.Vector3ToGL(pos);
		var nRot:Vec3 = Util.Vector3ToGLSoft(rot);
		
		var direction:Vec3 = Vec3.fromValues(0.0, 0.0, 1.0);
		direction.x = Math.sin(Util.degToRad(nRot.y)) * Math.cos(Util.degToRad(nRot.x));
		direction.y = Math.sin(Util.degToRad(nRot.x));
		direction.z = Math.cos(Util.degToRad(nRot.x)) * Math.cos(Util.degToRad(nRot.y));
		
		var upVec:Vec4 = Vec4.fromValues(0.0, 1.0, 0.0, 1.0).transMat4(Util.eulerDegToMatrix4x4(nRot.x, nRot.y, nRot.z));
		
		viewMatrix = new Mat4().lookAt(nPos, nPos - direction, Vec3.fromValues(upVec.x, upVec.y, upVec.z));
	}
}