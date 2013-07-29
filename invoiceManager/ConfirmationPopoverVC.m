//
//  ConfirmationPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-07-26.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "ConfirmationPopoverVC.h"

@interface ConfirmationPopoverVC ()

@end

@implementation ConfirmationPopoverVC

@synthesize confirmationDelegate;
@synthesize serviceSender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(IBAction)selectAction:(id)sender {
    //NSLog(@"The senders RESTORATIONB IS %@", [serviceSender restorationIdentifier]);
    if ([[sender restorationIdentifier] isEqualToString:@"yes"]){
        [confirmationDelegate sendConfirmation:@"yes" forSender:serviceSender];
    } else if ([[sender restorationIdentifier] isEqualToString:@"no"]) {
        [confirmationDelegate sendConfirmation:@"no" forSender:serviceSender];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
