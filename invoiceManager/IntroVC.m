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

@synthesize serviceSelected;

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
    
    [self setServiceSelected:@"carpet"];
}

-(void) viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// tag = 2 for the carpet buttons, tag = 3 for autospa, tag = 4 for duct furnace buttons ( the arrow and the specific service image
-(IBAction)selectService:(id)sender {
    // save the selected service type
    [self setServiceSelected:[sender restorationIdentifier]];
    for (UIImageView *aSubview2 in self.view.subviews){
        if ([aSubview2 isKindOfClass:[UIImageView class]]){            
            if ([[sender restorationIdentifier] isEqualToString:@"carpetCare"]){
                if ([aSubview2 tag] == 2){
                    [aSubview2 setHidden:FALSE];
                } else if ( ([aSubview2 tag] == 3) || ([aSubview2 tag] == 4) ){
                    [aSubview2 setHidden:TRUE];
                }
            } else if ([[sender restorationIdentifier] isEqualToString:@"autoSpa"]){
                if ([aSubview2 tag] == 3){
                    [aSubview2 setHidden:FALSE];
                } else if ( ([aSubview2 tag] == 2) || ([aSubview2 tag] == 4) ){
                    [aSubview2 setHidden:TRUE];
                }
            } else if ([[sender restorationIdentifier] isEqualToString:@"ductFurnaceCleaning"]){
                if ([aSubview2 tag] == 4){
                    [aSubview2 setHidden:FALSE];
                } else if ( ([aSubview2 tag] == 2) || ([aSubview2 tag] == 3) ){
                    [aSubview2 setHidden:TRUE];
                }
            }
        }
    }
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
    [invMngr setCurrCompanyName:[self serviceSelected]];
    
    [self.navigationController pushViewController:[invMngr firstVC] animated:YES];
    
}

@end
