package choprender.model;

import choprender.model.Model;
import choprender.model.data.*;

/**
 * ...
 * @author Ohmnivore
 */
class QuadModel extends Model
{
	private var v0:Vertex;
	private var v1:Vertex;
	private var v2:Vertex;
	private var v3:Vertex;
	private var frame0:Frame;
	private var anim0:Animation;
	private var mat:Material;
	
	public function new() 
	{
		super();
		
		v0 = new Vertex();
		v0.x = -1;
		v0.y = -1;
		v1 = new Vertex();
		v1.x = 1;
		v1.y = -1;
		v2 = new Vertex();
		v2.x = 1;
		v2.y = 1;
		v3 = new Vertex();
		v3.x = -1;
		v3.y = 1;
		
		var face0:Face = new Face();
		face0.geomIdx = [0, 1, 2];
		face0.matID = 0;
		var face1:Face = new Face();
		face1.geomIdx = [2, 3, 0];
		face1.matID = 0;
		
		frame0 = new Frame();
		frame0.vertices = [v0, v1, v2, v3];
		
		anim0 = new Animation();
		anim0.frames.push(frame0);
		
		mat = new Material();
		mat.id = 0;
		
		data.anims.set(anim0.name, anim0);
		data.faces = [face0, face1];
		data.materials = [mat];
		
		anim.play(anim0.name, true);
	}
}