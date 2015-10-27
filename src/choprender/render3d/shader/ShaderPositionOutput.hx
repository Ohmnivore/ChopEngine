package choprender.render3d.shader;

import choprender.render3d.opengl.ChopProgram;
import choprender.render3d.opengl.ChopShader;
import choprender.render3d.opengl.ChopTexture;
import choprender.render3d.opengl.ChopTextureParam;
import choprender.render3d.shader.*;
import choprender.model.data.Face;
import choprender.model.data.Vertex;
import choprender.model.Model;
import choprender.render3d.Camera;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.GL.GLTexture;
import choprender.render3d.opengl.ChopProgramMgr;
import choprender.render3d.opengl.GLUtil;
import chop.math.Mat4;
import chop.math.Vec3;
import chop.math.Util;
import choprender.render3d.opengl.GL.Float32Array;
import choprender.render3d.shaderexp.opengl.ChopGL;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderPositionOutput extends ChopProgram
{
	public var gPosition:ChopTexture;
	
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.MULTIPLE;
		
		var id:String = "assets/shader/position_output_vertex.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/position_output_fragment.glsl";
		new ChopShader(id, Main.assets.getText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		gPosition = new ChopTexture("gPosition", GL.TEXTURE_2D, 0, ChopGL.RGBA16F, C.width, C.height, GL.RGBA, GL.FLOAT);
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gPosition.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gPosition);
	}
	
	override public function preRender(Mgr:ChopProgramMgr):Void 
	{
		super.preRender(Mgr);
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
	}
	
	override public function render(Models:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(Models, C, Mgr);
		
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
				
				for (mat in M.data.materials)
				{
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
					GL.vertexAttribPointer(0, 3, GL.FLOAT, false, sizeOfFloat * 3, sizeOfFloat * 0);
					
					GL.drawArrays(GL.TRIANGLES, 0, Std.int(vData.length / 3));
					
					GL.disableVertexAttribArray(0);
					GL.deleteBuffer(vertexBuffer);
				}
			}
		}
	}
	private function getTranslationMatrix(M:Model):Mat4
	{
		return Mat4.newIdent().trans(M.pos);
	}
	private function getRotationMatrix(M:Model):Mat4
	{
		return Util.eulerDegToMatrix4x4(M.rot.x, M.rot.y, M.rot.z);
	}
	private function getScaleMatrix(M:Model):Mat4
	{
		return Mat4.newIdent().scale(M.scale);
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
	}
}