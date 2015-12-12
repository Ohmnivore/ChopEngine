package choprender.mint;

import glm.Vec2;
import glm.Vec4;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintTextEditOptions = {
    var color: Color;
    var color_hover: Color;
    var color_cursor: Color;
	@:optional var cursor_blink_rate: Float;
}

class TextEdit extends mint.render.Render {

    public var textedit : mint.TextEdit;
    public var visual : QuadModel;
    public var border : QuadModel;
    public var cursor : QuadModel;

    public var color: Color;
    public var color_hover: Color;
    public var color_cursor: Color;
	public var cursor_blink_rate: Float = 0.5;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.TextEdit ) {

        textedit = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintTextEditOptions = textedit.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x646469));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x444449));
        color_cursor = Convert.def(_opt.color_cursor, Color.fromRGB(0x9dca63));
		cursor_blink_rate = Convert.def(_opt.cursor_blink_rate, 0.5);

        //visual = Luxe.draw.box({
            //id: control.name+'.visual',
            //batcher: render.options.batcher,
            //x:control.x,
            //y:control.y,
            //w:control.w,
            //h:control.h,
            //color: color,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth + 1);
		visual.visible = control.visible;
		visual.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(visual);
		
		border = new QuadModel();
		border.mat.useShading = false;
		border.pos.x = Convert.coordX(control.x - 1);
		border.pos.y = Convert.coordY(control.y - 1);
		border.setSize(Convert.coord(control.w + 2), Convert.coord(control.h + 2));
		border.mat.diffuseColor.copy(color_cursor);
		border.pos.z = Convert.coordZ(render.options.depth + control.depth);
		border.visible = false;
		border.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(border);

        //cursor = Luxe.draw.line({
            //id: control.name+'.cursor',
            //batcher: render.options.batcher,
            //p0: new Vector(0,0),
            //p1: new Vector(0,0),
            //color: color_cursor,
            //depth: render.options.depth + control.depth+0.001,
            //visible: false,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		cursor = new QuadModel();
		cursor.mat.useShading = false;
		cursor.pos.x = 0;
		cursor.pos.y = 0;
		cursor.setSize(Convert.coord(2), Convert.coord(textedit.label.options.text_size));
		cursor.mat.diffuseColor.copy(color_cursor);
		cursor.pos.z = Convert.coordZ(render.options.depth + control.depth + 3);
		cursor.visible = false;
		cursor.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(cursor);
		
		visual.clip = Convert.bounds(control.clip_with);
		border.clip = Convert.bounds(control.clip_with);
		cursor.clip = Convert.bounds(control.clip_with);

        textedit.onmouseenter.listen(function(e,c) {
			visual.mat.diffuseColor.copy(color_hover);
        });

        textedit.onmouseleave.listen(function(e,c) {
			visual.mat.diffuseColor.copy(color);
        });

        textedit.onchangeindex.listen(function(index:Int) {
            update_cursor();
        });
		
		 textedit.ontextinput.listen(function(_,_) {
            if(textedit.isfocused || textedit.iscaptured) {
                SnowApp._snow.input.module.text_input_rect(Std.int(textedit.x),Std.int(textedit.y),Std.int(textedit.w),Std.int(textedit.h));
            }
        });
		
		textedit.onfocused.listen(function(isFocused:Bool) {
			if (isFocused)
			{
				start_cursor();
				if (visual.visible)
					border.visible = true;
				SnowApp._snow.input.module.text_input_start();
				SnowApp._snow.input.module.text_input_rect(Std.int(textedit.x),Std.int(textedit.y),Std.int(textedit.w),Std.int(textedit.h));
			}
			else
			{
				border.visible = false;
				stop_cursor();
				SnowApp._snow.input.module.text_input_stop();
                SnowApp._snow.input.module.text_input_rect(0,0,0,0);
			}
		});
		
		control.renderable = true;
		textedit.onrender.listen(function() {
			if (visual.visible)
				border.visible = textedit.isfocused;
		});
    } //new

    var timer: snow.api.Timer;
    function start_cursor() {
        cursor.visible = true;
        update_cursor();
		timer = new snow.api.Timer(cursor_blink_rate);
        timer.run = function(){blink_cursor();};
    }

    function stop_cursor() {
        if(timer != null) timer.stop();
        timer = null;
        cursor.visible = false;
    }

    function blink_cursor() {
        if(timer == null) return;
        cursor.visible = !cursor.visible;
    }
	
	inline function reset_cursor() {
        if(timer != null) {
            cursor.visible = true;
            timer.fire_at = SnowApp._snow.time + cursor_blink_rate;
        }
    }

    function update_cursor() {
		var text:choprender.text.Text = (cast textedit.label.renderer:choprender.mint.Label).text;
        var _t:String = textedit.before_display(textedit.index);
		var res:Vec2 = text.getPos(_t);
		res.multiplyScalar(textedit.label.options.text_size / text.font.size);
		cursor.pos.x = text.pos.x + Convert.coord(res.x);
		cursor.pos.y = text.pos.y - Convert.coord(res.y + 2);
		
        reset_cursor();
    }

    override function ondestroy() {
        stop_cursor();
        visual = null;
		border = null;
        cursor = null;
    }

    override function onbounds() {
        visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		border.pos.x = Convert.coordX(control.x - 1);
		border.pos.y = Convert.coordY(control.y - 1);
		border.setSize(Convert.coord(control.w + 2), Convert.coord(control.h + 2));
        reset_cursor();
    }
	
	override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip = border.clip = null;
        } else {
            visual.clip = border.clip = new Vec4(_x, _y, _w, _h);
        }
    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = border.visible = _visible;

        if(!_visible) {
            stop_cursor();
        } else if(_visible && textedit.isfocused) {
            start_cursor();
        }

    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth + 1);
		border.pos.z = Convert.coordZ(render.options.depth + _depth);
		cursor.pos.z = Convert.coordZ(render.options.depth + _depth + 2);
    } //ondepth

} //TextEdit
