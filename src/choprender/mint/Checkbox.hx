package choprender.mint;

import chop.group.Group;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;

private typedef ChopMintCheckboxOptions = {
    var color: Color;
    var color_hover: Color;
    var color_node: Color;
    var color_node_hover: Color;
	var group:Group;
}

class Checkbox extends mint.render.Render {

    public var checkbox : mint.Checkbox;
    public var visual : QuadModel;
    public var node : QuadModel;
    public var node_off : QuadModel;

    public var color: Color;
    public var color_hover: Color;
    public var color_node: Color;
    public var color_node_hover: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Checkbox ) {

        checkbox = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintCheckboxOptions = checkbox.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x373737));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x445158));
        color_node = Convert.def(_opt.color_node, Color.fromRGB(0x9dca63));
        color_node_hover = Convert.def(_opt.color_node_hover, Color.fromRGB(0xadca63));

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
		visual.pos.x = Convert.coord(control.x);
		visual.pos.z = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		visual.mat.diffuseColor.copy(color);
		visual.pos.y = Convert.coordZ(render.options.depth + control.depth);
		visual.visible = control.visible;
		_opt.group.add(visual);

        //node_off = new luxe.Sprite({
            //name: control.name+'.node_off',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(control.x+4, control.y+4),
            //size: new Vector(control.w-8, control.h-8),
            //color: color_node.clone().set(null,null,null,0.25),
            //depth: render.options.depth + control.depth + 0.001,
            //group: render.options.group,
            //visible: control.visible
        //});
		node_off = new QuadModel();
		node_off.mat.useShading = false;
		node_off.pos.x = Convert.coord(control.x + 4);
		node_off.pos.z = Convert.coordY(control.y + 4);
		node_off.setSize(Convert.coord(control.w - 8), Convert.coord(control.h - 8));
		node_off.mat.diffuseColor.set(0, 0, 0);
		node_off.pos.y = Convert.coordZ(render.options.depth + control.depth + 0.001);
		node_off.visible = control.visible;
		_opt.group.add(node_off);

        //node = new luxe.Sprite({
            //name: control.name+'.node_on',
            //batcher: render.options.batcher,
            //centered: false,
            //pos: new Vector(control.x+4, control.y+4),
            //size: new Vector(control.w-8, control.h-8),
            //color: color_node,
            //depth: render.options.depth + control.depth + 0.002,
            //group: render.options.group,
            //visible: control.visible && checkbox.state
        //});
		node = new QuadModel();
		node.mat.useShading = false;
		node.pos.x = Convert.coord(control.x + 4);
		node.pos.z = Convert.coordY(control.y + 4);
		node.setSize(Convert.coord(control.w - 8), Convert.coord(control.h - 8));
		node.mat.diffuseColor.copy(color_node);
		node.pos.y = Convert.coordZ(render.options.depth + control.depth + 0.002);
		node.visible = control.visible && checkbox.state;
		_opt.group.add(node);
		
		//visual.pos.y = -0.1;
		//node_off.pos.y = -0.1;
		//node.pos.y = -0.1;

        //visual.clip_rect = Convert.bounds(control.clip_with);
        //node_off.clip_rect = Convert.bounds(control.clip_with);
        //node.clip_rect = Convert.bounds(control.clip_with);

        //checkbox.onmouseenter.listen(function(e,c) { node.color = color_node_hover; visual.color = color_hover; });
        //checkbox.onmouseleave.listen(function(e,c) { node.color = color_node; visual.color = color; });
		checkbox.onmouseenter.listen(function(e, c) {
			node.mat.diffuseColor.copy(color_node_hover);
			visual.mat.diffuseColor.copy(color_hover);
		});
		checkbox.onmouseleave.listen(function(e, c) {
			node.mat.diffuseColor.copy(color_node);
			visual.mat.diffuseColor.copy(color);
		});

        checkbox.onchange.listen(oncheck);

    } //new

    function oncheck(_new:Bool, _old:Bool) {
        node.visible = _new;

    } //oncheck

    override function onbounds() {

        //visual.transform.pos.set_xy(control.x, control.y);
        //visual.geometry_quad.resize_xy( control.w, control.h );
        //node_off.transform.pos.set_xy(control.x+4, control.y+4);
        //node_off.geometry_quad.resize_xy( control.w-8, control.h-8 );
        //node.transform.pos.set_xy(control.x+4, control.y+4);
        //node.geometry_quad.resize_xy( control.w-8, control.h-8 );
		visual.pos.x = Convert.coord(control.x);
		visual.pos.z = Convert.coordY(control.y);
		visual.setSize(Convert.coord(control.w), Convert.coord(control.h));
		node_off.pos.x = Convert.coord(control.x + 4);
		node_off.pos.z = Convert.coordY(control.y + 4);
		node_off.setSize(Convert.coord(control.w - 8), Convert.coord(control.h - 8));
		node.pos.x = Convert.coord(control.x + 4);
		node.pos.z = Convert.coordY(control.y + 4);
		node.setSize(Convert.coord(control.w - 8), Convert.coord(control.h - 8));

    } //onbounds

    override function ondestroy() {

        visual.destroy();
        node_off.destroy();
        node.destroy();

        visual = node = node_off = null;

    } //ondestroy

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {

        //if(_disable) {
            //visual.clip_rect = node_off.clip_rect = node.clip_rect = null;
        //} else {
            //visual.clip_rect = node_off.clip_rect = node.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        //}

    } //onclip

    override function onvisible( _visible:Bool ) {

        visual.visible = node_off.visible = _visible;

        if(_visible) {
            if(checkbox.state) node.visible = _visible;
        } else {
            node.visible = _visible;
        }

    } //onvisible

    override function ondepth( _depth:Float ) {

        //visual.depth = render.options.depth + _depth;
        //node_off.depth = visual.depth + 0.001;
        //node.depth = visual.depth + 0.002;
		trace("depth", render.options.depth, _depth, render.options.depth + _depth);
		//visual.pos.y = Convert.coordZ(render.options.depth + _depth);
		//node_off.pos.y = Convert.coordZ(visual.pos.y + 0.001);
		//node.pos.y = Convert.coordZ(visual.pos.y + 0.002);

    } //ondepth


} //Checkbox
