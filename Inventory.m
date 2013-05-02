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

- (void)addItemToInventory:(NSString *)item withImage:(NSString *)itemImage {
    
    dictionaryOfItemToAddToInventory = [[NSDictionary alloc] initWithObjectsAndKeys:
                         itemImage, item, nil];
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"inventory.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        inventoryContents = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        [inventoryContents addObject:dictionaryOfItemToAddToInventory];
        [inventoryContents writeToFile:filePath atomically:YES];
        
        BOOL success = [inventoryContents writeToFile:filePath atomically:YES];
        if (!success) {
            NSLog(@"not wrote to plist");
        }
    }
}

- (void)showInventory {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"inventory.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
        NSMutableDictionary *anotherDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
            
        for (id key in anotherDict) {
            NSLog(@"key: %@, value: %@", key, [anotherDict objectForKey:key]);
        }        
    }
}

- (void)removeItemFromInventory:(NSString *)item {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"inventory.plist"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        inventoryContents = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
        NSLog(@"contents of inventory %@", inventoryContents);
        if ([inventoryContents containsObject:item])
        {
            NSLog(@"Found");
            int index = [inventoryContents indexOfObject:item];
        }
        //[inventoryContents writeToFile:filePath atomically:YES];
        
        BOOL success = [inventoryContents writeToFile:filePath atomically:YES];
        if (!success) {
            NSLog(@"not wrote to plist");
        }
    }
}


@end
