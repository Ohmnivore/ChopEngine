# Building
* dependencies: flow, snow, mint, snow binaries (http://build.luxeengine.com/snow/), Haxe 3.2.1, hxcpp 3.2.193, (all of these were last updated on December 1 2015)
* you have to change your flow config to **files_output_list: true**, ChopEngine relies on that for its preloader
* then build as usual with flow: **flow run [platform]**
* the prime targets are windows, linux, and mac
* nothing keeps it from running on mobile and web, but I want to concentrate on the desktop targets first

# TODO

## Mint rendering
* textedit cursor -> get coords of character at index

## Rendering
* destructors for all classes that allocate OpenGL resources
* Skeletal animation
* Batching
* Instancing
* Particle effects

##### Shadow system
* Static shadows
* Dynamic shadows
* Light Pass through bool
* Light Cast shadow bool
* Material bool shadowsCast
* Material bool shadowsReceive

## Physics
* jiglibhx integration

## Input
* mouse
* pressed
* justPressed
* justReleased

## Audio
* Positional audio
* Music tracks
