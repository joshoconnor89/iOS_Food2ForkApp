//
//  RecipeTableViewCell.m
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/4/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "RecipeTableViewCell.h"



@implementation RecipeTableViewCell

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //Set currentDeviceWidth to screen width of current device
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        UIFont *font = self.titleLabel.font;

        //iphone4s
        if ([[UIScreen mainScreen] bounds].size.height == 480)
        {
            self.titleLabel.font = [font fontWithSize:15];
            self.publisherLabel.font = [font fontWithSize:11];
        }
        
        //iphone5
        else if ([[UIScreen mainScreen] bounds].size.height == 568)
        {
            self.titleLabel.font = [font fontWithSize:16];
            self.publisherLabel.font = [font fontWithSize:12];
        }
        //iphone6
        else if ([[UIScreen mainScreen] bounds].size.height == 667)
        {
            self.titleLabel.font = [font fontWithSize:18];
            self.publisherLabel.font = [font fontWithSize:14];
        }
        //iphone6+
        else
        {
            self.titleLabel.font = [font fontWithSize:20];
            self.publisherLabel.font = [font fontWithSize:16];
        }
    }
}

@end
