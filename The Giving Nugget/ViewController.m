//
//  ViewController.m
//  The Giving Nugget
//
//  Created by Chithra Venkatesan on 9/21/14.
//  Copyright (c) 2014 Chithra Venkatesan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize quoteLabel;
@synthesize usernameSC;
@synthesize passwordTF;
@synthesize nuggetNumber;
@synthesize nuggetType;
@synthesize nuggetBalance;

NSString *baseURL = @"http://young-tundra-9125.herokuapp.com/";

int finalNuggetCount =0;

NSArray *quotes;

-(NSString*)responseForGetRequestForURL: (NSString*) urlToCall
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlToCall]];
    request.HTTPMethod = @"GET";
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

}

-(NSString*) responseForPostRequestForURL: (NSString*) urlToCall withPostData: (NSData*) postData
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: urlToCall]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = postData;
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

}

-(bool)amILoggedIn
{
    NSString *responseString = [self responseForGetRequestForURL: [baseURL stringByAppendingString:@"amILoggedIn/"]];
    
    return [responseString isEqualToString:@"True"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(quotes == nil) {
        quotes = [NSArray arrayWithObjects:
                    @"A day without sunshine is like, you know, night.",
                    @"Behind every great man is a woman rolling her eyes.",
                    @"Gloat face activated",
                    @"ARE YOU KIDDING OR ARE YOU LYING",
                    @"What's the difference between a garbanzo and a chickpea?",
                    @"I haven’t slept for 10 days… because that would be too long.",
                    @"Not all who wander are lost.",
                    @"The first person to figure out that cows milk is drinkable was very very thirsty.",
                    @"If life gives you lemons, have a lemon party.",
                    @"A beb in need is a beb indeed.",
                    @"One boob, two boob, red boob, blue boob.",
                    @"Ponies are a girl's best friend.",
                  nil];
    }

    quoteLabel.text = quotes[[self getRandomNumberBetween:0 and:[quotes count]-1]];
	// Do any additional setup after loading the view, typically from a nib.
    
    if([self amILoggedIn]) {
        nuggetBalance.text = [self responseForGetRequestForURL: [baseURL stringByAppendingString:@"accounts/profile/"]];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(int)getRandomNumberBetween:(int)from and:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

- (IBAction)loginButtonPress:(id)sender {
    
    NSString *username = [usernameSC titleForSegmentAtIndex:usernameSC.selectedSegmentIndex];
    NSString *password = passwordTF.text;
    NSString *postData = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
    NSData *postingCodedData = [postData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *responseString = [self responseForPostRequestForURL: [baseURL stringByAppendingString: @"login/"] withPostData: postingCodedData];
    
    NSLog(@"%@", responseString);
    
    if([responseString rangeOfString:@"<p>Your username and password didn't match. Please try again.</p>"].location != NSNotFound) {
        UIAlertView *alertWrongPW = [[UIAlertView alloc]
                               initWithTitle: @"Wrong Password!!!"
                               message: @"TRY AGAIN"
                               delegate:self
                               cancelButtonTitle: @"Ok"
                               otherButtonTitles:nil,
                                     nil];
        [alertWrongPW show];
        passwordTF.text = @"";
    }
    else {
           [self performSegueWithIdentifier:@"loginSegue" sender: self];
    }
}


- (IBAction)giveButtonPress:(id)sender {
    NSString *nuggetTypeString = [nuggetType titleForSegmentAtIndex:nuggetType.selectedSegmentIndex];
    NSString *nuggetNumberString = nuggetNumber.text;
    int nuggetNumberInt = [nuggetNumberString intValue];
    if (nuggetNumberInt<1){
        UIAlertView *badInputAlert =[[UIAlertView alloc]
                             initWithTitle: @"Try Again"
                             message: @"Plas supply a positive integer (dumbass)!"
                             delegate:self
                             cancelButtonTitle: @"Förstår"
                             otherButtonTitles: nil,
                             nil];
        [badInputAlert show];
    }
    
    else {
        if ([nuggetTypeString isEqualToString:@"Golden"]) { finalNuggetCount = nuggetNumberInt* 100000;}
        else {finalNuggetCount = nuggetNumberInt;}
    
        UIAlertView *alert =[[UIAlertView alloc]
                         initWithTitle: [NSString stringWithFormat:@"Sending a one time payment of %d nuggets", finalNuggetCount]
                         message: @"No take backsies"
                         delegate:self
                         cancelButtonTitle: @"Cancel"
                         otherButtonTitles: nil,
                         nil];
        [alert addButtonWithTitle:@"Send"];
        alert.tag =1;
        [alert show];
        NSLog(@"%d", finalNuggetCount); }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{ //this first part is to give nuggets, this is because we used UI alert view
    if(alertView.tag==1){
    switch (buttonIndex){
        case 0:
            NSLog (@"Fuck no clicked");
            nuggetNumber.text = @"";
            break;
        case 1:
            NSLog(@"Ok Fine clicked");
            if([self amILoggedIn])
            {
                NSString *postData = [NSString stringWithFormat:@"giveamount=%d", finalNuggetCount];
                NSData *postingCodedData = [postData dataUsingEncoding:NSUTF8StringEncoding];
                NSString *responseString = [self responseForPostRequestForURL:[baseURL stringByAppendingString: @"accounts/give/"] withPostData: postingCodedData];
                NSLog(@"%@", responseString);
  
            }
            nuggetNumber.text = @"success!";
            
            break;
    }}
    else if (alertView.tag==2)
    {
        switch (buttonIndex){
            case 0:
                NSLog (@"cancel");
                break;
            case 1:
                NSLog(@"Logout clicked");
                if([self amILoggedIn])
                {
                    NSLog(@"%@", [self responseForGetRequestForURL: [baseURL stringByAppendingString:@"logout"]]);
                }
            
                [self performSegueWithIdentifier:@"logoutSegue" sender: self];
                break;
        }
    }
    else
    {
        NSLog( @"No log");
    }
    
}
- (IBAction)logOut:(id)sender {
    UIAlertView *logoutAlert =[[UIAlertView alloc]
                         initWithTitle: @"Log out?"
                         message: nil
                         delegate:self
                         cancelButtonTitle: @"No"
                         otherButtonTitles: nil,
                         nil];
    [logoutAlert addButtonWithTitle:@"Yes"];
    logoutAlert.tag =2;
    [logoutAlert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
