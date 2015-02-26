//
//  ViewController.h
//  The Giving Nugget
//
//  Created by Chithra Venkatesan on 9/21/14.
//  Copyright (c) 2014 Chithra Venkatesan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


extern NSArray *quotes;
extern const NSString *baseURL;

@property (nonatomic, retain) IBOutlet UILabel *quoteLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *usernameSC;
@property (nonatomic, retain) IBOutlet UITextField *passwordTF;

@property (nonatomic, retain) IBOutlet UISegmentedControl *nuggetType;
@property (nonatomic, retain) IBOutlet UITextField *nuggetNumber; 
@property (nonatomic, retain) IBOutlet UILabel *nuggetBalance;

@property (weak, nonatomic) IBOutlet UIImageView *switchingImage;

-(int)getRandomNumberBetween:(int)from and:(int)to;
-(bool)amILoggedIn;



@end


