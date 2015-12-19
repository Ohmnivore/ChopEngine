package chopengine.phys;

import chop.math.Vec4;
import choprender.model.Model;
import choprender.model.QuadModel;
import jiglib.math.Matrix3D;
import jiglib.math.Vector3D;

import jiglib.geometry.JBox;
import jiglib.geometry.JPlane;
import jiglib.geometry.JSphere;
import jiglib.geometry.JTerrain;
import jiglib.geometry.JTriangleMesh;
import jiglib.physics.RigidBody;
import jiglib.plugin.AbstractPhysics;

class PhysState extends AbstractPhysics
{
	public function new(speed:Float = 1.0)
	{
		super(speed);
	}

	public function getModel(body:RigidBody):Model
	{
		if (body.skin != null)
			return cast(body.skin, PhysModel).mesh;
		else
			return null;
	}

	public function createGround(Ground:QuadModel):RigidBody
	{
		var jGround:JPlane = new JPlane(new PhysModel(Ground), new Vector3D(0, 1, 0));
		jGround.movable = false;
		addBody(jGround);
		return jGround;
	}

	public function createCube(Cube:Model, Size:Float):RigidBody
	{
		var jBox:JBox = new JBox(new PhysModel(Cube), Size, Size, Size);
		jBox.currentState.position.x = Cube.pos.x;
		jBox.currentState.position.y = Cube.pos.y;
		jBox.currentState.position.z = Cube.pos.z;
		addBody(jBox);
		return jBox;
	}

	//public function createSphere(sphereprim:Sphere, material:MeshMaterial, radius:Float = 50):RigidBody
	//{
		//var sphere:Mesh = new Mesh(sphereprim, material, parent);
		//sphere.scale(radius);
		//
		//var jsphere:JSphere = new JSphere(new HeapsMesh(sphere), radius);
		//addBody(jsphere);
		//return jsphere;
	//}

	//public function createTerrain(material:MeshMaterial, heightMap:BitmapData,
		//width:Float = 1000, height:Float = 100, depth:Float = 1000,
		//segmentsW:UInt = 30, segmentsH:UInt = 30, maxElevation:UInt = 255, minElevation:UInt = 0):JTerrain
	//{
		//var terrainMap:HeapsTerrain = new HeapsTerrain(heightMap, width, height, depth, segmentsW, segmentsH, maxElevation, minElevation);
		//terrainMap.unindex();
		//terrainMap.addNormals();
		//var terrainMesh:Mesh = new Mesh(terrainMap, material, parent);
		//
		//var terrain:JTerrain = new JTerrain(terrainMap);
		//addBody(terrain);
		//return terrain;
	//}

	/*
	public function createMesh(skin:Mesh,initPosition:Vector3D,initOrientation:Matrix3D,maxTrianglesPerCell:int = 10, minCellSize:Float = 10):JTriangleMesh{
		var mesh:JTriangleMesh=new JTriangleMesh(new Away3D4Mesh(skin),initPosition,initOrientation,maxTrianglesPerCell,minCellSize);
		addBody(mesh);

		return mesh;
	}
	*/
}
