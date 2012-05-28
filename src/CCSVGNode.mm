#import "CCSVGCache.h"
#import "CCSVGNode.h"
#import "CCSVGSource.h"

#include <vg/openvg.h>
#include <vg/vgu.h>
#include <mkSVG.h>
#include <openvg/mkOpenVG_SVG.h>



#pragma mark

@implementation CCSVGNode


#pragma mark

@synthesize source = source_;


#pragma mark

- (id)initWithFile:(NSString *)name {
    if ((self = [super init])) {
        self.source = [[CCSVGCache sharedSVGCache] addFile:name];
    }
    return self;
}

+ (id)nodeWithFile:(NSString *)name {
    return [[[self alloc] initWithFile:name] autorelease];
}

- (void)dealloc {
    [source_ release];
    [super dealloc];
}


#pragma mark

- (void)draw {
    
    // disable states
    CC_DISABLE_DEFAULT_GL_STATES();
    
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
    
    // default states
    CC_ENABLE_DEFAULT_GL_STATES();
    
}


@end
