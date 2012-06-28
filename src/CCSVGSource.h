#import "cocos2d.h"


@interface CCSVGSource : NSObject


#pragma mark

+ (void)setTessellationIterations:(NSUInteger)numberOfTesselationIterations;


#pragma mark

@property (readwrite, assign) CGRect contentRect;

@property (readwrite, assign) CGSize contentSize;

@property (readonly, assign) BOOL hasTransparentColors;


#pragma mark

- (id)initWithData:(NSData *)data;

- (id)initWithFile:(NSString *)name;


#pragma mark

- (void)draw;


@end
