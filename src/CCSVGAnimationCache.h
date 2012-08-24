#import <Foundation/Foundation.h>


@class CCSVGAnimation;


@interface CCSVGAnimationCache : NSObject


#pragma mark

+ (CCSVGAnimationCache *)sharedAnimationCache;

+ (void)purgeSharedAnimationCache;


#pragma mark

- (void)addAnimation:(CCSVGAnimation *)animation name:(NSString *)name;

- (void)addAnimationsWithDictionary:(NSDictionary *)dictionary;

- (void)addAnimationsWithFile:(NSString *)plist;


#pragma mark

- (CCSVGAnimation *)animationByName:(NSString *)name;


#pragma mark

- (void)removeAnimationByName:(NSString *)name;

- (void)removeAllAnimations;

- (void)removeUnusedAnimations;


@end
