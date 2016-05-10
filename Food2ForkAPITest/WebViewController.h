//
//  WebViewController.h
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/5/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString * URL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
