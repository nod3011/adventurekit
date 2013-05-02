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
    NSMutableArray *inventoryContents;
}

+ (id)create;
- (void)checkAndCreateInventory;
- (void)addItemToInventory:(NSString*)item withImage:(NSString*)itemImage;
- (void)showInventory;
- (void)removeItemFromInventory:(NSString*)item;

@end
