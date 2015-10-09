package;

import chopengine.gen.Game;
import choprender.render3d.opengl.GL;
import choprender.render3d.opengl.ChopGL;
import snow.types.Types;

@:log_as('app')
class Main extends snow.App 
{
	public var game:Game;
	
    override function config(config:AppConfig):AppConfig 
    {
        config.window.title = 'ChopEngine';
		config.window.width = 960;
		config.window.height = 640;
        return config;
    }

    override function ready() 
    {
		game = new Game(new PlayState());
        app.window.onrender = render;
    }

    override function onkeyup(keycode:Int, _,_, mod:ModState, _,_) 
    {
        if( keycode == Key.escape ) 
        {
            app.shutdown();
        }
    }

    override function update(delta:Float)
    {
		game.update(delta);
    }

    function render(window:snow.system.window.Window) 
    {
		GL.disable(GL.BLEND);
		
		game.draw(delta_time);
		
		GL.enable(GL.BLEND);
        GL.blendFunc(GL.SRC_ALPHA, GL.ONE_MINUS_SRC_ALPHA);
		var b:GLFramebuffer = new GLFramebuffer(0);
		GL.bindFramebuffer(GL.FRAMEBUFFER, b);
		GL.bindFramebuffer(ChopGL.READ_FRAMEBUFFER, b);
		GL.bindFramebuffer(ChopGL.DRAW_FRAMEBUFFER, b);
		GL.enableVertexAttribArray(0);
		GL.enableVertexAttribArray(1);
		GL.enableVertexAttribArray(2);
		GL.enableVertexAttribArray(3);
    }
}