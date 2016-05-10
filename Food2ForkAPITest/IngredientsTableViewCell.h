//
//  IngredientsTableViewCell.h
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/5/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCount;

@end
