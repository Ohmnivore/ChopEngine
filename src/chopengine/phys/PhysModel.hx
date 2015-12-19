package chopengine.phys;

import chop.math.Vec4;
import choprender.model.data.Face;
import jiglib.math.Matrix3D;
import jiglib.math.Vector3D;

import jiglib.data.TriangleVertexIndices;
import jiglib.plugin.ISkin3D;

import choprender.model.Model;

class PhysModel implements ISkin3D
{
	public var transform(get, set):Matrix3D;
	public var vertices(get, never):Array<Vector3D>;
	public var indices(get, never):Array<TriangleVertexIndices>;
	public var mesh(get, never):Model;

	private var _mesh:Model;
	private var _translationOffset:Vector3D;
	private var _scale:Vector3D;
	private var _transform:Matrix3D = new Matrix3D();

	public function new(do3d:Model, offset:Vec4 = null)
	{
		this._mesh = do3d;
		
		_transform.identity();
		
		if (offset != null) {
			_translationOffset = new Vector3D(offset.x, offset.y, offset.z, offset.w);
		}
		if (do3d.scale.x != 1.0 || do3d.scale.y != 1.0 || do3d.scale.z != 1.0) {
			_scale = new Vector3D(do3d.scale.x, do3d.scale.y, do3d.scale.z);
		}
	}

	function get_transform():Matrix3D
	{
		return _transform;
	}

	function set_transform(m:Matrix3D)
	{
		_transform.identity();
		if (_translationOffset != null) _transform.appendTranslation(_translationOffset.x, _translationOffset.y, _translationOffset.z);
		if (_scale != null) _transform.appendScale(_scale.x, _scale.y, _scale.z);
		_transform.append(m);
		
		var decom = _transform.decompose();
		var pos = decom[0], rot = decom[1], scale = decom[2];
		_mesh.pos.x = pos.x;
		_mesh.pos.y = pos.y;
		_mesh.pos.z = pos.z;
		_mesh.rot.x = rot.x;
		_mesh.rot.y = rot.y;
		_mesh.rot.z = rot.z;
		_mesh.scale.x = scale.x;
		_mesh.scale.y = scale.y;
		_mesh.scale.z = scale.z;
		
		return _transform;
	}

	function get_mesh():Model
	{
		return _mesh;
	}

	function get_vertices():Array<Vector3D>
	{
		var result:Array<Vector3D> = new Array<Vector3D>();
		for (vt in _mesh.anim.vertices)
			result.push(new Vector3D(vt.x, vt.y, vt.z));
		return result;
	}

	function get_indices():Array<TriangleVertexIndices>
	{
		var result:Array<TriangleVertexIndices> = new Array<TriangleVertexIndices>();
		for (i in 0..._mesh.data.faces.length)
		{
			var f:Face = _mesh.data.faces[i];
			result.push(new TriangleVertexIndices(f.geomIdx[0], f.geomIdx[1], f.geomIdx[2]));
		}
		return result;
	}
}
