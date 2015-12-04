# Building
* dependencies: flow, snow, mint, snow binaries (http://build.luxeengine.com/snow/), Haxe 3.2.1, hxcpp 3.2.193, (all of these were last updated on December 1 2015)
* you have to change your flow config to **files_output_list: true**, ChopEngine relies on that for its preloader
* then build as usual with flow: **flow run [platform]**
* the prime targets are windows, linux, and mac
* nothing keeps it from running on mobile and web, but I want to concentrate on the desktop targets first

# TODO

## Mint rendering
* handle ondestroy
* textedit cursor -> get coords of character at index
* mint valign text

## Rendering (eventually)
* Skeletal animation
* Batching
* Instancing
* Particle effects
* Static shadows -> shadow system
* Dynamic shadows -> shadow system

##### Lights
* Pass through bool -> shadow system
* Cast shadow bool -> shadow system
* Add an angle-based falloff to the cone light to smooth it out

##### Material support
* bool shadowsCast -> shadow system
* bool shadowsReceive -> shadow system

## Physics
* jiglibhx integration

## Input
* justPressed
* justReleased
* touch support for mobile
* controller support

## Audio
* Positional audio
* Music tracks

## Misc
* Game saves
