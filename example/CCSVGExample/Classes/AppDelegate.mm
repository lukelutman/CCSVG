#import "AppDelegate.h"
#import "cocos2d.h"
#import <CCSVG/CCSVG.h>


@implementation AppDelegate


#pragma mark

@synthesize navigationController = navigationController_;

@synthesize window = window_;


#pragma mark

- (void)dealloc {
    [navigationController_ release];
    [window_ release];
    [super dealloc];
}


#pragma mark

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    EAGLView *openGLView;
    openGLView = [[[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                      pixelFormat:kEAGLColorFormatRGBA8 
                                      depthFormat:0
                               preserveBackbuffer:NO 
                                       sharegroup:nil
                                    multiSampling:YES
                                  numberOfSamples:1] autorelease];
    [openGLView setMultipleTouchEnabled:YES];
    
    UIViewController *viewController;
    viewController = [[[UIViewController alloc] init] autorelease];
    viewController.view = openGLView;
    
    UINavigationController *navigationController;
    navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navigationController.navigationBarHidden = YES;
    [self setNavigationController:navigationController];
    
    UIWindow *window;
    window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [window setRootViewController:navigationController];
    [window makeKeyAndVisible];
    [self setWindow:window];
    
    [CCDirector setDirectorType:kCCDirectorTypeDisplayLink];
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
    [[CCDirector sharedDirector] setAnimationInterval:1.0/60.0];
	[[CCDirector sharedDirector] setDisplayFPS:YES];
    [[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationPortrait];
	[[CCDirector sharedDirector] setOpenGLView:openGLView];
    [[CCDirector sharedDirector] enableRetinaDisplay:YES];
    [[CCDirector sharedDirector] setProjection:CCDirectorProjection2D];
    
    CCScene *scene;
    scene = [CCScene node];
    [[CCDirector sharedDirector] runWithScene:scene];
    
    CCSVGSprite *sprite;
    sprite = [CCSVGSprite spriteWithFile:@"bird_0001.svg"];
    sprite.position = ccpMult(ccpFromSize([CCDirector sharedDirector].winSize), 0.5);
    [scene addChild:sprite];
    
    CCSVGAnimation *animation;
    animation = [CCSVGAnimation animationWithSourcesNamed:@"bird_%04d.svg" count:2 delay:1.0/15.0];
    [sprite runAction:[CCRepeatForever actionWithAction:[CCSVGAnimate actionWithSVGAnimation:animation]]];
        
    return YES;
    
}


@end
