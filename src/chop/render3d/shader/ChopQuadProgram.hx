package chop.render3d.shader;

import chop.render3d.Camera;
import chop.render3d.opengl.GL;
import chop.model.Model;

/**
 * ...
 * @author Ohmnivore
 */
class ChopQuadProgram extends ChopProgram
{
	public function new(C:Camera) 
	{
		super(C);
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