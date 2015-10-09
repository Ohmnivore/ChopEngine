package chop.gen;

/**
 * ...
 * @author Ohmnivore
 */
class Basic
{
	public var id:Int;
	public var active:Bool;
	public var alive:Bool;
	public var visible:Bool;
	
	public function new() 
	{
		id = 0;
		active = true;
		alive = true;
		visible = true;
	}
	
	static public function copy(D:Basic, S:Basic):Void
	{
		D.id = S.id;
		D.active = S.active;
		D.alive = S.alive;
		D.visible = S.visible;
	}
	
	public function draw(Elapsed:Float):Void
	{
		
	}
	
	public function update(Elapsed:Float):Void
	{
		
	}
	
	public function kill():Void
	{
		
	}
	
	public function revive():Void
	{
		
	}
	
	public function destroy():Void
	{
		
	}
}