#import <Foundation/Foundation.h>
#import <mkOpenVG_SVG.h>


@interface CCSVGSource : NSObject {
    MonkSVG::OpenVG_SVGHandler::SmartPtr svg_;
}


#pragma mark

- (id)initWithData:(NSData *)data;

- (id)initWithFile:(NSString *)name;


#pragma mark

- (void)draw;


@end
