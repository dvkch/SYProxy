//
//  SYAppDelegate.m
//  SYProxyExample
//
//  Created by Stan Chevallier on 02/10/2015.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "SYAppDelegate.h"
#import "SYProxyModel.h"

@interface SYAppDelegate ()

@end

@implementation SYAppDelegate

+ (SYAppDelegate *)obtain
{
    return (SYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (NSString *)proxyFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    return [basePath stringByAppendingPathComponent:@"proxies"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:[self proxyFilePath]];
    self.proxies = [NSMutableOrderedSet orderedSetWithArray:array];
    [SYProxyURLProtocol setDataSource:self];
    return YES;
}

- (void)addProxy:(SYProxyModel *)proxy
{
    NSUInteger index = [self.proxies indexOfObject:proxy];
    if (index != NSNotFound)
    {
        // in case a proxy with the same ID exists we update it in place
        [self.proxies replaceObjectAtIndex:index withObject:proxy];
    }
    else
    {
        // this is a new proxy, we add it to the list
        [self.proxies addObject:proxy];
    }
    [NSKeyedArchiver archiveRootObject:self.proxies.array toFile:[self proxyFilePath]];
}

- (void)removeProxy:(SYProxyModel *)proxy
{
    [self.proxies removeObject:proxy];
    [self.proxies.array writeToFile:[self proxyFilePath] atomically:YES];
}

#pragma mark - SYProxyURLProtocolDataSource

- (SYProxyModel *)firstProxyMatchingURL:(NSURL *)url
{
    return [SYProxyModel firstProxyInProxies:self.proxies.array matchingURL:url];
}

@end
