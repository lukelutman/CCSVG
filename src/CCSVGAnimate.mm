#import "CCSVGAnimate.h"
#import "CCSVGAnimation.h"
#import "CCSVGSprite.h"
#import "CCSVGSource.h"


@implementation CCSVGAnimate


#pragma mark

@synthesize animation = animation_;


#pragma mark

+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation {
	return [[[self alloc] initWithSVGAnimation:animation restoreOriginalFrame:animation.restoreOriginalFrame] autorelease];
}

+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame {
	return [[[self alloc] initWithSVGAnimation:animation restoreOriginalFrame:restoreOriginalFrame] autorelease];
}

+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame duration:(ccTime)duration {
	return [[[self alloc] initWithSVGAnimation:animation restoreOriginalFrame:restoreOriginalFrame duration:duration] autorelease];
}

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation {
	NSAssert(animation != nil, @"Animate: argument Animation must be non-nil");
	return [self initWithSVGAnimation:animation restoreOriginalFrame:animation.restoreOriginalFrame];
}

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame {
	NSAssert(animation != nil, @"Animate: argument Animation must be non-nil");
	return [self initWithSVGAnimation:animation restoreOriginalFrame:restoreOriginalFrame duration:animation.duration];
}

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame duration:(ccTime)duration {
	NSAssert(animation != nil, @"Animate: argument Animation must be non-nil");
	
	if (( self = [super initWithDuration:duration])) {
		
		nextFrame_ = 0;
		restoreOriginalFrame_ = restoreOriginalFrame;
		self.animation = animation;
		origFrame_ = nil;
		
		splitTimes_ = [[NSMutableArray alloc] initWithCapacity:animation.frames.count];
		
		float accumUnitsOfTime = 0;
		float newUnitOfTimeValue = duration / animation.totalDelayUnits;
		
		for (CCSVGAnimationFrame *frame in animation.frames) {
			
			NSNumber *value = [NSNumber numberWithFloat: (accumUnitsOfTime * newUnitOfTimeValue) / duration];
			accumUnitsOfTime += frame.delayUnits;
			
			[splitTimes_ addObject:value];
		}		
	}
	return self;
}


- (id)copyWithZone: (NSZone*) zone {
	return [[[self class] allocWithZone: zone] initWithSVGAnimation:animation_ restoreOriginalFrame:restoreOriginalFrame_ duration:duration_];
}

- (void)dealloc {
	[splitTimes_ release];
	[animation_ release];
	[origFrame_ release];
	[super dealloc];
}


#pragma mark

- (void)startWithTarget:(id)aTarget {
    
	[super startWithTarget:aTarget];
    
	CCSVGSprite *node = target_;
	
	[origFrame_ release];
	
	if (restoreOriginalFrame_) {
		origFrame_ = [[node source] retain];
    }
	
	nextFrame_ = 0;
}

- (void)stop {
	if( restoreOriginalFrame_ ) {
		CCSVGSprite *node = target_;
		node.source = origFrame_;
	}
	
	[super stop];
}

- (void)update:(ccTime) t {
	NSArray *frames = [animation_ frames];
	NSUInteger numberOfFrames = [frames count];
	CCSVGSource *frameToDisplay = nil;
	
	for( NSUInteger i=nextFrame_; i < numberOfFrames; i++ ) {
		NSNumber *splitTime = [splitTimes_ objectAtIndex:i];
		
		if( [splitTime floatValue] <= t ) {
			CCSVGAnimationFrame *frame = [frames objectAtIndex:i];
			frameToDisplay = [frame source];
			[(CCSVGSprite *)target_ setSource: frameToDisplay];
// TODO:			
//			NSDictionary *dict = [frame userInfo];
//			if( dict )
//				[[NSNotificationCenter defaultCenter] postNotificationName:CCSVGAnimationFrameDisplayedNotification object:target_ userInfo:dict];
			
			nextFrame_ = i+1;
			
			break;
		}
	}	
}

- (CCActionInterval *)reverse {
	NSArray *oldArray = [animation_ frames];
	NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:[oldArray count]];
    NSEnumerator *enumerator = [oldArray reverseObjectEnumerator];
    for (id element in enumerator)
        [newArray addObject:[[element copy] autorelease]];
	
	CCSVGAnimation *newAnim = [CCSVGAnimation animationWithFrames:newArray delayPerUnit:animation_.delayPerUnit];
	return [[self class] actionWithSVGAnimation:newAnim restoreOriginalFrame:restoreOriginalFrame_ duration:duration_];
}

@end
