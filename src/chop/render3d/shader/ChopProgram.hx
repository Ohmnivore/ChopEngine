package chop.render3d.shader;

import chop.model.data.Face;
import chop.model.data.Vertex;
import chop.model.Model;
import chop.render3d.Camera;
import chop.render3d.opengl.GL;
import chop.render3d.opengl.ChopGL;
import chop.render3d.opengl.GL.GLTexture;
import chop.render3d.Program;
import hxmath.math.MathUtil;
import hxmath.math.Matrix4x4;
import hxmath.math.Vector3;
import lime.Assets;
import lime.utils.ArrayBufferView;
import chop.math.Util;
import lime.utils.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ChopProgram
{
	public var inTextures:Array<ChopTextureDescriptor>;
	public var outTextures:Array<ChopTexture>;
	public var prog:GLProgram;
	
	private var n:Vector3;
	private var u:Vector3;
	private var v:Vector3;
	
	public function new() 
	{
		n = new Vector3(0.0, 0.0, 0.0);
		u = new Vector3(0.0, 0.0, 0.0);
		v = new Vector3(0.0, 0.0, 0.0);
		
		prog = GL.createProgram();
		var id:String = "assets/g_buffer_vertex.glsl";
		new ChopShader(id, Assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/g_buffer_fragment.glsl";
		new ChopShader(id, Assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures = [];
		outTextures = [];
		
		var gPosition:ChopTexture = new ChopTexture(
			new ChopTextureDescriptor("gPosition", "gPosition"), GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gPosition);
		
		var gNormal:ChopTexture = new ChopTexture(
			new ChopTextureDescriptor("gNormal", "gNormal"), GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gNormal);
		
		var gDiffuse:ChopTexture = new ChopTexture(
			new ChopTextureDescriptor("gDiffuse", "gDiffuse"), GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gDiffuse);
		
		var gSpec:ChopTexture = new ChopTexture(
			new ChopTextureDescriptor("gSpec", "gSpec"), GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gSpec);
	}
	
	public function preRender():Void
	{
		//GLuint attachments[3] = { GL_COLOR_ATTACHMENT0, GL_COLOR_ATTACHMENT1, GL_COLOR_ATTACHMENT2 };
		//glDrawBuffers(3, attachments);
		//glBindFramebuffer(GL_FRAMEBUFFER, gBuffer);
		//GL.bindFramebuffer(GL.FRAMEBUFFER, 
	}
	
	public function render(M:Model, C:Camera):Void
	{
		// Matrix calculations
		var m:Matrix4x4 = getModelMatrix(getTranslationMatrix(M), getRotationMatrix(M), getScaleMatrix(M));
		
		// Main shader program
		GL.useProgram(prog);
		
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
			GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 6, sizeOfFloat * 0);
			GL.enableVertexAttribArray(1);
			GL.bindAttribLocation(prog, 1, "normal");
			GL.vertexAttribPointer(1, 3, GL.FLOAT, false, sizeOfFloat * 6, sizeOfFloat * 3);
			
			GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 6));
			
			GL.disableVertexAttribArray(0);
			GL.disableVertexAttribArray(1);
			GL.deleteBuffer(vertexBuffer);
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
		
		//Verts.push((V1.x + V2.x + V3.x) / 3.0);
		//Verts.push((V1.y + V2.y + V3.y) / 3.0);
		//Verts.push((V1.z + V2.z + V3.z) / 3.0);
		
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