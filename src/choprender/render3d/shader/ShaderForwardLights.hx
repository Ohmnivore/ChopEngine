package choprender.render3d.shader;

import choprender.model.data.Face;
import choprender.model.data.Texture;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopShader;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.GLUtil;
import glm.GLM;
import glm.Mat4;
import glm.Quat;
import glm.Vec3;
import choprender.render3d.opengl.GL.Float32Array;
import choprender.render3d.light.Light;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderForwardLights extends ChopProgram
{
	public var gForwardLight:ChopTexture;
	
	private var n:Vec3;
	private var u:Vec3;
	private var v:Vec3;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.MULTIPLE;
		
		n = new Vec3(0.0, 0.0, 0.0);
		u = new Vec3(0.0, 0.0, 0.0);
		v = new Vec3(0.0, 0.0, 0.0);
		
		#if !js
		var id:String = "assets/shader/forward_light_vertex.glsl";
		#else
		var id:String = "assets/shaderweb/forward_light_vertex.glsl";
		#end
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		#if !js
		id = "assets/shader/forward_light_fragment.glsl";
		#else
		id = "assets/shaderweb/forward_light_fragment.glsl";
		#end
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gForwardLight = new ChopTexture("gForwardLight", GL.TEXTURE_2D, 0, GL.RGBA, C.width, C.height, GL.RGB, GL.FLOAT);
		gForwardLight.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.LINEAR));
		gForwardLight.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.LINEAR));
		outTextures.push(gForwardLight);
	}
	
	override public function preRender(Mgr:ChopProgramMgr):Void 
	{
		super.preRender(Mgr);
		GL.enable(GL.BLEND);
		GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
	}
	
	override public function postRender(Mgr:ChopProgramMgr):Void 
	{
		super.postRender(Mgr);
		GL.disable(GL.BLEND);
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
		// LightState globals
		GlobalRender.lights.setUniforms(prog);
		
		// Lights uniforms
		GLUtil.setInt(GLUtil.getLocation(prog, "numLights"), GlobalRender.lights.lights.length);
		for (i in 0...GlobalRender.lights.lights.length)
		{
			var light:Light = GlobalRender.lights.lights[i];
			light.setUniforms(prog, i);
		}
		
		for (M in Models)
		{
			if (M.visible)
			{
				if (M.clip == null)
					Mgr.cam.setScissor();
				else
					GL.scissor(Std.int(M.clip.x), Std.int(SnowApp._snow.window.height - M.clip.y - M.clip.w), Std.int(M.clip.z), Std.int(M.clip.w));
				
				// Matrix calculations
				var m:Mat4 = getModelMatrix(getTranslationMatrix(M), getRotationMatrix(M), getScaleMatrix(M));
				// Transformation matrices
				GLUtil.setUniformMat(prog, "m", m);
				GLUtil.setUniformMat(prog, "v", C.viewMatrix);
				GLUtil.setUniformMat(prog, "p", C.projectionMatrix);
				GLUtil.setUniformVec(prog, "viewPos", C.pos);
				
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
					mat.setUniforms(prog);
					
					var vData:Array<Float> = [];
					for (i in 0...M.data.faces.length)
					{
						var f:Face = M.data.faces[i];
						if (f.matID == mat.id)
						{
							var v1:Vertex = M.anim.vertices[f.geomIdx[0]];
							var v2:Vertex = M.anim.vertices[f.geomIdx[1]];
							var v3:Vertex = M.anim.vertices[f.geomIdx[2]];
							
							var t:Texture = M.data.textures[f.textureID];
							var blendMode:Int = 0;
							if (t != null)
								blendMode = t.blendMode;
							
							pushVert(vData, v1, v1, v2, v3, f, f.uv1, f.textureID, blendMode);
							pushVert(vData, v2, v1, v2, v3, f, f.uv2, f.textureID, blendMode);
							pushVert(vData, v3, v1, v2, v3, f, f.uv3, f.textureID, blendMode);
						}
					}
					
					var vertexBuffer:GLBuffer = GL.createBuffer();
					GL.bindBuffer(GL.ARRAY_BUFFER, vertexBuffer);
					GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
					
					var sizeOfFloat:Int = 4;
					GL.enableVertexAttribArray(0);
					GL.bindAttribLocation(prog, 0, "position");
					GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 10, sizeOfFloat * 0);
					GL.enableVertexAttribArray(1);
					GL.bindAttribLocation(prog, 1, "normal");
					GL.vertexAttribPointer(1, 3, GL.FLOAT, false, sizeOfFloat * 10, sizeOfFloat * 3);
					GL.enableVertexAttribArray(2);
					GL.bindAttribLocation(prog, 2, "uv");
					GL.vertexAttribPointer(2, 4, GL.FLOAT, false, sizeOfFloat * 10, sizeOfFloat * 6);
					
					GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 10));
					
					GL.disableVertexAttribArray(0);
					GL.disableVertexAttribArray(1);
					GL.disableVertexAttribArray(2);
					GL.deleteBuffer(vertexBuffer);
				}
			}
		}
	}
	private function getTranslationMatrix(M:Model):Mat4
	{
		//return GLM.translate(Mat4.identity(), M.pos);
		return Mat4.identity();
	}
	private function getRotationMatrix(M:Model):Mat4
	{
		//return Mat4.fromEulerRads(M.rot.x*GLM.degToRad, M.rot.y*GLM.degToRad, M.rot.z*GLM.degToRad);
		return Mat4.identity();
	}
	private function getScaleMatrix(M:Model):Mat4
	{
		//return GLM.scale(Mat4.identity(), M.scale);
		return Mat4.identity();
	}
	private function getModelMatrix(T:Mat4, R:Mat4, S:Mat4):Mat4
	{
		return S * R * T;
	}
	private function getMVPMatrix(M:Mat4, V:Mat4, P:Mat4):Mat4
	{
		return M * V * P;
	}
	private function pushVert(Verts:Array<Float>, Vec:Vertex, V1:Vertex, V2:Vertex, V3:Vertex, F:Face, UV:Array<Float>, TexID:Int, BlendMode:Int):Void
	{
		Verts.push(Vec.x);
		Verts.push(Vec.y);
		Verts.push(Vec.z);
		
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
		
		Verts.push(UV[0]);
		Verts.push(1.0 - UV[1]); // Invert y axis
		Verts.push(TexID / 16.0);
		Verts.push(BlendMode / 16.0);
	}
}