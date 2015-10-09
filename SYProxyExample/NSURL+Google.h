//
//  NSURL+Google.h
//  Proxy
//
//  Created by Stanislas Chevallier on 02/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Google)

+ (instancetype)googleSearchURLWithQuery:(NSString *)query;

@end
