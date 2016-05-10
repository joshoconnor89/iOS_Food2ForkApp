//
//  RecipeTableViewCell.h
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/4/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *publisherLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@end
