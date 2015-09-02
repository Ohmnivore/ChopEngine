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
import chop.assets.Assets;
import chop.math.Util;
import chop.render3d.opengl.GL.Float32Array;

/**
 * ...
 * @author Ohmnivore
 */
class ShaderFXAA extends ChopProgram
{
	public function new(C:Camera) 
	{
		super(C);
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/fxaa_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/fxaa_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gLight", "textureSampler"));
	}
	
	override public function render(M:Array<Model>, C:Camera, Mgr:ChopProgramMgr):Void 
	{
		super.render(M, C, Mgr);
		
		GL.clear(GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT);
		
		var vData:Array<Float> = [];
		vData = [
			-1.0, -1.0, 0.0,
		    1.0, -1.0, 0.0,
		    -1.0, 1.0, 0.0,
		    -1.0, 1.0, 0.0,
		    1.0, -1.0, 0.0,
		    1.0,  1.0, 0.0
		];
		var dataBuffer:GLBuffer = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, dataBuffer);
		GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vData), GL.STATIC_DRAW);
		
		GL.enableVertexAttribArray(0);
		GL.vertexAttribPointer(0, 3, GL.FLOAT, false, 0, 0);
		
		GL.drawArrays(GL.TRIANGLES, 0, 6);
		GL.disableVertexAttribArray(0);
	}
}