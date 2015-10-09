//
//  SYProxiesViewController.m
//  
//
//  Created by Stan Chevallier on 02/10/2015.
//
//

#import "SYProxiesViewController.h"
#import "SYAppDelegate.h"
#import "SYProxyModel.h"
#import "SYProxyCell.h"
#import "SYEditProxyViewController.h"

@interface SYProxiesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation SYProxiesViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueToEdit"])
    {
        SYEditProxyViewController *vc = segue.destinationViewController;
        NSIndexPath *selectedIP = [self.tableView indexPathForSelectedRow];
        [vc setProxy:[SYAppDelegate obtain].proxies[selectedIP.row]];
        [self.tableView deselectRowAtIndexPath:selectedIP animated:YES];
    }
}

#pragma mark - Actions

- (IBAction)buttonCloseTap:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SYAppDelegate obtain].proxies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SYProxyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellProxy"];
    [cell setProxy:[SYAppDelegate obtain].proxies[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToEdit" sender:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];
        SYProxyModel *proxy = [SYAppDelegate obtain].proxies[indexPath.row];
        [[SYAppDelegate obtain] removeProxy:proxy];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

@end
