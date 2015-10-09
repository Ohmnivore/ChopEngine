package choprender.model.data;

/**
 * ...
 * @author Ohmnivore
 */
class Face
{
	public var matID:Int;
	public var textureID:Int;
	public var geomIdx:Array<Int>;
	public var normal:Array<Float>;
	public var uv1:Array<Float>;
	public var uv2:Array<Float>;
	public var uv3:Array<Float>;
	
	public function new() 
	{
		matID = 0;
		textureID = -1;
		geomIdx = [];
		normal = [];
		uv1 = [];
		uv2 = [];
		uv3 = [];
	}
	
	public function copy(F:Face):Void
	{
		matID = F.matID;
		textureID = F.textureID;
		geomIdx.splice(0, geomIdx.length);
		for (i in F.geomIdx)
			geomIdx.push(i);
		normal.splice(0, normal.length);
		for (i in F.normal)
			normal.push(i);
		uv1.splice(0, uv1.length);
		for (i in F.uv1)
			uv1.push(i);
		uv2.splice(0, uv2.length);
		for (i in F.uv2)
			uv2.push(i);
		uv3.splice(0, uv3.length);
		for (i in F.uv3)
			uv3.push(i);
	}
}