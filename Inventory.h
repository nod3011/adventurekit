//
//  Inventory.h
//  cocos2d-2.x-ARC-iOS
//
//  Created by James Crowson on 30/04/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Inventory : CCNode {
    
    NSDictionary *dictionaryOfItemToAddToInventory;
    int numberOfItemsInInventory;
    NSString *filePathToPlist;
    NSUserDefaults *defaults;
}

+ (id)create;
- (void)checkAndCreateInventory;
- (void)addItemToInventory:(NSString*)item withImage:(NSString*)itemImage andDescription:(NSString*)description worksWith:(NSString*)something;
- (void)showInventory;
- (void)removeItemFromInventory:(NSString*)item;
- (NSString*)lookAtItem:(NSString*)item;
- (void)useItem:(NSString*)item with:(NSString*)something;

@end
