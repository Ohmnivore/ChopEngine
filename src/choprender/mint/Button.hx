package choprender.mint;

import chop.math.Vec4;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintButtonOptions = {
    var color: Color;
    var color_hover: Color;
    var color_down: Color;
}

class Button extends mint.render.Render {

    public var button : mint.Button;
    public var visual : QuadModel;

    public var color: Color;
    public var color_hover: Color;
    public var color_down: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Button ) {

        render = _render;
        button = _control;

        super(render, _control);

        var _opt: ChopMintButtonOptions = button.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x373737));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x445158));
        color_down = Convert.def(_opt.color_down, Color.fromRGB(0x444444));

        //visual = new luxe.Sprite({
            //name: control.name+'.visual',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(control.x, control.y),
            //size: new Vector(control.w, control.h),
            //color: color,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
        //});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		visual.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(visual);
		
		visual.clip = Convert.bounds(control.clip_with);

        button.onmouseenter.listen(function(e,c) { visual.mat.diffuseColor.copy(color_hover); });
        button.onmouseleave.listen(function(e,c) { visual.mat.diffuseColor.copy(color); });
        button.onmousedown.listen(function(e,c) { visual.mat.diffuseColor.copy(color_down); });
        button.onmouseup.listen(function(e,c) { visual.mat.diffuseColor.copy(color_hover); });
    } //new

    override function onbounds() {

		visual.pos.x = Convert.coordX(control.x);
		visual.pos.y = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		
    } //onbounds
	
	override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        if(_disable) {
            visual.clip = null;
        } else {
            visual.clip = Vec4.fromValues(_x, _y, _w, _h);
        }
    } //onclip

    override function ondestroy() {

        visual.destroy();
        visual = null;

    } //ondestroy

    override function onvisible( _visible:Bool ) {

        visual.visible = _visible;

    } //onvisible

    override function ondepth( _depth:Float ) {

		visual.pos.z = Convert.coordZ(render.options.depth + _depth);

    } //ondepth


} //Button
