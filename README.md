CCSVG - Display SVG images on iOS using Cocos2D
===============================================


## Overview

CCSVG provides an API for loading, displaying and animating SVG images on iOS using Cocos2D. 


    // load an svg image
    CCSVGSource *source;
    source = [CCSVGSource sourceWithFile:@"player_idle.svg"];
    source.contentSize = CGSizeMake(128,128);

    // display an svg image
    CCSVGSprite *sprite;
    sprite = [CCSVGSprite spriteWithSource:source];
    sprite.position = ccp(240,160);

    // create an svg animation
    CCSVGAnimation *animation;
    animation = [CCSVGAnimation animationWithSourcesNamed:@"player_walk_%04d.svg" 
                                                    count:2 
                                                    delay:1.0/15.0];

    // run the animation on the sprite
    CCSVGAnimate *animate;
    animate = [CCSVGAnimate actionWithSVGAnimation:animation];
    [sprite runAction:[CCRepeatForever actionWithAction:animate]]; 


## Benefits

SVG images are displayed as vector data, not textures. Each file is tesselated and cached in a vertex buffer object, so the peformance penalty of tesselating and uploading the geometry to OpenGL only happens once when the file is first loaded.

* Resolution-independence.
* Smaller file size. 
* Smaller memory footprint.
* Faster load times.


## Drawbacks

There is a significant performance penalty for using images with transparent fills or strokes (drawing them properly means turning on blending in OpenGL). Avoid them where possible.

* Incomplete SVG support (see [what is implemented](https://github.com/micahpearlman/MonkVG/blob/master/README.md#what-is-implemented) in MonkVG).
* Antialiasing requires multisampling to be enabled, which has a performance penalty.


## Installation

    git clone git@github.com:lukelutman/CCSVG.git
    git submodule init
    git submodule update


## Dependencies

* [cocos2d-iphone v1.1.0-beta2b](https://github.com/cocos2d/cocos2d-iphone)
* [MonkVG](https://github.com/lukelutman/MonkVG) by [Micah Pearlman](https://github.com/micahpearlman)
* [MonkSVG](https://github.com/lukelutman/MonkSVG) by [Micah Pearlman](https://github.com/micahpearlman)

## Resources

* [flash2svg Extension](http://www.adobe.com/cfusion/exchange/index.cfm?event=extensionDetail&loc=en_us&extid=2422028) for exporting SVG images from Flash