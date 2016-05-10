//
//  DetailViewController.m
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/5/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController()

@property (nonatomic, strong) NSMutableDictionary *recipeDictionary;
@property (nonatomic, strong) NSMutableArray *ingredientsArray;

@end


@implementation DetailViewController

#pragma mark - Initialization

-(void)viewDidLoad{
    [super viewDidLoad];
    NSLog(@"%d", _recipeID);
    
    self.ingredientsTableView.delegate = self;
    self.ingredientsTableView.dataSource = self;
    
    self.titleLabel.text = self.recipeTitle;
    self.publisherLabel.text = self.recipePublisher;
    [self.webButton setTitle:self.recipeSource forState:UIControlStateNormal];
    
    [self fetchData:self.recipeID];
        
}

#pragma mark - REST

-(void)fetchData:(int)searchQuery{
    
    NSString *string = [NSString stringWithFormat:@"%@%d", RecipeIngredientsURLString, searchQuery];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error ;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData   options:   NSJSONReadingMutableContainers error:&error];
        
        
        if (error){
            
        }else{
            //NSLog(@"feed response = %@", json);
            
            self.recipeDictionary = json[@"recipe"];
            NSLog(@"recipe dictionary = %@", self.recipeDictionary);
            
            
            for (id key in self.recipeDictionary){
                if ([key  isEqual: @"ingredients"]){
                    self.ingredientsArray = self.recipeDictionary[@"ingredients"];
                }
            }
            
            if (self.ingredientsArray == nil){
                self.ingredientsArray = [@[@"Could not fetch ingredient list."]mutableCopy];
            }

            
            NSURL *url = [NSURL URLWithString:self.recipeImageURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
            [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"Response: %@", responseObject);
                self.recipeImage.backgroundColor = [UIColor blackColor];
                self.recipeImage.image = responseObject;

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Image error: %@", error);
            }];
            [requestOperation start];
            
        }

        [self.ingredientsTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAILURE: %@", error);
    }];
    
    [operation start];
}

#pragma mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ingredientsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IngredientsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientsCell"];
    cell.ingredientLabel.text = self.ingredientsArray[indexPath.row];
    
    
    cell.currentCount.text = [NSString stringWithFormat:@"%ld) ", (indexPath.row + 1)];
    
    if ([self.ingredientsArray[indexPath.row]  isEqual: @"Could not fetch ingredient list."]){
        cell.currentCount.text = @"***";
    }
    
    return cell;
}

- (IBAction)openWebsite:(id)sender {
    
    WebViewController *web = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webViewController"];
    web.URL = self.recipeSource;

    [self.navigationController pushViewController:web animated:YES];
}

@end
