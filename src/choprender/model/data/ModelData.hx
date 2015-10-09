package choprender.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class ModelData
{
	public var materials:Array<Material>;
	public var textures:Array<Texture>;
	public var faces:Array<Face>;
	public var anims:Map<String, Animation>;
	
	public function new() 
	{
		materials = [];
		textures = [];
		faces = [];
		anims = new Map<String, Animation>();
	}
	
	public function copy(M:ModelData):Void
	{
		materials.splice(0, materials.length);
		for (m in M.materials)
		{
			var newm:Material = new Material();
			newm.copy(m);
			materials.push(newm);
		}
		
		textures.splice(0, textures.length);
		for (t in M.textures)
		{
			var newt:Texture = new Texture();
			newt.copy(t);
			textures.push(newt);
		}
		
		faces.splice(0, faces.length);
		for (f in M.faces)
		{
			var newf:Face = new Face();
			newf.copy(f);
			faces.push(newf);
		}
		
		for (a in anims.keys())
			anims.remove(a);
		for (a in M.anims.keys())
		{
			var newa:Animation = new Animation();
			newa.copy(M.anims.get(a));
			anims.set(a, newa);
		}
	}
}