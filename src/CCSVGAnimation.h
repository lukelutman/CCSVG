#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@class CCSVGSource;


@interface CCSVGAnimationFrame : NSObject <NSCopying>


#pragma mark

@property (nonatomic, readwrite, assign) float delayUnits;

@property (nonatomic, readwrite, retain) CCSVGSource *source;

@property (nonatomic, readwrite, retain) NSDictionary *userInfo;


#pragma mark

- (id)initWithSource:(CCSVGSource *)source delayUnits:(float)delayUnits userInfo:(NSDictionary *)userInfo;


@end



#pragma mark

@interface CCSVGAnimation : NSObject


#pragma mark

@property (nonatomic, readonly, assign) CGRect contentRect;

@property (nonatomic, readonly, assign) CGSize contentSize;

@property (nonatomic, readwrite, assign) float delayPerUnit;

@property (nonatomic, readwrite, assign) float duration;

@property (nonatomic, readwrite, retain) NSMutableArray *frames;

@property (nonatomic, readwrite, assign) BOOL restoreOriginalFrame;

@property (nonatomic, readwrite, assign) float totalDelayUnits;


#pragma mark

+ (id)animation;

+ (id)animationWithFrames:(NSArray *)frames delayPerUnit:(float)delayPerUnit;

+ (id)animationWithSources:(NSArray *)sources;

+ (id)animationWithSources:(NSArray *)sources delay:(float)delay;

+ (id)animationWithSourcesNamed:(NSString *)format count:(NSUInteger)count delay:(float)delay;


# pragma mark

- (id)initWithFrames:(NSArray *)frames delayPerUnit:(float)delayPerUnit;

- (id)initWithSources:(NSArray *)sources;

- (id)initWithSources:(NSArray *)sources delay:(float)delay;


#pragma mark

- (void)addFrameWithSource:(CCSVGSource *)source;

- (void)addFrameWithSource:(CCSVGSource *)source delay:(float) delay;

- (void)addFrameWithSourceNamed:(NSString *)name;


#pragma mark

- (void)optimize;


@end
