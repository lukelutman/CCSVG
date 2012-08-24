#import "ccMacros.h"
#import "CCSVGAnimation.h"
#import "CCSVGAnimationCache.h"
#import "CCSVGCache.h"
#import "CCSVGSource.h"
#import "Support/CCFileUtils.h"


#pragma mark - CCSVGAnimationCache

@interface CCSVGAnimationCache ()


#pragma mark

@property (readwrite, retain) NSMutableDictionary *animations;


@end



#pragma mark - CCSVGAnimationCache

@implementation CCSVGAnimationCache


#pragma mark 

static CCSVGAnimationCache *sharedAnimationCache_ = nil;

+ (CCSVGAnimationCache *)sharedAnimationCache {
	if (!sharedAnimationCache_) {
		sharedAnimationCache_ = [[CCSVGAnimationCache alloc] init];
    }
	return sharedAnimationCache_;
}

+ (id)alloc {
	NSAssert(sharedAnimationCache_ == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (void)purgeSharedAnimationCache {
	[sharedAnimationCache_ release];
	sharedAnimationCache_ = nil;
}


#pragma mark

@synthesize animations = animations_;


#pragma mark

- (id)init {
	if ((self = [super init])) {
		self.animations = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc {
	CCLOGINFO(@"cocos2d: deallocing %@", self);
	[animations_ release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ = %p | num of animations =  %i>", 
            [self class], 
            self, 
            self.animations.count];
}


#pragma mark

- (void)addAnimation:(CCSVGAnimation *)animation name:(NSString *)name {
	[self.animations setObject:animation forKey:name];
}

- (void)removeAnimationByName:(NSString *)name {
	if (name) {
        [self.animations removeObjectForKey:name];
    }
}

- (void)removeAllAnimations {
	[animations_ removeAllObjects];
}

- (void)removeUnusedAnimations {
	NSArray *keys = [animations_ allKeys];
	for (id key in keys) {
        id value = [animations_ objectForKey:key];		
		if ([value retainCount] == 1) {
			CCLOG(@"cocos2d: CCSVGAnimationCache: removing unused animation: %@", key);
			[animations_ removeObjectForKey:key];
		}
	}
}


#pragma mark

- (CCSVGAnimation *)animationByName:(NSString *)name {
	return [self.animations objectForKey:name];
}


#pragma mark

- (void)parseVersion1:(NSDictionary*)animations {
    
	NSArray *animationNames;
    animationNames = [animations allKeys];
	
	for (NSString *animationName in animationNames) {
        
		NSDictionary *animationDictionary;
        animationDictionary = [animations objectForKey:animationName];
        
		NSArray *sourceNames;
        sourceNames = [animationDictionary objectForKey:@"frames"];
        
		NSNumber *delay;
        delay = [animationDictionary objectForKey:@"delay"];
		
		if (sourceNames == nil) {
			CCLOG(@"cocos2d: CCSVGAnimationCache: Animation '%@' found in dictionary without any frames - cannot add to animation cache.", animationName);
			continue;
		}
		
		NSMutableArray *animationFrames;
        animationFrames = [NSMutableArray arrayWithCapacity:sourceNames.count];
		
		for (NSString *sourceName in sourceNames) {
            
			CCSVGSource *source;
            source = [[CCSVGCache sharedSVGCache] addFile:sourceName];
			
			if (!source) {
				CCLOG(@"cocos2d: CCSVGAnimationCache: Animation '%@' refers to source '%@' which is not currently in the CCSVGCache. This frame will not be added to the animation.", animationName, sourceName);
				continue;
			}
			
			CCSVGAnimationFrame *animationFrame;
            animationFrame = [[CCSVGAnimationFrame alloc] initWithSource:source delayUnits:1 userInfo:nil];
			[animationFrames addObject:animationFrame];
			[animationFrame release];
            
		}
		
		if (animationFrames.count == 0) {
			CCLOG(@"cocos2d: CCSVGAnimationCache: None of the frames for animation '%@' were found in the CCSVGCache. Animation is not being added to the Animation Cache.", animationName);
			continue;
		} else if (animationFrames.count != sourceNames.count) {
			CCLOG(@"cocos2d: CCSVGAnimationCache: An animation in your dictionary refers to a frame which is not in the CCSVGCache. Some or all of the frames for the animation '%@' may be missing.", animationName);
		}
		
        
		CCSVGAnimation *animation;
		animation = [CCSVGAnimation animationWithFrames:animationFrames delayPerUnit:delay.floatValue];
		[[CCSVGAnimationCache sharedAnimationCache] addAnimation:animation name:animationName];
        
	}
    
}

- (void)parseVersion2:(NSDictionary*)animations {
	NSArray* animationNames = [animations allKeys];
	CCSVGCache *frameCache = [CCSVGCache sharedSVGCache];
	
	for( NSString *name in animationNames )
	{
		NSDictionary* animationDict = [animations objectForKey:name];
		
		//		BOOL loop = [[animationDict objectForKey:@"loop"] boolValue];
		BOOL restoreOriginalFrame = [[animationDict objectForKey:@"restoreOriginalFrame"] boolValue];
		
		NSArray *frameArray = [animationDict objectForKey:@"frames"];
		
		
		if ( frameArray == nil ) {
			CCLOG(@"cocos2d: CCSVGAnimationCache: Animation '%@' found in dictionary without any frames - cannot add to animation cache.", name);
			continue;
		}
		
		// Array of AnimationFrames
		NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[frameArray count]];
		
		for( NSDictionary *entry in frameArray ) {
			NSString *spriteFrameName = [entry objectForKey:@"spriteframe"];
			CCSVGSource *spriteFrame = [frameCache sourceForKey:spriteFrameName];
			
			if( ! spriteFrame ) {
				CCLOG(@"cocos2d: CCSVGAnimationCache: Animation '%@' refers to frame '%@' which is not currently in the CCSVGCache. This frame will not be added to the animation.", name, spriteFrameName);
				
				continue;
			}
			
			float delayUnits = [[entry objectForKey:@"delayUnits"] floatValue];
			NSDictionary *userInfo = [entry objectForKey:@"notification"];
			
			CCSVGAnimationFrame *animFrame = [[CCSVGAnimationFrame alloc] initWithSource:spriteFrame delayUnits:delayUnits userInfo:userInfo];
			
			[array addObject:animFrame];
			[animFrame release];
		}
		
		float delayPerUnit = [[animationDict objectForKey:@"delayPerUnit"] floatValue];
		CCSVGAnimation *animation = [[CCSVGAnimation alloc] initWithFrames:array delayPerUnit:delayPerUnit];
		[array release];
		
		[animation setRestoreOriginalFrame:restoreOriginalFrame];
		
		[[CCSVGAnimationCache sharedAnimationCache] addAnimation:animation name:name];
		[animation release];
	}
}

- (void)addAnimationsWithDictionary:(NSDictionary *)dictionary {
	NSDictionary *animations = [dictionary objectForKey:@"animations"];
	
	if ( animations == nil ) {
		CCLOG(@"cocos2d: CCSVGAnimationCache: No animations were found in provided dictionary.");
		return;
	}
	
	NSUInteger version = 1;
	NSDictionary *properties = [dictionary objectForKey:@"properties"];
	if( properties )
		version = [[properties objectForKey:@"format"] intValue];
	
	NSArray *spritesheets = [properties objectForKey:@"spritesheets"];
	for( NSString *name in spritesheets ) {
//		[[CCSVGCache sharedSVGCache] addSVGsWithFile:name];
    }
	
	switch (version) {
		case 1:
			[self parseVersion1:animations];
			break;
		case 2:
			[self parseVersion2:animations];
			break;
		default:
			NSAssert(NO, @"Invalid animation format");
	}
}

- (void)addAnimationsWithFile:(NSString *)plist {
	NSAssert( plist, @"Invalid texture file name");
	
    NSString *path = [CCFileUtils fullPathFromRelativePath:plist];
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
	
	NSAssert1( dict, @"CCSVGAnimationCache: File could not be found: %@", plist);
	
	
	[self addAnimationsWithDictionary:dict];
}


@end

