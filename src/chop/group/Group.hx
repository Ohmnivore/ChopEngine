package chop.group;

import chop.gen.Basic;

typedef Group = TypedGroup<Basic>;

/**
 * ...
 * @author Ohmnivore
 */
class TypedGroup<T:Basic> extends Basic
{
	public var members:Array<T>;
	
	public function new() 
	{
		super();
		members = [];
	}
	
	public function add(O:T):Void
	{
		members.push(O);
	}
	
	public function remove(O:T):Void
	{
		members.remove(O);
	}
	
	public function clear():Void
	{
		members = [];
	}
	
	override public function update(Elapsed:Float):Void 
	{
		for (m in members)
		{
			m.update(Elapsed);
		}
	}
	
	override public function draw(Elapsed:Float):Void 
	{
		for (m in members)
		{
			m.draw(Elapsed);
		}
	}
}