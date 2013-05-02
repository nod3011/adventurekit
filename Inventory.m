//
//  Inventory.m
//  cocos2d-2.x-ARC-iOS
//
//  Created by James Crowson on 30/04/2013.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Inventory.h"


@implementation Inventory

+ (id)create {
    
    return [[self alloc] init];
}

- (id)init {
    
    if ((self = [super init])) {
                
        [self checkAndCreateInventory];
        
        dictionaryOfItemToAddToInventory = [[NSMutableDictionary alloc]init];
        defaults = [NSUserDefaults standardUserDefaults];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        filePathToPlist = [documentsDirectory stringByAppendingPathComponent:@"inventory.plist"];
        
        //[[NSFileManager defaultManager] removeItemAtPath:filePathToPlist error:NULL];
        //[defaults setInteger:-1 forKey:@"numberOfItemsInInventory"];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    return self;
}

- (void)checkAndCreateInventory {
    
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath= [documentsDirectory stringByAppendingPathComponent:@"inventory.plist"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"inventory.plist"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (void)addItemToInventory:(NSString *)item withImage:(NSString *)itemImage andDescription:(NSString *)description {
    
    //find the number of items in the inventory and increment by 1
    numberOfItemsInInventory = [defaults integerForKey:@"numberOfItemsInInventory"];
    
    dictionaryOfItemToAddToInventory = [[NSDictionary alloc]
                                 initWithObjectsAndKeys:
                                        item,@"itemName",
                                        itemImage,@"itemImage",
                                        description, @"itemDescription",
                                 nil];
    
    NSMutableArray *newContentsInArray = [[NSMutableArray alloc] initWithObjects:dictionaryOfItemToAddToInventory, nil];
    
    if (numberOfItemsInInventory == 0) {
                
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePathToPlist]) {
            
            BOOL success = [newContentsInArray writeToFile:filePathToPlist atomically:YES];
            if (!success) {
                NSLog(@"Not wrote to plist");
            }
        }
    }
    else {
        
        NSMutableArray *oldContents = [[NSMutableArray alloc] initWithContentsOfFile:filePathToPlist];
        NSLog(@"contents %@", oldContents);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePathToPlist]) {
            
            [oldContents addObject:dictionaryOfItemToAddToInventory];
            
            BOOL success = [oldContents writeToFile:filePathToPlist atomically:YES];
            if (!success) {
                NSLog(@"Not wrote to plist");
            }
        }
    }
    
    numberOfItemsInInventory ++;
    [defaults setInteger:numberOfItemsInInventory forKey:@"numberOfItemsInInventory"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)showInventory {
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathToPlist]) {
                
        NSMutableArray *contentsOfInventory = [[NSMutableArray alloc] initWithContentsOfFile:filePathToPlist];
        
        for (int i = 0; i < [contentsOfInventory count]; i++) {
            
            NSDictionary *item = [contentsOfInventory objectAtIndex:i];
            NSString *itemName = [item objectForKey:@"itemName"];
            NSString *itemImage = [item objectForKey:@"itemImage"];
            NSString *itemDescription = [item objectForKey:@"itemDescription"];
            
            NSLog(@"item number: %i, name: %@, image: %@ description: %@", i,itemName,itemImage,itemDescription);
        }
    }
}

- (void)removeItemFromInventory:(NSString *)item {
    
    //decrement number of items in inventory by 1
    numberOfItemsInInventory = [defaults integerForKey:@"numberOfItemsInInventory"];
    numberOfItemsInInventory --;
        
    NSMutableArray *oldContents = [[NSMutableArray alloc] initWithContentsOfFile:filePathToPlist];
        
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathToPlist]) {
        
        NSUInteger index = [oldContents indexOfObjectPassingTest:
                            ^BOOL(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                                return [[dict objectForKey:@"itemName"] isEqual:item];
                            }];
        
        [oldContents removeObjectAtIndex:index];
        
        BOOL success = [oldContents writeToFile:filePathToPlist atomically:YES];
        if (!success) {
            NSLog(@"Not wrote to plist");
        }
    }
    
    [defaults setInteger:numberOfItemsInInventory forKey:@"numberOfItemsInInventory"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString*)lookAtItem:(NSString *)item {
    
    NSMutableArray *oldContents = [[NSMutableArray alloc] initWithContentsOfFile:filePathToPlist];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePathToPlist]) {
        
        NSPredicate *p = [NSPredicate predicateWithFormat:@"itemName = %@", item];
        NSArray *matchedDicts = [oldContents filteredArrayUsingPredicate:p];
        NSDictionary *item = [matchedDicts objectAtIndex:0];
        NSString *itemName = [item objectForKey:@"itemDescription"];
        return itemName;
    }
    
    return nil;
}

- (void)useItem:(NSString *)item {
    
}


@end
