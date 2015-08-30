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
class ShaderQuadTexture extends ChopProgram
{
	public var gLight:ChopTexture;
	
	public function new() 
	{
		super();
		
		type = ChopProgram.ONESHOT;
		
		var id:String = "assets/shader/light_vertex.glsl";
		new ChopShader(id, Assets.loadText(id), GL.VERTEX_SHADER).attach(prog);
		id = "assets/shader/light_fragment.glsl";
		new ChopShader(id, Assets.loadText(id), GL.FRAGMENT_SHADER).attach(prog);
		GL.linkProgram(prog);
		
		inTextures.push(new ChopTextureDescriptor("gPosition", "gPosition"));
		inTextures.push(new ChopTextureDescriptor("gNormal", "gNormal"));
		inTextures.push(new ChopTextureDescriptor("gDiffuse", "gDiffuse"));
		inTextures.push(new ChopTextureDescriptor("gSpec", "gSpec"));
		
		gLight = new ChopTexture("gLight", GL.TEXTURE_2D, 0, ChopGL.RGB16F, 640, 480, GL.RGB, GL.FLOAT);
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MIN_FILTER, GL.NEAREST));
		gLight.params.push(new ChopTextureParam(GL.TEXTURE_MAG_FILTER, GL.NEAREST));
		outTextures.push(gLight);
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