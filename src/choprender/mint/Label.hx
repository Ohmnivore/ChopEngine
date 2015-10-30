package choprender.mint;

import choprender.text.loader.FontBuilderNGL;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.text.Text;
import choprender.text.loader.FontBuilderNGL.Font;
import chop.util.Color;
import chop.group.Group;

private typedef ChopMintLabelOptions = {
    var color: Color;
    var color_hover: Color;
	var group: Group;
	var font: Font;
}

class Label extends mint.render.Render {

    public var label : mint.Label;
    public var text : Text;

    public var color_hover: Color;
    public var color: Color;

    var render: ChopMintRender;

    public function new( _render:ChopMintRender, _control:mint.Label ) {

        label = _control;
        render = _render;

        super(render, _control);

        var _opt: ChopMintLabelOptions = label.options.options;

        color = Convert.def(_opt.color, Color.fromRGB(0xffffff));
        color_hover = Convert.def(_opt.color_hover, Color.fromRGB(0x9dca63));
		_opt.group = Convert.def(_opt.group, control.parent._options_.options.group);

        //text = new luxe.Text({
            //name: control.name+'.text',
            //batcher: render.options.batcher,
            //bounds: new luxe.Rectangle(control.x, control.y, control.w, control.h),
            //color: color,
            //text: label.text,
            //bounds_wrap: label.options.bounds_wrap,
            //align: Convert.text_align(label.options.align),
            //align_vertical: Convert.text_align(label.options.align_vertical),
            //point_size: label.options.text_size,
            //depth: render.options.depth + control.depth,
            //group: render.options.group,
            //visible: control.visible,
        //});
		
		var f:FontBuilderNGL = new FontBuilderNGL();
		f.loadFile("assets/font/04b03_regular_8.xml");
		
		text = new Text(f.font);
		text.mat.useShading = false;
		text.pos.x = Convert.coord(control.x);
		text.pos.y = Convert.coordY(control.y);
		//text.setSize(Convert.coord(control.w), Convert.coord(control.h));
		text.textWidth = cast control.w;
		//text.mat.diffuseColor.copy(color);
		text.mat.transparency = 0.99;
		text.pos.z = Convert.coordZ(render.options.depth + control.depth - 0.999);
		text.visible = control.visible;
		text.setText(label.text, Convert.coord(label.options.text_size));
		_opt.group.add(text);
trace("label", control.x, control.y, control.w, control.h);
trace("labeld", render.options.depth, control.depth, render.options.depth + control.depth);
        //text.clip_rect = Convert.bounds(control.clip_with);

        label.onchange.listen(ontext);

        //control.onmouseenter.listen(function(e,c){ text.color = color_hover; });
        //control.onmouseleave.listen(function(e,c){ text.color = color; });

    }

    override function onbounds() {
        //text.bounds = new luxe.Rectangle(control.x, control.y, control.w, control.h);
		text.pos.x = Convert.coord(control.x);
		text.pos.y = Convert.coordY(control.y);
		//text.setSize(Convert.coord(control.w), Convert.coord(control.h));
    }

    function ontext(_text:String) {
        //text.text = _text;
		text.setText(_text, Convert.coord(label.options.text_size));
		text.pos.x = Convert.coord(control.x);
		text.pos.y = Convert.coordY(control.y);
		//text.setSize(Convert.coord(control.w), Convert.coord(control.h));
    }

    override function ondestroy() {
        label.onchange.remove(ontext);

        text.destroy();
        text = null;
    }

    override function onclip(_disable:Bool, _x:Float, _y:Float, _w:Float, _h:Float) {
        //if(_disable) {
            //text.clip_rect = null;
        //} else {
            //text.clip_rect = new luxe.Rectangle(_x, _y, _w, _h);
        //}
    } //onclip


    override function onvisible( _visible:Bool ) {
        text.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        //text.depth = render.options.depth + _depth;
		trace(render.options.depth, _depth);
        text.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Label
