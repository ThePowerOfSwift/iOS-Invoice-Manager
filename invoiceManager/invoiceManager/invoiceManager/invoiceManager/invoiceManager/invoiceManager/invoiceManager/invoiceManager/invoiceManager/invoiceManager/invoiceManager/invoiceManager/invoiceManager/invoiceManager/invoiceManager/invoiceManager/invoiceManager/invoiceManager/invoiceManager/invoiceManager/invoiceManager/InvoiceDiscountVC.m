//
//  InvoiceDiscountVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "InvoiceDiscountVC.h"

@interface InvoiceDiscountVC ()

@end

@implementation InvoiceDiscountVC

@synthesize discountType, discountDelegate, userInput, serviceName;

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

-(IBAction) onClickingBtn: (id) sender {
    
    // de-select all buttons with a specific tag
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 5){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    //[btn setTitleColor:[UIColor colorWithWhite:94.0/255.0 alpha:100.0] forState:UIControlStateNormal];
                    [btn setTag:0];
                }
            }
        }
    }
    
    // select the button the user clicked and set a specific tag for it
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    //[btnEx setImage:[UIImage imageNamed:@"btnBackground2Sel.png" ] forState:UIControlStateNormal];
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:5];           // TAG = 5 means that this button is SELECTED
    
    discountType = [btnEx restorationIdentifier];
}

-(IBAction) saveOrCancel: (id) sender {
    float amount_entered = [[userInput text] floatValue];
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        NSLog(@"carpet disc amount is %f, %@, %@", amount_entered, discountType, serviceName);
        [discountDelegate updateDiscount:self updateType:@"save" discountType:discountType amount:amount_entered forService:serviceName];
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [discountDelegate updateDiscount:self updateType:@"cancel" discountType:discountType amount:amount_entered forService:serviceName];
    }
}

@end
