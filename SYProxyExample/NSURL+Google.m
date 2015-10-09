//
//  NSURL+Google.m
//  Proxy
//
//  Created by Stanislas Chevallier on 02/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

#import "NSURL+Google.h"


@implementation NSURL (Google)

+ (instancetype)googleSearchURLWithQuery:(NSString *)query
{
    NSMutableCharacterSet *queryCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [queryCharacterSet removeCharactersInRange:NSMakeRange('&', 1)]; // %26
    [queryCharacterSet removeCharactersInRange:NSMakeRange('=', 1)]; // %3D
    [queryCharacterSet removeCharactersInRange:NSMakeRange('?', 1)]; // %3F
    
    NSString *newQuery = [query stringByAddingPercentEncodingWithAllowedCharacters:queryCharacterSet];
    return [NSURL URLWithString:
            [NSString stringWithFormat:@"http://www.google.com/search?q=%@", newQuery]];
}

@end

