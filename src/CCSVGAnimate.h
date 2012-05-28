#import "CCActionInterval.h"


@class CCSVGAnimation;


@interface CCSVGAnimate : CCActionInterval <NSCopying> {
	NSMutableArray *splitTimes_;
	NSInteger nextFrame_;
	CCSVGAnimation *animation_;
	id origFrame_;
	BOOL restoreOriginalFrame_;
}


#pragma mark

@property (nonatomic, readwrite, retain) CCSVGAnimation *animation;


#pragma mark

+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation;

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation;


+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame;

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame;


+ (id)actionWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame duration:(ccTime)duration;

- (id)initWithSVGAnimation:(CCSVGAnimation *)animation restoreOriginalFrame:(BOOL)restoreOriginalFrame duration:(ccTime)duration;


@end