package choprender.mint;

import choprender.render3d.Camera;
import choprender.text.Font;
import mint.types.Types;
import mint.render.Rendering;

import choprender.mint.ChopMintRender;
import choprender.mint.Convert;

import choprender.text.Text;
import chop.util.Color;
import chop.group.Group;

private typedef ChopMintLabelOptions = {
    var color: Color;
    var color_hover: Color;
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
		_opt.font = Convert.def(_opt.font, _control.canvas._options_.options.font);

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
		
		text = new Text(_opt.font);
		text.mat.useShading = false;
		text.pos.x = Convert.coordX(control.x);
		text.pos.y = Convert.coordY(control.y);
		text.pos.z = Convert.coordZ(render.options.depth + control.depth);
		text.visible = control.visible;
		text.mat.diffuseColor.copy(color);
		text.setMetrics(Text.WORD_WRAP, Convert.coord(label.options.text_size), Convert.coord(control.w));
		text.setText(label.text);
		text.cams = _control.canvas._options_.options.cams;
		_control.canvas._options_.options.group.add(text);

        label.onchange.listen(ontext);

        control.onmouseenter.listen(function(e,c){ text.mat.diffuseColor.copy(color_hover); });
        control.onmouseleave.listen(function(e,c){ text.mat.diffuseColor.copy(color); });

    }

    override function onbounds() {
		text.pos.x = Convert.coordX(control.x);
		text.pos.y = Convert.coordY(control.y);
    }

    function ontext(_text:String) {
		text.setMetrics(Text.WORD_WRAP, Convert.coord(label.options.text_size), Convert.coord(control.w));
		text.setText(_text);
		text.pos.x = Convert.coordX(control.x);
		text.pos.y = Convert.coordY(control.y);
    }

    override function ondestroy() {
        label.onchange.remove(ontext);

        text.destroy();
        text = null;
    }

    override function onvisible( _visible:Bool ) {
        text.visible = _visible;
    } //onvisible

    override function ondepth( _depth:Float ) {
        text.pos.z = Convert.coordZ(render.options.depth + _depth);
    } //ondepth

} //Label
