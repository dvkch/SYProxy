//
//  SYEditProxyViewController.m
//  SYProxyExample
//
//  Created by Stan Chevallier on 02/10/2015.
//  Copyright © 2015 Syan. All rights reserved.
//

#import "SYEditProxyViewController.h"
#import "SYProxyModel.h"
#import "SYAppDelegate.h"

@interface SYEditProxyViewController () <UITextFieldDelegate>
@property (nonatomic, weak) IBOutlet UITextField *fieldHost;
@property (nonatomic, weak) IBOutlet UITextField *fieldPort;
@property (nonatomic, weak) IBOutlet UITextField *fieldUser;
@property (nonatomic, weak) IBOutlet UITextField *fieldPass;
@property (nonatomic, weak) IBOutlet UITextField *fieldRule;
@end

@implementation SYEditProxyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTitle:@"New Proxy"];
    if (self.proxy)
    {
        [self setTitle:@"Edit Proxy"];
        self.fieldHost.text = self.proxy.host;
        self.fieldPort.text = [NSString stringWithFormat:@"%d", self.proxy.port];
        self.fieldUser.text = self.proxy.username;
        self.fieldPass.text = self.proxy.password;
        self.fieldRule.text = [self.proxy.urlWildcardRules firstObject];
    }
}

- (IBAction)buttonSaveTap:(id)sender
{
    if (!self.fieldHost.text.length || !self.fieldPort.text.intValue || !self.fieldRule.text.length)
    {
        [[[UIAlertView alloc] initWithTitle:@"Incomplete data"
                                    message:@"Mandatory fields are: host, port and rule"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Close", nil] show];
        return;
    }
    
    if (!self.proxy)
        self.proxy = [[SYProxyModel alloc] init];
    
    [self.proxy setHost:self.fieldHost.text];
    [self.proxy setPort:self.fieldPort.text.intValue];
    [self.proxy setUsername:self.fieldUser.text];
    [self.proxy setPassword:self.fieldPass.text];
    [self.proxy setUrlWildcardRules:@[self.fieldRule.text]];
    
    [[SYAppDelegate obtain] addProxy:self.proxy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSArray *fields = @[self.fieldHost, self.fieldPort,
                        self.fieldUser, self.fieldPass,
                        self.fieldRule];
    
    if (textField == [fields lastObject])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSUInteger idx = [fields indexOfObject:textField];
    [(UITextField *)[fields objectAtIndex:(idx + 1)] becomeFirstResponder];
    
    return NO;
}

@end
