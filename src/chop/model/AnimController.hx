package chop.model;

import chop.model.data.Animation;
import chop.model.data.Frame;
import chop.model.data.ModelData;
import chop.model.data.Vertex;
import model.data.*;

/**
 * ...
 * @author Ohmnivore
 */
class AnimController
{
	public var data:ModelData;
	public var vertices:Array<Vertex>;
	
	public var curAnim:Animation;
	public var curFrame:Frame;
	public var looping:Bool;
	public var elapsed:Float;
	
	
	public function new() 
	{
		data = null;
		vertices = [];
		curAnim = null;
		curFrame = null;
		looping = true;
		elapsed = 0.0;
	}
	
	public function update(Sec:Float):Void
	{
		elapsed += Std.int(Sec * 1000);
		if (curAnim.frames.length > 1)
		{
			if (curFrame.id == curAnim.frames.length - 1 && looping)
			{
				var nextFrame:Frame = curAnim.frames[0];
				interpolateFrame(curFrame, nextFrame, getWeight(curFrame, nextFrame, Std.int(elapsed)));
				if (elapsed >= curAnim.length)
				{
					curFrame = nextFrame;
				}
				elapsed = 0;
			}
			else
			{
				if (curFrame.id != curAnim.frames.length - 1)
				{
					var nextFrame:Frame = curAnim.frames[curFrame.id + 1];
					interpolateFrame(curFrame, nextFrame, getWeight(curFrame, nextFrame, Std.int(elapsed)));
					if (elapsed >= nextFrame.time)
					{
						curFrame = nextFrame;
					}
				}
			}
		}
	}
	
	public function play(Name:String, Loop:Bool):Void
	{
		curAnim = data.anims.get(Name);
		looping = Loop;
		elapsed = 0;
		setFrame(curAnim.frames[0]);
	}
	
	public function setFrame(F:Frame):Void
	{
		curFrame = F;
		vertices = [];
		
		for (i in 0...curFrame.vertices.length)
		{
			var origV:Vertex = curFrame.vertices[i];
			var newV:Vertex = new Vertex();
			newV.copy(origV);
			vertices.push(newV);
		}
	}
	
	private function interpolateFrame(First:Frame, Second:Frame, Weight:Float):Void
	{
		vertices = [];
		
		for (i in 0...First.vertices.length)
		{
			var older:Vertex = First.vertices[i];
			var newer:Vertex = Second.vertices[i];
			var interp:Vertex = new Vertex();
			
			interp.tagID = newer.tagID;
			interp.x = interpolate(older.x, newer.x, Weight);
			interp.y = interpolate(older.y, newer.y, Weight);
			interp.z = interpolate(older.z, newer.z, Weight);
			interp.nx = interpolate(older.nx, newer.nx, Weight);
			interp.ny = interpolate(older.ny, newer.ny, Weight);
			interp.nz = interpolate(older.nz, newer.nz, Weight);
			vertices.push(interp);
		}
	}
	
	private function interpolate(First:Float, Second:Float, Weight:Float):Float
	{
		return (1.0 - Weight) * First + Weight * Second;
	}
	
	private function getWeight(First:Frame, Second:Frame, Elapsed:Int)
	{
		var delta:Float = Elapsed - First.time;
		var totalDelta:Float = Second.time - First.time;
		return delta / totalDelta;
	}
}