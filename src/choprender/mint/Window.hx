package choprender.mint;

import chop.assets.Assets;
import choprender.render3d.Camera;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import chop.util.Color;
import choprender.model.QuadModel;
import chop.group.Group;

private typedef ChopMintWindowOptions = {
    var color: Color;
    var color_titlebar: Color;
    var color_border: Color;
    var color_collapse: Color;
}

class Window extends mint.render.Render {

    public var window : mint.Window;
    public var visual : QuadModel;
    public var top : QuadModel;
    public var collapse : QuadModel;
    public var border : QuadModel;

    public var color: Color;
    public var color_titlebar: Color;
    public var color_border: Color;
    public var color_collapse: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Window ) {

        window = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintWindowOptions = window.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0x242424));
        color_border = Convert.def(_opt.color_border, Color.fromRGB(0x373739));
        color_titlebar = Convert.def(_opt.color_titlebar, Color.fromRGB(0x373737));
        color_collapse = Convert.def(_opt.color_collapse, Color.fromRGB(0x666666));

        //visual = Luxe.draw.box({
            //id: control.name+'.visual',
            //batcher: render.options.batcher,
            //x:window.x,
            //y:window.y,
            //w:window.w,
            //h:window.h,
            //color: color,
            //depth: render.options.depth + window.depth,
            //group: render.options.group,
            //visible: window.visible,
            //clip_rect: Convert.bounds(window.clip_with)
        //});
		visual = new QuadModel();
		visual.mat.useShading = false;
		visual.pos.x = Convert.coordX(window.x + 1);
		visual.pos.y = Convert.coordY(window.y + 1);
		visual.setSize(Convert.coord(window.w - 2), Convert.coord(window.h - 2));
		visual.mat.diffuseColor.copy(color);
		visual.pos.z = Convert.coordZ(render.options.depth + window.depth);
		visual.visible = window.visible;
		visual.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(visual);

        //top = Luxe.draw.box({
            //id: control.name+'.top',
            //batcher: render.options.batcher,
            //x: window.title.x,
            //y:window.title.y,
            //w:window.title.w,
            //h:window.title.h,
            //color: color_titlebar,
            //depth: render.options.depth + window.depth+0.001,
            //group: render.options.group,
            //visible: window.visible,
            //clip_rect: Convert.bounds(window.clip_with)
        //});
		top = new QuadModel();
		top.mat.useShading = false;
		top.pos.x = Convert.coordX(window.title.x);
		top.pos.y = Convert.coordY(window.title.y);
		top.setSize(Convert.coord(window.title.w), Convert.coord(window.title.h));
		top.mat.diffuseColor.copy(color_titlebar);
		top.pos.z = Convert.coordZ(render.options.depth + window.depth + 1);
		top.visible = window.visible;
		top.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(top);

        //border = Luxe.draw.rectangle({
            //id: control.name+'.border',
            //batcher: render.options.batcher,
            //x: window.x,
            //y: window.y,
            //w: window.w+1,
            //h: window.h,
            //color: color_border,
            //depth: render.options.depth + window.depth+0.002,
            //group: render.options.group,
            //visible: window.visible,
            //clip_rect: Convert.bounds(window.clip_with)
        //});

        //collapse = Luxe.draw.ngon({
            //id: control.name+'.border',
            //batcher: render.options.batcher,
            //r: 5,
            //solid: true,
            //angle: 180,
            //sides: 3,
            //color: color_collapse,
            //depth: render.options.depth + window.depth+0.003,
            //group: render.options.group,
            //visible: window.collapsible,
            //clip_rect: Convert.bounds(window.clip_with)
        //});
		collapse = new QuadModel();
		collapse.mat.useShading = false;
		collapse.setSize(Convert.coord(14), Convert.coord(14));
		collapse.mat.diffuseColor.copy(color_collapse);
		collapse.pos.z = Convert.coordZ(render.options.depth + window.depth + 3);
		collapse.visible = window.collapsible;
		collapse.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(collapse);
		
		border = new QuadModel();
		border.mat.useShading = false;
		border.pos.x = Convert.coordX(window.x);
		border.pos.y = Convert.coordY(window.y);
		border.setSize(Convert.coord(window.w), Convert.coord(window.h));
		border.mat.diffuseColor.copy(color_border);
		border.pos.z = Convert.coordZ(render.options.depth + window.depth);
		border.visible = window.visible;
		border.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(border);

        var ch = window.collapse_handle;
		collapse.pos.x = Convert.coordX(ch.x + (ch.w - 14) / 2);
		collapse.pos.y = Convert.coordY(ch.y + (ch.h - 14) / 2);

        window.oncollapse.listen(oncollapse);

    } //new

    override function ondestroy() {

        visual = null;
        top = null;
        border = null;
        collapse = null;

    } //ondestroy

    override function onbounds() {
		visual.pos.x = Convert.coordX(window.x + 1);
		visual.pos.y = Convert.coordY(window.y + 1);
		visual.setSize(Convert.coord(window.w - 2), Convert.coord(window.h - 2));
		top.pos.x = Convert.coordX(window.title.x);
		top.pos.y = Convert.coordY(window.title.y);
		top.setSize(Convert.coord(window.title.w), Convert.coord(window.title.h));
		border.pos.x = Convert.coordX(window.x);
		border.pos.y = Convert.coordY(window.y);
		border.setSize(Convert.coord(window.w), Convert.coord(window.h));
		var ch = window.collapse_handle;
		collapse.pos.x = Convert.coordX(ch.x + (ch.w - 14.0) / 2.0);
		collapse.pos.y = Convert.coordY(ch.y + (ch.h - 14.0) / 2.0);
    }

    override function onvisible( _visible:Bool ) {
        visual.visible = _visible;
        top.visible = _visible;
        border.visible = _visible;
        collapse.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
		visual.pos.z = Convert.coordZ(render.options.depth + _depth + 1);
		top.pos.z = Convert.coordZ(render.options.depth + _depth + 2);
		border.pos.z = Convert.coordZ(render.options.depth + _depth);
		collapse.pos.z = Convert.coordZ(render.options.depth + _depth + 3);
    } //ondepth

    function oncollapse(state:Bool) {
		
    }

} //Window
