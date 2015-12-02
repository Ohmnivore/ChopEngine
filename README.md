# Building
* dependencies: flow, snow, mint, snow binaries (http://build.luxeengine.com/snow/), Haxe 3.2.1, hxcpp 3.2.193, (all of these were last updated on December 1 2015)
* you have to change your flow config to **files_output_list: true**, ChopEngine relies on that for its preloader
* then build as usual with flow: **flow run [platform]**
* the prime targets are windows, linux, and mac
* nothing keeps it from running on mobile and web, but I want to concentrate on the desktop targets first

# TODO

## Mint rendering
* image cover sizing
* handle ondestroy
* textedit cursor
* mint halign text right/center/left
* mint valign text top/center/bottom

## Text rendering
* Text line right/center/left align

## Rendering (eventually)
* Skeletal animation
* Fix broken face normals in chopmesh files
* Batching
* Instancing
* Cubemap sky
* Particle effects

* Static shadows
* Dynamic shadows

##### Lights
* Pass through bool
* Cast shadow bool
* Add an angle-based falloff to the cone light to smooth it out

##### Material support
* bool shadowsCast
* bool shadowsReceive

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
