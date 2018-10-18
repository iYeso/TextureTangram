//
//  NSObject+SafeKVO.h
//  TextureTangram
//
//  Created by 廖超龙 on 2018/10/18.
//  Copyright © 2018年 ZZinKin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeKVO)


/**
 Registers a block to receive KVO notifications for the specified key-path
 relative to the receiver.
 
 @discussion The block and block captured objects are retained. Call
 `removeObserverBlocksForKeyPath:` or `removeObserverBlocks` to release.
 
 @param keyPath The key path, relative to the receiver, of the property to
 observe. This value must not be nil.
 
 @param block   The block to register for KVO notifications.
 */
- (void)tan_addObserverBlockForKeyPath:(NSString*)keyPath
                                 block:(void (^)(id _Nonnull obj, id _Nonnull oldVal, id _Nonnull newVal))block;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications for the property specified by a given key-path
 relative to the receiver, and release these blocks.
 
 @param keyPath A key-path, relative to the receiver, for which blocks is
 registered to receive KVO change notifications.
 */
- (void)tan_removeObserverBlocksForKeyPath:(NSString*)keyPath;

/**
 Stops all blocks (associated by `addObserverBlockForKeyPath:block:`) from
 receiving change notifications, and release these blocks.
 */
- (void)tan_removeObserverBlocks;

@end
