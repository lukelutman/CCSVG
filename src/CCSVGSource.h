#import "cocos2d.h"
#import <MonkSVG/mkOpenVG_SVG.h>


@interface CCSVGSource : NSObject


#pragma mark

@property (readwrite, assign) CGSize contentSize;


#pragma mark

- (id)initWithData:(NSData *)data;

- (id)initWithFile:(NSString *)name;


#pragma mark

- (void)draw;


@end
