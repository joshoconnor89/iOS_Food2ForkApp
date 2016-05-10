//
//  DetailViewController.h
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/5/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "Food2ForkConstants.h"
#import "IngredientsTableViewCell.h"
#import "WebViewController.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int recipeID;
@property (nonatomic, strong) NSString *recipePublisher;
@property (nonatomic, strong) NSString *recipeTitle;
@property (nonatomic, strong) NSString *recipeSource;
@property (nonatomic, strong) NSString *recipeImageURL;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTableView;


@end
