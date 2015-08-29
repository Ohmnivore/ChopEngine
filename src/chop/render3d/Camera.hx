package chop.render3d;
import chop.gen.Basic;
import chop.gen.Global;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vector3;
import hxmath.math.Vector4;
import chop.math.Util;
import chop.model.Model;
//import snow.modules.opengl.GL;
//import snow.modules.opengl.GL.GLProgram;
//import snow.modules.opengl.GL.GLShader;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;

/**
 * ...
 * @author Ohmnivore
 */
class Camera extends Basic
{
	public var prog:Program;
	
	public var gBuffer:Int;
	public var gPosition:Int;
	public var gNormal:Int;
	public var noiseTexture:Int;
	public var ssaoKernel:Array<Vector3>;
	
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
	
	public function new() 
	{
		super();
		
		screenPos = new Vector2(0, 0);
		setView(0, 0, 640, 480);
		FOV = 45.0;
		displayMin = 0.1;
		displayMax = 200.0;
		pos = new Vector3(0.0, 0.0, 0.0);
		rot = new Vector3(0.0, 0.0, 0.0);
		bgColor = new Vector3(1.0, 1.0, 1.0);
		projectionMatrix = Matrix4x4.zero;
		viewMatrix = Matrix4x4.zero;
		prog = new Program("assets/default_vertex.glsl", "assets/default_fragment.glsl");
		
		GL.enable(GL.CULL_FACE);
		GL.enable(GL.DEPTH_TEST);
		GL.depthFunc(GL.LESS);
		
		preDraw(0);
		postDraw(0);
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
		GL.viewport(Std.int(screenPos.x), Std.int(480 - screenPos.y - height), width, height);
		GL.clearColor(bgColor.x, bgColor.y, bgColor.z, 1.0);
		GL.clear(GL.DEPTH_BUFFER_BIT);
	}
	
	public function postDraw(Elapsed:Float):Void
	{
		for (basic in Global.state.members)
		{
			if (Std.is(basic, Model))
			{
				var m:Model = cast basic;
				if (checkIfCam(m))
				{
					m.mgr.render(m, this);
					//renderModel(m);
				}
			}
		}
	}
	private function checkIfCam(M:Model):Bool
	{
		for (c in M.cams)
		{
			if (c == this)
				return true;
		}
		return false;
	}
	private function renderModel(M:Model):Void
	{
		prog.renderModel(M, this);
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
		
		//var upVec:Vector4 = new Vector3(0.0, 1.0, 0.0, 1.0) * Util.eulerToMatrix4x4(
			//MathUtil.degToRad(nRot.x),
			//MathUtil.degToRad(nRot.y),
			//MathUtil.degToRad(nRot.z));
		var upVec:Vector4 = Matrix4x4.multiplyVector(Util.eulerToMatrix4x4(
			MathUtil.degToRad(nRot.x),
			MathUtil.degToRad(nRot.y),
			MathUtil.degToRad(nRot.z)), new Vector4(0.0, 1.0, 0.0, 1.0));
		
		viewMatrix = Util.lookAt(nPos, nPos - direction, new Vector3(upVec.x, upVec.y, upVec.z));
	}
}