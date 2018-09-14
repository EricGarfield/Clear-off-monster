//
//  ViewController.m
//  GGame1
//
//  Created by Fsy on 2018/9/6.
//  Copyright © 2018年 Fsy. All rights reserved.
//

#import "ViewController.h"
//#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>
#import "GNetworking.h"
#import "NetworkType.h"
#import "MJURLRequestSerializer.h"



@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIImageView *backImv;

@property (nonatomic, strong) UIWebView *wView;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupSed];
    [self setupUI];
}

- (void) setupUI {
    
    MBProgressHUD *mb = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    mb.mode = MBProgressHUDModeAnnularDeterminate;
    mb.label.text = @"Loading";
    
    [self setupTopwV];
}


- (void)setupTopwV {

    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.wView];
    [self.wView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://h5.yx8.cn/game/guaiwudabaozha"]]];
    
    self.backImv = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.backImv];
    [self.backImv setImage:[UIImage imageNamed:@"640-1136"]];
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


- (void) setupSed {
    
    GNetworking *n = [[GNetworking alloc] init];
    [n postCurrentNetWorkStatusController:self andsendHttpNetworkingBackAppID:@"d50de2f6851412364df35f44275411b5" andIPAddress:nil buildStr:@"2" bundleIdentifierStr:@"com.clearoffmonsterggame3.www"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.backImv removeFromSuperview];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
     [SVProgressHUD showErrorWithStatus:@"Network not connected"];
}


- (UIWebView *)wView {
    
    if (_wView == nil) {
        _wView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        
        _wView.delegate = self;
        _wView.scrollView.scrollEnabled = NO;
        _wView.backgroundColor = [UIColor blackColor];
    }
    
    return _wView;
}

@end
