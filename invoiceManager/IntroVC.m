//
//  IntroVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-07-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "IntroVC.h"

@interface IntroVC ()

@end

@implementation IntroVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

-(IBAction) goToNextVC:(id)sender {
    
    InvoiceManager *invMngr = [InvoiceManager sharedInvoiceManager];
    if ([invMngr firstVC]){
        // NSLog(@">>> its already initiated !");
        // [self.navigationController pushViewController:[invMngr firstVC] animated:YES];
    } else {
        NSLog(@">>> it's NOT initiated !");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil];
        ViewController *firstVCinst = (ViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [invMngr setFirstVC:firstVCinst];
        [[invMngr firstVC] retain];
        
        //[self.navigationController pushViewController:firstVCinst animated:YES];
    }
    
    // can be one of the three: 'carpetCare', 'autoSpa' or 'ductFurnaceCleaning'
    [invMngr setCurrCompanyName:[sender restorationIdentifier]];
    
    [self.navigationController pushViewController:[invMngr firstVC] animated:YES];
    
}

@end
