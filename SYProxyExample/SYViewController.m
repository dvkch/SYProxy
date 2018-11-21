//
//  SYViewController.m
//  
//
//  Created by Stan Chevallier on 02/10/2015.
//
//

#import "SYViewController.h"
#import "SYSearchField.h"
#import "NSURL+Google.h"
#import "SYAppDelegate.h"

@interface SYViewController () <UIWebViewDelegate, SYSearchFieldDelegate>
@property (nonatomic, weak) IBOutlet UIWebView          *webView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *buttonBack;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *buttonNext;
@property (nonatomic, weak) IBOutlet UIBarButtonItem    *buttonRefresh;
@property (nonatomic, weak) IBOutlet SYSearchField      *searchField;
@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSURL *lastLoadedURL;
@end

@implementation SYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"SYProxy"];
    [self.searchField setLoupeColor:[UIColor grayColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateButtons];
}

- (void)updateButtons {
    [self.buttonBack setEnabled:self.webView.canGoBack];
    [self.buttonNext setEnabled:self.webView.canGoForward];
    [self.buttonRefresh setEnabled:!self.webView.loading];
    [self.searchField showLoadingIndicator:self.loading];
    [self.searchField setTitleURL:self.lastLoadedURL];
}

#pragma mark - IBActions

- (IBAction)buttonBackTap:(id)sender
{
    [self.webView goBack];
    [self updateButtons];
}

- (IBAction)buttonNextTap:(id)sender
{
    [self.webView goForward];
    [self updateButtons];
}

- (IBAction)buttonRefreshTap:(id)sender
{
    if (![self.webView.request.URL.absoluteString isEqualToString:@"about:blank"])
        [self.webView reload];
    else
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.lastLoadedURL]];
    [self updateButtons];
}

#pragma mark - SYSearchField delegate

- (void)searchFieldDidReturn:(SYSearchField *)searchField withText:(NSString *)text
{
    NSDataDetector *linkDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSArray *matches = [linkDetector matchesInString:text options:NSMatchingAnchored range:NSMakeRange(0, [text length])];
    
    if([matches count])
    {
        NSTextCheckingResult *res = [matches objectAtIndex:0];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[res URL]]];
    }
    else
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL googleSearchURLWithQuery:text]]];
}

#pragma mark - UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (![request.URL.absoluteString isEqualToString:@"about:blank"])
    {
        self.lastLoadedURL = request.URL;
        NSLog(@"Should use proxy %@ for host %@", [[SYAppDelegate obtain] firstProxyMatchingURL:request.URL], request.URL.host);
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.loading = YES;
    [self updateButtons];
    [self setTitle:@"Loading..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.loading = NO;
    [self updateButtons];
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    self.loading = NO;
    [self updateButtons];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"{ERROR}" withString:error.localizedDescription];
    [self.webView loadHTMLString:html baseURL:nil];
}

@end
