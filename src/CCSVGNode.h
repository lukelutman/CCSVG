#import "cocos2d.h"


@class CCSVGSource;


@interface CCSVGNode : CCNode


#pragma mark

@property (readwrite, retain) CCSVGSource *source;


#pragma mark

- (id)initWithFile:(NSString *)file;

+ (id)nodeWithFile:(NSString *)file;


@end
