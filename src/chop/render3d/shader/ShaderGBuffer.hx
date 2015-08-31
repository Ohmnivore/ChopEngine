package chop.render3d.shader;

import chop.model.data.Face;
import chop.model.data.Vertex;
import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.opengl.ChopGL_FFI;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.ChopGL;
import chop.render3d.opengl.GL.GLTexture;
import chop.render3d.Program;
import chop.render3d.shader.ChopProgramMgr;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import chop.assets.Assets;
import chop.math.Util;
import chop.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderGBuffer extends ChopProgram
{
	public var gPosition:ChopTexture;
	public var gNormal:ChopTexture;
	public var gDiffuse:ChopTexture;
	public var gSpec:ChopTexture;
	
	private var n:Vector3;
	private var u:Vector3;
	private var v:Vector3;
	
	public function new() 
	{
		super();
		
		type = ChopProgram.MULTIPLE;
		
		n = new Vector3(0.0, 0.0, 0.0);
		u = new Vector3(0.0, 0.0, 0.0);
		v = new Vector3(0.0, 0.0, 0.0);
		
		var id:String = "assets/shader/g_buffer_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/g_buffer_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gPosition = new ChopTexture("gPosition", GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gPosition);
		
		gNormal = new ChopTexture("gNormal", GL.TEXTURE_2D, 0, GL.RGBA, 640, 480, GL.RGBA, GL.FLOAT);
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gNormal);
		
		gDiffuse = new ChopTexture("gDiffuse", GL.TEXTURE_2D, 0, GL.RGBA, 640, 480, GL.RGBA, GL.FLOAT);
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gDiffuse);
		
		gSpec = new ChopTexture("gSpec", GL.TEXTURE_2D, 0, GL.RGBA, 640, 480, GL.RGBA, GL.FLOAT);
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gSpec);
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		for (M in Models)
		{
			// Matrix calculations
			var m:Matrix4x4 = getModelMatrix(getTranslationMatrix(M), getRotationMatrix(M), getScaleMatrix(M));
			
			// Transformation matrices
			GLUtil.setUniform(prog, "m", m);
			GLUtil.setUniform(prog, "v", C.viewMatrix);
			GLUtil.setUniform(prog, "p", C.projectionMatrix);
			
			// Transformation matrices
			GLUtil.setUniform(prog, "m", m);
			GLUtil.setUniform(prog, "v", C.viewMatrix);
			GLUtil.setUniform(prog, "p", C.projectionMatrix);
			
			for (mat in M.data.materials)
			{
				// Material uniforms
				GLUtil.setUniform(prog, "diffuseColor", mat.diffuseColor);
				GLUtil.setUniform(prog, "specularColor", mat.specularColor);
				//GLUtil.setUniform(prog, "materialFlags", mat.toFlagFloat());
				GLUtil.setFloat(GLUtil.getLocation(prog, "diffuseIntensity"), mat.diffuseIntensity);
				GLUtil.setFloat(GLUtil.getLocation(prog, "specularIntensity"), mat.specularIntensity);
				GLUtil.setFloat(GLUtil.getLocation(prog, "ambientIntensity"), mat.ambientIntensity);
				GLUtil.setFloat(GLUtil.getLocation(prog, "materialFlags"), mat.toFlagFloat());
				GLUtil.setFloat(GLUtil.getLocation(prog, "emit"), mat.emit);
				
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
				GL.bindAttribLocation(prog, 0, "position");
				GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 9, sizeOfFloat * 0);
				GL.enableVertexAttribArray(1);
				GL.bindAttribLocation(prog, 1, "meanPosition");
				GL.vertexAttribPointer(1, 3, GL.FLOAT, false, sizeOfFloat * 9, sizeOfFloat * 3);
				GL.enableVertexAttribArray(2);
				GL.bindAttribLocation(prog, 2, "normal");
				GL.vertexAttribPointer(2, 3, GL.FLOAT, false, sizeOfFloat * 9, sizeOfFloat * 6);
				
				GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 9));
				
				GL.disableVertexAttribArray(0);
				GL.disableVertexAttribArray(1);
				GL.disableVertexAttribArray(2);
				GL.deleteBuffer(vertexBuffer);
			}
		}
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
		
		//Verts.push(Vec.nx);
		//Verts.push(Vec.ny);
		//Verts.push(Vec.nz);
		
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
}