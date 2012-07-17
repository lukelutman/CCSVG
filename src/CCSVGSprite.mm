#import "CCSVGCache.h"
#import "CCSVGSprite.h"
#import "CCSVGSource.h"

#include <MonkVG/openvg.h>
#include <MonkVG/vgu.h>
#include <MonkSVG/mkSVG.h>
#include <MonkSVG/mkOpenVG_SVG.h>



#pragma mark

@implementation CCSVGSprite


#pragma mark

@synthesize source = source_;


#pragma mark

+ (id)spriteWithFile:(NSString *)name {
    return [[[self alloc] initWithFile:name] autorelease];
}

+ (id)spriteWithSource:(CCSVGSource *)source {
    return [[[self alloc] initWithSource:source] autorelease];
}

- (id)initWithFile:(NSString *)name {
    return [self initWithSource:[[CCSVGCache sharedSVGCache] addFile:name]];
}

- (id)initWithSource:(CCSVGSource *)source {
    if ((self = [super init])) {
        self.anchorPoint = ccp(-source.contentRect.origin.x / source.contentRect.size.width, 
                               -source.contentRect.origin.y / source.contentRect.size.height);
        self.contentSize = source.contentSize;
        self.source = source;
    }
    return self;
}

- (void)dealloc {
    [source_ release];
    [super dealloc];
}


#pragma mark

- (void)draw {
    
    // skip drawing if the sprite has no source
    if (!self.source) {
        return;
    }
    
    // disable default states
    CC_DISABLE_DEFAULT_GL_STATES();
    
    // disable blending
    if (self.source.hasTransparentColors == NO) {
        glDisable(GL_BLEND);
    }
    
    // transform
    CGAffineTransform transform;
    transform = CGAffineTransformIdentity;
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(1.0f, -1.0f));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0.0f, self.contentSize.height));
    transform = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR()));
    transform = CGAffineTransformConcat(transform, self.nodeToWorldTransform);
    
    // matrix
    VGfloat matrix[9] = {
        transform.a, transform.c, transform.tx, // a, c, tx
        transform.b, transform.d, transform.ty, // b, d, ty
        0, 0, 1,                                // 0, 0, 1
    };
    vgLoadMatrix(matrix);
    
    // draw
    [self.source draw];
    
    // clear the transform used for drawing the swf
    glLoadIdentity(); 
    
    // apply the transform used for drawing children
    [self transformAncestors];
    
    // enable blending
    if (self.source.hasTransparentColors == NO) {
        glEnable(GL_BLEND);
    }
    
    // enable default states
    CC_ENABLE_DEFAULT_GL_STATES();
    
}


@end
