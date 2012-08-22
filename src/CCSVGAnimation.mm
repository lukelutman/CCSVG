#import "ccMacros.h"
#import "CCSVGAnimation.h"
#import "CCSVGCache.h"
#import "CCSVGSource.h"


#pragma mark - CCSVGAnimationFrame

@implementation CCSVGAnimationFrame


#pragma mark

@synthesize delayUnits = delayUnits_;

@synthesize source = source_;

@synthesize userInfo = userInfo_;


#pragma mark

- (id)initWithSource:(CCSVGSource *)source delayUnits:(float)delayUnits userInfo:(NSDictionary*)userInfo {
	if (( self = [super init])) {
		self.delayUnits = delayUnits;
		self.source = source;
		self.userInfo = userInfo;
	}
	return self;
}

- (void)dealloc {    
	CCLOGINFO( @"cocos2d: deallocing %@", self);
	[source_ release];
	[userInfo_ release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    
    CCSVGSource *source;
    source = [[self.source copy] autorelease];
    
    NSDictionary *userInfo;
    userInfo = [[self.userInfo copy] autorelease];
    
	CCSVGAnimationFrame *copy;
    copy = [[[self class] allocWithZone:zone] initWithSource:source delayUnits:self.delayUnits userInfo:userInfo];
    
	return copy;
    
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ = %p | Source = %p, delayUnits = %0.2f >", [self class], self, self.source, self.delayUnits];
}


@end


#pragma mark - CCSVGAnimation

@implementation CCSVGAnimation


#pragma mark

- (CGRect)contentRect {
    return ((CCSVGAnimationFrame *)[self.frames objectAtIndex:0]).source.contentRect;
}

- (CGSize)contentSize {
    return self.contentRect.size;
}

@synthesize delayPerUnit = delayPerUnit_;

@synthesize duration = duration_;

@synthesize frames = frames_;

@synthesize restoreOriginalFrame = restoreOriginalFrame_;

@synthesize totalDelayUnits = totalDelayUnits_;


#pragma mark

+ (id)animation {
	return [[[self alloc] init] autorelease];
}

+ (id)animationWithSources:(NSArray *)sources {
	return [[[self alloc] initWithSources:sources] autorelease];
}

+ (id)animationWithSources:(NSArray *)sources delay:(float)delay {
	return [[[self alloc] initWithSources:sources delay:delay] autorelease];
}

+ (id)animationWithFrames:(NSArray *)frames delayPerUnit:(float)delayPerUnit {
	return [[[self alloc] initWithFrames:frames delayPerUnit:delayPerUnit] autorelease];
}

+ (id)animationWithSourcesNamed:(NSString *)format count:(NSUInteger)count delay:(float)delay {
    
    NSMutableArray *sources;
    sources = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger index = 0; index < count; index++) {
        
        NSString *name;
        name = [NSString stringWithFormat:format, index + 1];
        
        CCSVGSource *source;
        source = [[CCSVGCache sharedSVGCache] addFile:name];
        
        [sources addObject:source];
        
    }
    
    return [self animationWithSources:sources delay:delay];
    
}


#pragma mark

- (id)init {
	return [self initWithSources:nil delay:0];
}

- (id)initWithSources:(NSArray *)sources {
	return [self initWithSources:sources delay:0];
}

- (id)initWithSources:(NSArray *)sources delay:(float)delay {
	if ((self = [super init])) {
        
		self.frames = [NSMutableArray arrayWithCapacity:sources.count];
		
		for (CCSVGSource *source in sources) {
			CCSVGAnimationFrame *frame;
            frame = [[CCSVGAnimationFrame alloc] initWithSource:source delayUnits:1 userInfo:nil];
			[self.frames addObject:frame];
			[frame release];
		}
		
		self.delayPerUnit = delay;
        self.totalDelayUnits = sources.count;
		self.duration = self.delayPerUnit * self.totalDelayUnits;
        
	}
	return self;
}

- (id)initWithFrames:(NSArray *)frames delayPerUnit:(float)delayPerUnit {
	if ((self = [super init])) {
        
        self.delayPerUnit = delayPerUnit;
        self.duration = 0;
        
		self.frames = [NSMutableArray arrayWithArray:frames];
		for (CCSVGAnimationFrame *frame in frames) {
			self.duration += frame.delayUnits * delayPerUnit;
			self.totalDelayUnits += frame.delayUnits;
		}
        
	}
	return self;
}

- (void)dealloc {
	CCLOGINFO( @"cocos2d: deallocing %@",self);	
	[frames_ release];
	[super dealloc];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ = %p | frames=%d, totalDelayUnits=%f, delayPerUnit=%0.2f>", 
            [self class], 
            self,
			self.frames.count,
			self.totalDelayUnits,
			self.delayPerUnit];
}


#pragma mark

- (void)addFrameWithSource:(CCSVGSource *)source {
    
	CCSVGAnimationFrame *frame;
    frame = [[CCSVGAnimationFrame alloc] initWithSource:source delayUnits:1 userInfo:nil];
	[self.frames addObject:frame];
	[frame release];
    
	self.duration += self.delayPerUnit;
	self.totalDelayUnits++;
    
}

- (void)addFrameWithSource:(CCSVGSource *)source delay:(float)delay {
    
	if (self.delayPerUnit == 0) {
		self.delayPerUnit = delay; 	
	}
	
	float delayUnits;
    delayUnits = delay / self.delayPerUnit;
	
	CCSVGAnimationFrame *frame;
    frame = [[CCSVGAnimationFrame alloc] initWithSource:source delayUnits:delayUnits userInfo:nil];
	[self.frames addObject:frame];
	[frame release];
    
    self.duration += delay; 
	self.totalDelayUnits += delayUnits;
    
}

- (void)addFrameWithSourceNamed:(NSString *)name {
    
    CCSVGSource *source;
    source = [[CCSVGCache sharedSVGCache] addFile:name];
    [self addFrameWithSource:source];
    
}

#pragma mark

- (void)optimize {
    for (CCSVGAnimationFrame *frame in self.frames) {
        [frame.source optimize];
    }
}


@end
