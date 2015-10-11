package choprender.model.data;

import chop.math.Vec2;
import chop.math.Vec4;
import choprender.render3d.opengl.GL.Uint8Array;
import snow.api.buffers.ArrayBufferIO;

/**
 * ...
 * @author Ohmnivore
 */
class Bitmap
{
	public var pixels:Uint8Array;
	public var width:Int;
	public var height:Int;
	
	public function new() 
	{
		pixels = new Uint8Array([]);
		width = 0;
		height = 0;
	}
	
	public function copy(B:Bitmap):Void
	{
		pixels = new Uint8Array(B.pixels);
		width = B.width;
		height = B.height;
	}
	
	public function setSize(Width:Int, Height:Int):Void
	{
		var newSize:Int = Width * Height;
		var oldSize:Int = width * height;
		if (newSize > oldSize)
		{
			var newArr:Uint8Array = new Uint8Array(newSize * 4);
			for (y in 0...height)
			{
				for (x in 0...width)
				{
					var p:Array<Int> = getPixel(x, y);
					
					var id:Int = x * 4 + y * Width * 4;
					ArrayBufferIO.setUint8(newArr.buffer, id, p[0]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 1, p[1]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 2, p[2]);
					ArrayBufferIO.setUint8(newArr.buffer, id + 3, p[3]);
					
				}
			}
			pixels = newArr;
		}
		width = Width;
		height = Height;
	}
	
	public function getPixel(X:Int, Y:Int):Array<Int>
	{
		var id:Int = X * 4 + Y * width * 4;
		return [
			ArrayBufferIO.getUint8(pixels.buffer, id),
			ArrayBufferIO.getUint8(pixels.buffer, id + 1),
			ArrayBufferIO.getUint8(pixels.buffer, id + 2),
			ArrayBufferIO.getUint8(pixels.buffer, id + 3)
		];
	}
	
	public function setPixel(X:Int, Y:Int, Arr:Array<Int>):Void
	{
		var id:Int = X * 4 + Y * width * 4;
		ArrayBufferIO.setUint8(pixels.buffer, id, Arr[0]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 1, Arr[1]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 2, Arr[2]);
		ArrayBufferIO.setUint8(pixels.buffer, id + 3, Arr[3]);
	}
	
	public function copyPixels(Source:Bitmap, Dest:Bitmap, SourceRect:Vec4, DestPoint:Vec2):Void
	{
		for (y in 0...cast SourceRect[3])
		{
			for (x in 0...cast SourceRect[2])
			{
				var p:Array<Int> = Source.getPixel(cast SourceRect[0] + x, cast SourceRect[1] + y);
				Dest.setPixel(cast DestPoint.x + x, cast DestPoint.y + y, p);
			}
		}
	}
}