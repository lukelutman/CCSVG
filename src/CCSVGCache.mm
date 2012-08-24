#import "CCSVGSource.h"
#import "CCSVGCache.h"


@interface CCSVGCache ()


#pragma mark

@property (readwrite, retain) NSMutableDictionary *sources;


@end


#pragma mark

@implementation CCSVGCache


static CCSVGCache *sharedSVGCache;


#pragma mark

+ (id)alloc {
	NSAssert(sharedSVGCache == nil, @"Attempted to allocate a second instance of a singleton.");
	return [super alloc];
}

+ (CCSVGCache *)sharedSVGCache {
	if (!sharedSVGCache) {
		sharedSVGCache = [[CCSVGCache alloc] init];
	}
	return sharedSVGCache;
}

+ (void)purgeSharedSVGCache {
	[sharedSVGCache release];
	sharedSVGCache = nil;
}


#pragma mark

@synthesize sources = sources_;


#pragma mark

- (id)init {
	if ((self = [super init])) {
        self.sources = [NSMutableDictionary dictionary];
	}
	return self;
}

- (void)dealloc {
    [sources_ release];
	[super dealloc];
}


#pragma mark

- (CCSVGSource *)addData:(NSData *)data forKey:(NSString *)key {
	
	NSAssert(data != nil, @"Invalid data");
	NSAssert(key != nil, @"Invalid key");
	
	CCSVGSource *source = [self sourceForKey:key];
	if (source == nil) {
		source = [[[CCSVGSource alloc] initWithData:data] autorelease];
		NSAssert(source != nil, @"Could not create source from data");
		[self.sources setObject:source forKey:key];
	}
	return source;
	
}

- (CCSVGSource *)addFile:(NSString *)name {
	
	NSAssert(name != nil, @"invalid file");
	
	CCSVGSource *source = [self sourceForKey:name];
	if (source == nil) {
		source = [[[CCSVGSource alloc] initWithFile:name] autorelease];
		NSAssert1(source != nil, @"could not create source from file: %@", name);
		[self.sources setObject:source forKey:name];
	}
	return source;
	
}

- (CCSVGSource *)addSource:(CCSVGSource *)source forKey:(NSString *)key {
	
	NSAssert(source != nil, @"source cannot be nil");
	NSAssert(key != nil, @"key cannot be nil");
	NSAssert([self sourceForKey:key] == source, @"duplicate key");
	
	[self.sources setObject:source forKey:key];
	return source;
	
}


#pragma mark

- (CCSVGSource *)sourceForKey:(NSString *)key {
	return [self.sources objectForKey:key];
}


#pragma mark

- (void)removeAllSources {
	[self.sources removeAllObjects];
}

- (void)removeUnusedSources {
	NSArray *keys = [self.sources allKeys];
	for (NSString *key in keys) {
		CCSVGSource *source = [self sourceForKey:key];		
		if ([source retainCount] == 1) {
			CCLOG(@"cocos2d: CCSVGCache: removing unused source: %@", key);
			[self removeSourceForKey:key];
		}
	}
}

- (void)removeSource:(CCSVGSource *)source {
	[self.sources removeObjectsForKeys:[self.sources allKeysForObject:source]];
}

- (void)removeSourceForKey:(NSString *)key {
	[self.sources removeObjectForKey:key];
}


@end
