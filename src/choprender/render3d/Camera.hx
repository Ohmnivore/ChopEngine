package choprender.render3d;

import chop.gen.Basic;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.shader.ChopProgram;
import choprender.render3d.shader.DefaultProgramMgr;
import choprender.render3d.shader.ShaderFXAA;
import choprender.render3d.shader.ShaderGBuffer;
import choprender.render3d.shader.ShaderLights;
import choprender.render3d.shader.ShaderRGBAToLuma;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;
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
	
	public var screenPos:Vector2;
	public var width:Int;
	public var height:Int;
	public var FOV:Float;
	public var ratio:Float;
	public var displayMin:Float;
	public var displayMax:Float;
	public var pos:Vector3;
	public var rot:Vector3;
	public var bgColor:Vector3;
	
	public var projectionMatrix:Matrix4x4;
	public var viewMatrix:Matrix4x4;
	
	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0) 
	{
		super();
		
		screenPos = new Vector2(0, 0);
		
		if (Width == 0)
			Width = SnowApp._snow.window.width;
		if (Height == 0)
			Height = SnowApp._snow.window.height;
		setView(X, Y, Width, Height);
		
		FOV = 45.0;
		displayMin = 0.1;
		displayMax = 200.0;
		pos = new Vector3(0.0, 0.0, 0.0);
		rot = new Vector3(0.0, 0.0, 0.0);
		bgColor = new Vector3(1.0, 1.0, 1.0);
		projectionMatrix = Matrix4x4.zero;
		viewMatrix = Matrix4x4.zero;
		
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
		projectionMatrix = Util.perspective(FOV, ratio, displayMin, displayMax);
	}
	
	public function computeViewMatrix():Void
	{
		var nPos:Vector3 = Util.Vector3ToGL(pos);
		var nRot:Vector3 = Util.Vector3ToGLSoft(rot);
		
		var direction:Vector3 = new Vector3(0.0, 0.0, 1.0);
		direction.x = Math.sin(MathUtil.degToRad(nRot.y)) * Math.cos(MathUtil.degToRad(nRot.x));
		direction.y = Math.sin(MathUtil.degToRad(nRot.x));
		direction.z = Math.cos(MathUtil.degToRad(nRot.x)) * Math.cos(MathUtil.degToRad(nRot.y));
		
		var upVec:Vector4 = Matrix4x4.multiplyVector(Util.eulerToMatrix4x4(
			MathUtil.degToRad(nRot.x),
			MathUtil.degToRad(nRot.y),
			MathUtil.degToRad(nRot.z)), new Vector4(0.0, 1.0, 0.0, 1.0));
		
		viewMatrix = Util.lookAt(nPos, nPos - direction, new Vector3(upVec.x, upVec.y, upVec.z));
	}
}