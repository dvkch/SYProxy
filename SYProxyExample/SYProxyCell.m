//
//  SYProxyCell.m
//  SYProxyExample
//
//  Created by Stan Chevallier on 03/10/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYProxyCell.h"
#import "SYProxyModel.h"

@interface SYProxyCell ()
@property (nonatomic, weak) IBOutlet UILabel *labelHostPort;
@property (nonatomic, weak) IBOutlet UILabel *labelUserPass;
@property (nonatomic, weak) IBOutlet UILabel *labelRules;
@end

@implementation SYProxyCell

- (void)setProxy:(SYProxyModel *)proxy
{
    self->_proxy = proxy;
    [self.labelHostPort setText:[NSString stringWithFormat:@"%@:%d", proxy.host, proxy.port]];
    
    if (proxy.username.length || proxy.password.length)
        [self.labelUserPass setText:[NSString stringWithFormat:@"%@:%@", proxy.username, proxy.password]];
    else
        [self.labelUserPass setText:@"No auth"];
    
    NSMutableArray *rules = [NSMutableArray array];
    for (NSString *rule in proxy.urlWildcardRules)
        [rules addObject:[NSString stringWithFormat:@"• %@", rule]];
    
    [self.labelRules    setText:[rules componentsJoinedByString:@"\n"]];
}

@end
