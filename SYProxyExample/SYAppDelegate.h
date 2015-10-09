//
//  SYAppDelegate.h
//  SYProxyExample
//
//  Created by Stan Chevallier on 02/10/2015.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYProxyURLProtocol.h"

@interface SYAppDelegate : UIResponder <UIApplicationDelegate, SYProxyURLProtocolDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableOrderedSet *proxies;

+ (SYAppDelegate *)obtain;

- (void)addProxy:(SYProxyModel *)proxy;
- (void)removeProxy:(SYProxyModel *)proxy;

@end

