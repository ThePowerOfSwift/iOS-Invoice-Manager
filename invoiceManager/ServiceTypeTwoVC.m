//
//  ServiceTypeTwoVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-07-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "ServiceTypeTwoVC.h"

@interface ServiceTypeTwoVC ()

@end

@implementation ServiceTypeTwoVC

@synthesize VCServiceNameType;

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

// goes to the next VC according to what services are selected ( and in their proper order )
-(IBAction) gotoNextView {
    InvoiceManager *invoiceMngr = [InvoiceManager sharedInvoiceManager];
    
    //NSLog(@"wtf is this %@", [self.navigationController presentingViewController]);
    if (invoiceMngr.getNextVC){
        UIViewController *nextVC = invoiceMngr.getNextVC;
        [self.navigationController pushViewController:nextVC animated:YES];
    } else {
        NSLog(@"NEXT VC IS NULL");
        [self.navigationController pushViewController:[invoiceMngr invoiceVC] animated:YES];
    }
    // if any services exist, push the first service VC
    //ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
    /*if ( ([[invoiceMngr listOfServices] count] > 0) && ([[invoiceMngr listOfServices] objectAtIndex:0]) ){
     ServiceItem *nextitem = [[invoiceMngr listOfServices] objectAtIndex:0];
     UIViewController *vcc = nextitem.serviceVC;
     [self.navigationController pushViewController:vcc animated:YES];
     } else {
     NSLog(@"Please add some services ?");
     }*/
}

-(IBAction) gotoLastView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
