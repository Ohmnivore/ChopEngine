package;
import chop.gen.Game;
import lime.ui.KeyModifier;

import chop.gen.State;
import chop.gen.Global;
import lime.ui.KeyCode;
import chop.render3d.Camera;
import lime.app.Application;
import lime.graphics.opengl.GL;
import lime.graphics.RenderContext;

/**
 * ...
 * @author Ohmnivore
 */
class LimeMain extends Application 
{
	public var game:Game;
	private var goRight:Bool = false;
	private var goLeft:Bool = false;
	private var goForward:Bool = false;
	private var goBackward:Bool = false;
	private var checked:Bool = false;
	
	public function new() 
	{
		super();
	}
	
	public override function init(context:RenderContext):Void 
	{
		//this.config.antialiasing = 8;
		//config
	}
	
	override public function update(deltaTime:Int):Void 
	{
		if (!checked)
		{
			game = new Game(new PlayState());
			checked = true;
		}
		
		super.update(deltaTime);
		
		var deltaS:Float = 1.0 / deltaTime;
		game.update(deltaS);
		
		if (goRight)
			Global.cam.pos.x -= 5.0 * deltaS;
		if (goLeft)
			Global.cam.pos.x += 5.0 * deltaS;
		if (goForward)
			Global.cam.pos.y += 5.0 * deltaS;
		if (goBackward)
			Global.cam.pos.y -= 5.0 * deltaS;
	}
	
	public override function render(context:RenderContext):Void 
	{
		if (checked)
			game.draw(0.016);
	}
	
	override public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyDown(keyCode, modifier);
		
		if (keyCode == KeyCode.A)
			goRight = true;
		if (keyCode == KeyCode.D)
			goLeft = true;
		if (keyCode == KeyCode.W)
			goForward = true;
		if (keyCode == KeyCode.S)
			goBackward = true;
	}
	
	override public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void 
	{
		super.onKeyUp(keyCode, modifier);
		
		if (keyCode == KeyCode.A)
			goRight = false;
		if (keyCode == KeyCode.D)
			goLeft = false;
		if (keyCode == KeyCode.W)
			goForward = false;
		if (keyCode == KeyCode.S)
			goBackward = false;
	}
}
