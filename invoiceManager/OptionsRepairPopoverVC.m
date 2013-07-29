//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsRepairPopoverVC.h"

@interface OptionsRepairPopoverVC ()

@end

@implementation OptionsRepairPopoverVC

@synthesize notesField;
@synthesize itemName, price, notes;
@synthesize RVCDelegate;
@synthesize vacOrFull;
@synthesize quantityField;
@synthesize quantity;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    if ([self editMode]){
        
    } else {
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        itemName = @"empty";
        //vacOrFull = @"empty";
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"popover loaded !");
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// used to choose
-(IBAction) onClickingBtn: (id) sender {
    
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 5){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    //[btn setTitleColor:[UIColor colorWithWhite:94.0/255.0 alpha:100.0] forState:UIControlStateNormal];
                    [btn setTag:0];
                }
            }
        }
    }
    
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:5];           // TAG = 5 means that this button is SELECTED
    
    itemName = [[btnEx titleLabel] text];
    [self doCalculations];
}

// used to choose vac only or full clean
-(IBAction) onClickingBtnTwo: (id) sender {
    
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 25){    // TAG = 25 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    //[btn setTitleColor:[UIColor colorWithWhite:94.0/255.0 alpha:100.0] forState:UIControlStateNormal];
                    [btn setTag:20];
                }
            }
        }
    }
    
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    //NSString *btnTitle = [[btnEx titleLabel] text];
    //[btnEx setImage:[UIImage imageNamed:@"btnBackground2Sel.png" ] forState:UIControlStateNormal];
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:25];           // TAG = 25 means that this button is SELECTED
    
    vacOrFull = [[btnEx titleLabel] text];
    [self doCalculations];
}

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView {
    notesField.text = @"";
    notesField.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange: (UITextView*) textView {
    if (notesField.text.length == 0){
        notesField.textColor = [UIColor lightGrayColor];
        notesField.text = @"Place notes and comments here";
        [notesField resignFirstResponder];
    }
}

-(IBAction) onCustomEditingDone: (id) sender {
    
}

-(IBAction) doCalculations {
    //NSLog(@"quantity: %u", [[quantityField text] integerValue]);
    float pricePerItem = 0;
    if (vacOrFull && itemName) {
        //NSLog(@"vac or full is %@", vacOrFull);
        if ([itemName isEqualToString:@"King Size"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 79.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 119.0f;
            }
        } else if ([itemName isEqualToString:@"Double"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 69.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 109.0f;
            }
        } else if ([itemName isEqualToString:@"Queen Size"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 59.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 79.0f;
            }
        }
        quantity = [[quantityField text] integerValue];
        price = pricePerItem * quantity;
        [priceLabel setText:[NSString stringWithFormat:@"$ %0.02f", price ]];
    } else {
        [priceLabel setText:@"$ 0.0"];
    }
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notes = notesField.text;
    NSLog(@" quantity is %u", [[quantityField text] integerValue]);
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        [RVCDelegate updateMatressDataTable:self editType:@"add" withItem:itemName withCleanType:vacOrFull andQuantity:quantity andPrice:price andNotes:notes];
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [RVCDelegate updateMatressDataTable:self editType:@"add" withItem:itemName withCleanType:vacOrFull andQuantity:quantity  andPrice:price andNotes:notes];
    }
}



@end
