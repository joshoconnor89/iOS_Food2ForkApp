//
//  ViewController.m
//  Food2ForkAPITest
//
//  Created by Joshua O'Connor on 5/4/16.
//  Copyright © 2016 Joshua O'Connor. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) UIImageView *noActivityImageView;
@property (nonatomic, strong) UIView* activityView;
@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) NSMutableArray *recipeArray;
@property (nonatomic, strong) NSMutableDictionary *recipeDictionary;
@property (nonatomic, strong) NSString *searchString;
@property (weak, nonatomic) IBOutlet UITableView *recipeTableView;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UITextField *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *currentSearchLabel;

@end

@implementation MainViewController


#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showActivityViewer];
    
    self.recipeTableView.delegate = self;
    self.recipeTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self setUpUI];
    
    self.searchString = @"Waffle";
    [self fetchData:self.searchString];

}

- (void)setUpUI{
    self.searchButton.layer.cornerRadius = 5.0;
    [self.searchBar setReturnKeyType:UIReturnKeySearch];
    //self.recipeTableView.allowsSelection = NO;
    self.noActivityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noRecipesFound.png"]];
    self.noActivityImageView.frame = CGRectMake(self.recipeTableView.frame.origin.x, self.recipeTableView.frame.origin.y + 128, self.view.frame.size.width, self.view.frame.size.width);
    self.noActivityImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.recipeTableView addSubview:self.noActivityImageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - REST

-(void)fetchData:(NSString*)searchQuery{
    
    NSString *string = [NSString stringWithFormat:@"%@%@", SearchURLString, searchQuery];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"%@", responseObject);
        
        NSError *error ;
        id json = [NSJSONSerialization JSONObjectWithData:operation.responseData   options:   NSJSONReadingMutableContainers error:&error];
        
        if (error){
                          
        }else{
            NSLog(@"feed response = %@", json);
            self.recipeArray = json[@"recipes"];
            NSLog(@"recipes: %@", self.recipeArray);
            
           
        }
        
        NSString *filteredString = [searchQuery stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        self.currentSearchLabel.text = [NSString stringWithFormat:@"Current Search:  %@", filteredString];
        
        if (self.recipeArray.count == 0){
            [self presentNoActivityUI];
        }
        else{
            self.noActivityImageView.hidden = true;
            self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        }
        
        
        [self.recipeTableView reloadData];
        [self hideActivityViewer];
        
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
    return self.recipeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecipeTableViewCell *cell;
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"recipeCell"];
    }
    
    cell.recipeImage.image = [UIImage imageNamed:@"imagePlaceholder.png"];

    self.recipeDictionary  = (NSMutableDictionary *) self.recipeArray[indexPath.row];
    
    NSString *publisherText = [NSString stringWithFormat:@"Publisher: %@", self.recipeDictionary[@"publisher"]];
    
    NSString *titleText = self.recipeDictionary[@"title"];
    
    cell.publisherLabel.text = publisherText;
    cell.titleLabel.text = titleText;
    
    
    NSURL *url = [NSURL URLWithString: self.recipeDictionary[@"image_url"]];;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        if (responseObject){
            RecipeTableViewCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
            if (updateCell){
                updateCell.recipeImage.image = responseObject;
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.recipeDictionary  = (NSMutableDictionary *) self.recipeArray[indexPath.row];
    NSString *publisherText = [NSString stringWithFormat:@"Published by: %@", self.recipeDictionary[@"publisher"]];
    
    NSString *titleText = self.recipeDictionary[@"title"];
    NSString *sourceURL = self.recipeDictionary[@"source_url"];
    NSString *imageURL = self.recipeDictionary[@"image_url"];
    int recipeID = [self.recipeDictionary[@"recipe_id"] intValue];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailedView"];
    
    detailViewController.recipePublisher = publisherText;
    detailViewController.recipeTitle = titleText;
    detailViewController.recipeSource = sourceURL;
    detailViewController.recipeID = recipeID;
    detailViewController.recipeImageURL = imageURL;
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}



#pragma mark - SearchBar Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.recipeTableView addGestureRecognizer:self.gestureRecognizer];
    textField.text = @"";
    
    return true;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    [self hideKeyboard];
    return true;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (![textField.text  isEqual: @""]){
        self.searchString = textField.text;
        
        NSString *encodedString = [self.searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self fetchData:encodedString];
    }
    
    [self hideKeyboard];
    return true;
}



- (IBAction)searchDatabase:(id)sender {
    if (![self.searchBar.text  isEqual: @"🔎 Search Recipes"]){
        self.searchString = self.searchBar.text;
        
        NSString *encodedString = [self.searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [self fetchData:encodedString];
    }else{
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Error."
                                      message:@"Please input a valid search query."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"YES"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do nothing
                             }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
    [self hideKeyboard];
}

#pragma mark - UI

- (void)showActivityViewer
{
    
    self.activityView = [[UIView alloc] initWithFrame: CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.activityView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    self.activityView.alpha = 1;
    [self.navigationController.view addSubview: _activityView];

    UIActivityIndicatorView *activityWheel = [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake([UIScreen mainScreen].bounds.size.width/2-35, 0, 70, 70)];
    activityWheel.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityWheel.color = [UIColor colorWithRed:0.455 green:0.576 blue:0.208 alpha:1];
    activityWheel.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                      UIViewAutoresizingFlexibleRightMargin |
                                      UIViewAutoresizingFlexibleTopMargin |
                                      UIViewAutoresizingFlexibleBottomMargin);
    
    [self.activityView addSubview:activityWheel];
    
    [[[self.activityView subviews] objectAtIndex:0] startAnimating];
}

- (void)hideActivityViewer
{
    [self.activityView removeFromSuperview];
    self.activityView = nil;
}

- (void)hideKeyboard {
    //[self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
    self.searchBar.text = @"🔎 Search Recipes";
    [self.recipeTableView removeGestureRecognizer:self.gestureRecognizer];
}

-(void)presentNoActivityUI{
    
    self.noActivityImageView.hidden = false;
    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

@end
