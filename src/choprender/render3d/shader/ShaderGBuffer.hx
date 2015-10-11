package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.ChopGL_FFI;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.shader.ChopProgramMgr;
import choprender.render3d.GLUtil;
import chop.math.Mat4;
import chop.math.Vec3;
import chop.assets.Assets;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;

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
	public var gRealPosition:ChopTexture;
	public var gUV:ChopTexture;
	
	private var n:Vec3;
	private var u:Vec3;
	private var v:Vec3;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.MULTIPLE;
		
		n = Vec3.fromValues(0.0, 0.0, 0.0);
		u = Vec3.fromValues(0.0, 0.0, 0.0);
		v = Vec3.fromValues(0.0, 0.0, 0.0);
		
		var id:String = "assets/shader/g_buffer_vertex.glsl";
		new ChopShader(id, Assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/g_buffer_fragment.glsl";
		new ChopShader(id, Assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gPosition = new ChopTexture("gPosition", GL.TEXTURE_2D, 0, ChopGL.RGBA16F, C.width, C.height, GL.RGBA, GL.FLOAT);
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gPosition);
		
		gNormal = new ChopTexture("gNormal", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGBA, GL.FLOAT);
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gNormal.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gNormal);
		
		gDiffuse = new ChopTexture("gDiffuse", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGBA, GL.FLOAT);
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gDiffuse.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gDiffuse);
		
		gSpec = new ChopTexture("gSpec", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGBA, GL.FLOAT);
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gSpec.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gSpec);
		
		gRealPosition = new ChopTexture("gRealPosition", GL.TEXTURE_2D, 0, ChopGL.RGBA16F, C.width, C.height, GL.RGBA, GL.FLOAT);
		gRealPosition.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gRealPosition.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gRealPosition);
		
		gUV = new ChopTexture("gUV", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGBA, GL.FLOAT);
		gUV.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gUV.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gUV);
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		for (M in Models)
		{
			if (M.visible)
			{
				// Matrix calculations
				var m:Mat4 = getModelMatrix(getTranslationMatrix(M), getRotationMatrix(M), getScaleMatrix(M));
				
				// Transformation matrices
				GLUtil.setUniform(prog, "m", m);
				GLUtil.setUniform(prog, "v", C.viewMatrix);
				GLUtil.setUniform(prog, "p", C.projectionMatrix);
				
				// Transformation matrices
				GLUtil.setUniform(prog, "m", m);
				GLUtil.setUniform(prog, "v", C.viewMatrix);
				GLUtil.setUniform(prog, "p", C.projectionMatrix);
				
				var textureID:Int = 0;
				for (tex in M.data.textures)
				{
					GL.activeTexture(ChopProgram.textureIDToGL(textureID));
					GL.bindTexture(tex.choptex.target, tex.choptex.texture);
					GLUtil.setInt(GLUtil.getLocation(prog, "texture" + textureID), textureID);
					
					textureID++;
				}
				
				for (mat in M.data.materials)
				{
					// Material uniforms
					GLUtil.setUniform(prog, "diffuseColor", mat.diffuseColor);
					GLUtil.setUniform(prog, "specularColor", mat.specularColor);
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
							
							pushVert(vData, v1, v1, v2, v3, f, f.uv1, f.textureID);
							pushVert(vData, v2, v1, v2, v3, f, f.uv2, f.textureID);
							pushVert(vData, v3, v1, v2, v3, f, f.uv3, f.textureID);
						}
					}
					
					var vertexBuffer:GLBuffer = GL.createBuffer();
					GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
					GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
					
					var sizeOfFloat:Int = 4;
					GL.enableVertexAttribArray(0);
					GL.bindAttribLocation(prog, 0, "position");
					GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 0);
					GL.enableVertexAttribArray(1);
					GL.bindAttribLocation(prog, 1, "meanPosition");
					GL.vertexAttribPointer(1, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 3);
					GL.enableVertexAttribArray(2);
					GL.bindAttribLocation(prog, 2, "normal");
					GL.vertexAttribPointer(2, 3, GL.FLOAT, false, sizeOfFloat * 12, sizeOfFloat * 6);
					GL.enableVertexAttribArray(3);
					GL.bindAttribLocation(prog, 3, "uv");
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
	}
	private function getTranslationMatrix(M:Model):Mat4
	{
		return Mat4.newIdent().trans(Util.Vector3ToGL(M.pos));
	}
	private function getRotationMatrix(M:Model):Mat4
	{
		var nRot:Vec3 = Util.Vector3ToGLSoft(M.rot);
		return Util.eulerDegToMatrix4x4(nRot.x, nRot.y, nRot.z);
	}
	private function getScaleMatrix(M:Model):Mat4
	{
		return Mat4.newIdent().scale(Util.Vector3ToGLSoft(M.scale));
	}
	private function getModelMatrix(T:Mat4, R:Mat4, S:Mat4):Mat4
	{
		return S * R * T;
	}
	private function getMVPMatrix(M:Mat4, V:Mat4, P:Mat4):Mat4
	{
		return M * V * P;
	}
	private function pushVert(Verts:Array<Float>, Vec:Vertex, V1:Vertex, V2:Vertex, V3:Vertex, F:Face, UV:Array<Float>, TexID:Int):Void
	{
		Verts.push(Vec.x);
		Verts.push(Vec.y);
		Verts.push(Vec.z);
		
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
		//Verts.push(F.normal[0]);
		//Verts.push(F.normal[1]);
		//Verts.push(F.normal[2]);
		
		Verts.push(UV[0]);
		Verts.push(1.0 - UV[1]); // Invert y axis
		Verts.push(TexID / 16.0);
	}
}