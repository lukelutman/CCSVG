#import "cocos2d.h"


@class CCSVGSource;


@interface CCSVGSprite : CCNode


#pragma mark

@property (readwrite, retain) CCSVGSource *source;


#pragma mark

+ (id)spriteWithFile:(NSString *)file;

+ (id)spriteWithSource:(CCSVGSource *)source;

- (id)initWithFile:(NSString *)file;

- (id)initWithSource:(CCSVGSource *)source;


@end
