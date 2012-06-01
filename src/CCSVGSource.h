#import "cocos2d.h"


@interface CCSVGSource : NSObject


#pragma mark

+ (void)setTessellationIterations:(NSUInteger)numberOfTesselationIterations;


#pragma mark

@property (readwrite, assign) CGSize contentSize;


#pragma mark

- (id)initWithData:(NSData *)data;

- (id)initWithFile:(NSString *)name;


#pragma mark

- (void)draw;


@end
