package choprender.mint;

import glm.Vec4;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.model.QuadModel;
import chop.util.Color;
import chop.group.Group;

private typedef ChopMintDropdownOptions = {
    var color: Color;
    var color_border: Color;
}

class Dropdown extends mint.render.Render {

    public var dropdown : mint.Dropdown;
    public var visual : QuadModel;
    public var border : QuadModel;

    public var color: Color;
    public var color_border: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Dropdown ) {

        dropdown = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintDropdownOptions = dropdown.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x373737));
        color_border = Convert.def(_opt.color_border, Color.fromRGB(0x121212));

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
		visual.pos.x = Convert.coordX(control.x + 1);
		visual.pos.y = Convert.coordY(control.y + 1);
		visual.setSize(Convert.coord(control.w - 2), Convert.coord(control.h - 2));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth + 1);
		visual.visible = control.visible;
		visual.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(visual);

        //border = Luxe.draw.rectangle({
            //id: control.name+'.border',
            //batcher: render.options.batcher,
            //x: control.x,
            //y: control.y,
            //w: control.w,
            //h: control.h,
            //color: color_border,
            //depth: render.options.depth + control.depth+0.001,
            //group: render.options.group,
            //visible: control.visible,
            //clip_rect: Convert.bounds(control.clip_with)
        //});
		border = new QuadModel();
		border.mat.useShading = false;
		border.pos.x = Convert.coordX(control.x);
		border.pos.y = Convert.coordY(control.y);
		border.setSize(Convert.coord(control.w), Convert.coord(control.h));
		border.mat.diffuseColor.copy(color_border);
		border.pos.z = Convert.coordZ(render.options.depth + control.depth);
		border.visible = control.visible;
		border.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(border);
		
		visual.clip = Convert.bounds(control.clip_with);
		border.clip = Convert.bounds(control.clip_with);

    } //new

    override function ondestroy() {
        visual = null;
        border = null;
    }

    override function onbounds() {
		visual.pos.x = Convert.coordX(control.x + 1);
		visual.pos.y = Convert.coordY(control.y + 1);
		visual.setSize(Convert.coord(control.w - 2), Convert.coord(control.h - 2));
		
		border.pos.x = Convert.coordX(control.x);
		border.pos.y = Convert.coordY(control.y);
		border.setSize(Convert.coord(control.w), Convert.coord(control.h));
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
    }

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth + 1);
		border.pos.z = Convert.coordZ(render.options.depth + _depth);
    }


} //Dropdown
