//
//  HelloWorldLayer.m
//  cocos2d-2.x-ARC-iOS
//
//  Created by Steffen Itterheim on 27.04.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "Constants.h"
#import "Inventory.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		player = [CCSprite spriteWithFile:@"mario.png"];
        [self addChild:player z:1 tag:jamestag];
        player.position = ccp(500, 200);
        player.rotation = 0;
        player.scale = 1;
        
        background = [CCSprite spriteWithFile:@"background.png"];
        [self addChild:background z:0 tag:1];
        
        //method scheduling
        [self scheduleOnce:@selector(moveSprite:) delay:2];
        
        //create inventory
        inventory = [Inventory create];
        [self addChild:inventory z:2 tag:1];
        
        [inventory removeItemFromInventory:@"rope"];
        
	}
	return self;
}

- (void)moveSprite:(ccTime)delta {
    
    [self getChildByTag:jamestag].position = ccp(200, 100);
    [self removeChild:player cleanup:NO];
    
}
@end
