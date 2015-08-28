package chop.render3d;
import chop.gen.Global;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.math.Util;
import chop.model.Model;
import chop.render3d.light.Light;
//import snow.modules.opengl.GL;
//import snow.modules.opengl.GL.GLProgram;
//import snow.modules.opengl.GL.GLShader;
import chop.model.data.Vertex;
import chop.model.data.Face;
import hxmath.math.MathUtil;
//import sys.io.File;
//import snow.api.buffers.Float32Array;
//import snow.system.assets.AssetText;
//import snow.system.assets.Assets;
//import snow.system.assets.Asset;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.GL.GLProgram;
import chop.render3d.opengl.GL.GLShader;
import chop.render3d.opengl.GL.GLBuffer;
import lime.Assets;
import lime.utils.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class Program
{
	public var vShader:GLShader;
	public var fShader:GLShader;
	public var program:GLProgram;
	
	private var n:Vector3;
	private var u:Vector3;
	private var v:Vector3;
	
	public function new(VertexShaderPath:String, FragmentShaderPath:String) 
	{
		program = GL.createProgram();
		loadShader(vShader, GL.VERTEX_SHADER, VertexShaderPath);
		loadShader(fShader, GL.FRAGMENT_SHADER, FragmentShaderPath);
		link();
		
		n = new Vector3(0.0, 0.0, 0.0);
		u = new Vector3(0.0, 0.0, 0.0);
		v = new Vector3(0.0, 0.0, 0.0);
	}
	
	private function loadShader(Shader:GLShader, Kind:Int, Path:String):Void
	{
		Shader = GL.createShader(Kind);
		GL.shaderSource(Shader, Assets.getText(Path));
		GL.compileShader(Shader);
		trace(GL.getShaderInfoLog(Shader));
		GL.attachShader(program, Shader);
	}
	private function link():Void
	{
		GL.linkProgram(program);
	}
	
	private function getTranslationMatrix(M:Model):Matrix4x4
	{
		return Util.translate(Matrix4x4.identity, Util.Vector3ToGL(M.pos));
	}
	private function getRotationMatrix(M:Model):Matrix4x4
	{
		var nRot:Vector3 = Util.Vector3ToGLSoft(M.rot);
		return Util.eulerToMatrix4x4(
			MathUtil.degToRad(nRot.x),
			MathUtil.degToRad(nRot.y),
			MathUtil.degToRad(nRot.z)
		);
	}
	private function getScaleMatrix(M:Model):Matrix4x4
	{
		return Util.scale(Matrix4x4.identity, Util.Vector3ToGLSoft(M.scale));
	}
	private function getModelMatrix(T:Matrix4x4, R:Matrix4x4, S:Matrix4x4):Matrix4x4
	{
		return S * R * T;
	}
	private function getMVPMatrix(M:Matrix4x4, V:Matrix4x4, P:Matrix4x4):Matrix4x4
	{
		return M * V * P;
	}
	
	private function pushVert(Verts:Array<Float>, Vec:Vertex, V1:Vertex, V2:Vertex, V3:Vertex):Void
	{
		Verts.push(Vec.x);
		Verts.push(Vec.y);
		Verts.push(Vec.z);
		
		Verts.push(Vec.nx);
		Verts.push(Vec.ny);
		Verts.push(Vec.nz);
		
		Verts.push((V1.x + V2.x + V3.x) / 3.0);
		Verts.push((V1.y + V2.y + V3.y) / 3.0);
		Verts.push((V1.z + V2.z + V3.z) / 3.0);
		
		n.x = 0;
		n.y = 0;
		n.z = 0;
		u.x = V2.x - V1.x;
		u.y = V2.y - V1.y;
		u.z = V2.z - V1.z;
		v.x = V3.x - V1.x;
		v.y = V3.y - V1.y;
		v.z = V3.z - V1.z;
		n.x = u.y * v.z - u.z * v.y;
		n.y = u.z * v.x - u.x * v.z;
		n.z = u.x * v.y - u.y * v.x;
		
		Verts.push(n.x);
		Verts.push(n.y);
		Verts.push(n.z);
	}
	public function renderModel(M:Model, C:Camera):Void
	{
		// Matrix calculations
		var m:Matrix4x4 = getModelMatrix(getTranslationMatrix(M), getRotationMatrix(M), getScaleMatrix(M));
		var mvp:Matrix4x4 = getMVPMatrix(m, C.viewMatrix, C.projectionMatrix);
		
		// Main shader program
		GL.useProgram(program);
		
		// Transformation matrices
		GLUtil.setUniform(program, "mvp", mvp);
		GLUtil.setUniform(program, "m", m);
		GLUtil.setUniform(program, "v", C.viewMatrix);
		GLUtil.setUniform(program, "p", C.projectionMatrix);
		
		// LightState globals
		GLUtil.setUniform(program, "ambientColor", Global.state.lights.ambientColor);
		GLUtil.setUniform(program, "ambientIntensity", Global.state.lights.ambientIntensity);
		GLUtil.setUniform(program, "gamma", Global.state.lights.gamma);
		
		for (mat in M.data.materials)
		{
			// Material uniforms
			mat.setUniforms(program);
			
			// Lights uniforms
			GLUtil.setUniform(program, "numLights", Global.state.lights.lights.length);
			for (i in 0...Global.state.lights.lights.length)
			{
				var light:Light = Global.state.lights.lights[i];
				light.setUniforms(program, i);
			}
			
			var vData:Array<Float> = [];
			for (i in 0...M.data.faces.length)
			{
				var f:Face = M.data.faces[i];
				if (f.matID == mat.id)
				{
					var v1:Vertex = M.anim.vertices[f.geomIdx[0]];
					var v2:Vertex = M.anim.vertices[f.geomIdx[1]];
					var v3:Vertex = M.anim.vertices[f.geomIdx[2]];
					
					pushVert(vData, v1, v1, v2, v3);
					pushVert(vData, v2, v1, v2, v3);
					pushVert(vData, v3, v1, v2, v3);
				}
			}
			
			var vertexBuffer:GLBuffer = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
			GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
			
			var sizeOfFloat:Int = 4;
			GL.enableVertexAttribArray(0);
			GL.bindAttribLocation(program, 0, "positionModelSpace");
			GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 0);
			GL.enableVertexAttribArray(1);
			GL.bindAttribLocation(program, 1, "normalModelSpace");
			GL.vertexAttribPointer(1, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 3);
			GL.enableVertexAttribArray(2);
			GL.bindAttribLocation(program, 2, "meanPositionModelSpace");
			GL.vertexAttribPointer(2, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 6);
			GL.enableVertexAttribArray(3);
			GL.bindAttribLocation(program, 3, "meanNormalModelSpace");
			GL.vertexAttribPointer(3, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 9);
			
			GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 12));
			
			GL.disableVertexAttribArray(0);
			GL.disableVertexAttribArray(1);
			GL.disableVertexAttribArray(2);
			GL.disableVertexAttribArray(3);
			GL.deleteBuffer(vertexBuffer);
		}
	}
}