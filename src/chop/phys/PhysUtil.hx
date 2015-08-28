package chop.phys;

import chop.model.data.Face;
import chop.model.Model;
import jiglib.geometry.JTriangleMesh;

import jiglib.geometry.JBox;
import jiglib.math.Matrix3D;
import jiglib.math.Vector3D;
import jiglib.physics.RigidBody;

import jiglib.data.TriangleVertexIndices;
import jiglib.plugin.ISkin3D;

/**
 * ...
 * @author Ohmnivore
 */
class PhysUtil
{
	static public function meshToCube(M:PhysMesh, Width:Float, Height:Float, Depth:Float):RigidBody
	{
		var jBox:JBox = new JBox(M, Width, Height, Depth);
		return jBox;
	}
	
	static public function meshToMesh(M:PhysMesh):RigidBody
	{
		return new JTriangleMesh(M, new Vector3D(), new Matrix3D());
	}
}

class PhysMesh implements ISkin3D {

	public var transform(get, set) : Matrix3D;
	public var vertices(get, never) : Array<Vector3D>;
	public var indices(get, never) : Array<TriangleVertexIndices>;
	public var model(get, never) : Model;

	private var _model : Model;
	private var _translationOffset : Vector3D;
	private var _scale : Vector3D;
	private var _transform : Matrix3D = new Matrix3D();

	public function new(do3d : Model, offset : Vector3D = null)
	{
		this._model = do3d;

		_transform.identity();

		if (offset != null) {
			_translationOffset = offset.clone();
		}
		if (do3d.scale.x != 1 || do3d.scale.y != 1 || do3d.scale.z != 1) {
			_scale = new Vector3D(do3d.scale.x, do3d.scale.y, do3d.scale.z);
		}
	}

	function get_transform():Matrix3D {

		return _transform;
	}

	function set_transform(m:Matrix3D) {
		_transform.identity();
		if (_translationOffset != null) _transform.appendTranslation(_translationOffset.x, _translationOffset.y, _translationOffset.z);
		if (_scale != null) _transform.appendScale(_scale.x, _scale.y, _scale.z);
		_transform.append(m);

		var decom = _transform.decompose();
		var pos = decom[0], rot = decom[1], scale = decom[2];
		//_mesh.setPos(pos.x, pos.y, pos.z);
		//_mesh.setRotate(rot.x, rot.y, rot.z);
		//_mesh.scaleX = scale.x;
		//_mesh.scaleY = scale.y;
		//_mesh.scaleZ = scale.z;
		model.pos.x = pos.x;
		model.pos.y = -pos.z;
		model.pos.z = pos.y;
		model.rot.x = rot.x;
		model.rot.y = rot.y;
		model.rot.z = rot.z;
		model.scale.x = scale.x;
		model.scale.y = scale.y;
		model.scale.z = scale.z;

		return _transform;
	}

	function get_model():Model {
		return _model;
	}

	function get_vertices():Array<Vector3D> {
		var result:Array<Vector3D> = new Array<Vector3D>();

		//var vts = cast(_mesh.primitive,Polygon).points;
		var vts = _model.anim.vertices;
		for (vt in vts) {
			result.push(new Vector3D(vt.x, vt.y, vt.z));
			//result.push(new Vector3D(vt.x, vt.z, -vt.y));
		}
		return result;
	}

	function get_indices():Array<TriangleVertexIndices>{
		var result:Array<TriangleVertexIndices>=new Array<TriangleVertexIndices>();

		//TODO:
		//var ids:Array<UInt>=_mesh.geometry.subGeometries[0].indexData;
		//for(var i:uint=0;i<ids.length;i+=3){
		//	result.push(new TriangleVertexIndices(ids[i],ids[i+1],ids[i+2]));
		//}
		var ids:Array<Face> = _model.data.faces;
		for (i in 0...ids.length)
		{
			var f:Face = ids[i];
			result.push(new TriangleVertexIndices(f.geomIdx[0], f.geomIdx[1], f.geomIdx[2]));
		}
		return result;
	}
}