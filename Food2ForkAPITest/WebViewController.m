//
//  WebViewController.m
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/5/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController()

@end


@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpUI {
    
    self.webView.delegate = self;
    [self.webView setBackgroundColor:[UIColor colorWithRed:(59/255.0) green:(59/255.0) blue:(59/255.0) alpha:1]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.URL]]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];

    
}
@end
