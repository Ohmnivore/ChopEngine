package choprender.mint;

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
	var group: Group;
	var cam: Camera;
}

class TextEdit extends mint.render.Render {

    public var textedit : mint.TextEdit;
    public var visual : QuadModel;
    //public var cursor : QuadModel;

    public var color: Color;
    public var color_hover: Color;
    public var color_cursor: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.TextEdit ) {

        textedit = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintTextEditOptions = textedit.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x646469));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x444449));
        color_cursor = Convert.def(_opt.color_cursor, Color.fromRGB(0x9dca63));

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
		visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		visual.cams = [_opt.cam];
		_opt.group.add(visual);

        //cursor = Luxe.draw.line({
            //id: control.name+'.cursor',
            //batcher: render.options.batcher,
            //p0: new Vector(0,0),
            //p1: new Vector(0,0),
            //color: color_cursor,
            //depth: render.options.depth + control.depth+0.001,
            //group: render.options.group,
            //visible: false,
            //clip_rect: Convert.bounds(control.clip_with)
        //});

        textedit.onmouseenter.listen(function(e,c) {
			visual.mat.diffuseColor.copy(color_hover);
            start_cursor();
        });

        textedit.onmouseleave.listen(function(e,c) {
			visual.mat.diffuseColor.copy(color);
            stop_cursor();
        });

        textedit.onchangeindex.listen(function(index:Int) {
            update_cursor();
        });

        textedit.onrender.listen(function() {

            //if(textedit.isfocused) {
                //Luxe.draw.rectangle({
                    //id: control.name+'.border',
                    //batcher: render.options.batcher,
                    //x:textedit.x,
                    //y:textedit.y,
                    //w:textedit.w,
                    //h:textedit.h,
                    //immediate: true,
                    //color: color_cursor,
                    //depth: render.options.depth+textedit.depth+0.001,
                    //group: render.options.group
                //});
            //}
        });

    } //new

    //var timer: snow.api.Timer;
    function start_cursor() {
        //cursor.visible = true;
        //update_cursor();
        //timer = Luxe.timer.schedule(0.5, blink_cursor, true);
    }

    function stop_cursor() {
        //if(timer != null) timer.stop();
        //timer = null;
        //cursor.visible = false;
    }

    function blink_cursor() {
        //if(timer == null) return;
        //cursor.visible = !cursor.visible;
    }

    function update_cursor() {

        //var text = (cast textedit.label.renderer:mint.render.luxe.Label).text;
        //var _t = textedit.before_display(textedit.index);
//
        //var _tw = text.font.width_of(textedit.edit, text.point_size, text.letter_spacing);
        //var _twh = _tw/2.0;
        //var _w = text.font.width_of(_t, text.point_size, text.letter_spacing);
//
        //var _th = text.font.height_of(_t, text.point_size);
        //var _thh = _th/2.0;
//
        //var _x = _w;
        //var _y = 0.0;
//
        //_x -= switch(text.align) {
            //case luxe.Text.TextAlign.center: _twh;
            //case luxe.Text.TextAlign.right: _tw;
            //case _: 0.0;
        //}
//
        //_y += _th * 0.2;
//
        //var _xx = textedit.label.x + _x;
        //var _yy = textedit.label.y + 2;
//
        //cursor.p0 = new Vector(_xx, _yy);
        //cursor.p1 = new Vector(_xx, _yy + textedit.label.h - 4);

    } //

    override function ondestroy() {
        stop_cursor();
        visual = null;
        //cursor = null;
    }

    override function onbounds() {
        visual.pos.x = Convert.coord(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
        //if(timer != null) {
            //stop_cursor(); start_cursor();
        //}
    }

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

        if(!_visible) {
            stop_cursor();
        } else if(_visible && textedit.isfocused) {
            start_cursor();
        }

    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //TextEdit
