//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsFloodPopoverVC.h"

@interface OptionsFloodPopoverVC ()

@end

@implementation OptionsFloodPopoverVC

@synthesize quantity, quantity2, itemName, notes, vacOrFull, price, rate_price;
@synthesize priceRateLabel, quantityLabel, quantityLabel2;
@synthesize notesField;
@synthesize priceRateField, quantityField, quantityField2, priceLabel;
@synthesize FVCDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewDidAppear:(BOOL)animated {
    notesField.text = @"Place notes and comments here";
    notesField.textColor = [UIColor lightGrayColor];
    [notesField setDelegate:self];
    itemName = @"empty";
    //vacOrFull = @"empty";
    
    //[noOfItems setHidden:TRUE];
    //[noOfItemsLabel setHidden:TRUE];
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

/*
-(IBAction) showHumidAndBlowers: (id) sender {
    [noOfItems setHidden:FALSE];
    [noOfItemsLabel setHidden:FALSE];
    [noOfItemsLabel setText:@"quantity"];
    [noOfHours setHidden:TRUE];
    [noOfHoursLabel setHidden:TRUE];
}

-(IBAction) showOthers: (id) sender {
    [noOfItemsLabel setText:@"rate per sq. feet ($/sq feet)"];
    if ([[[sender titleLabel] text] isEqualToString:@"Water Extraction"] || [[[sender titleLabel] text] isEqualToString:@"Demolition"]){
        [noOfItemsLabel setText:@"rate per hr ($/hr)"];
    }
    //NSLog();
    [noOfItems setHidden:FALSE];
    [noOfItemsLabel setHidden:FALSE];
    [noOfHours setHidden:FALSE];
    [noOfHoursLabel setHidden:FALSE];
}
*/

-(IBAction) onSelectingType:(id)sender {
    [priceRateField setHidden:FALSE];
    [quantityLabel setHidden:FALSE];
    [quantityLabel2 setHidden:FALSE];
    [quantityField2 setHidden:FALSE];
    if ([itemName isEqualToString:@"Blowers"] || [itemName isEqualToString:@"Dehumidifiers"]){
        NSLog(@"heeey");
        [priceRateLabel setText:@"rate per day"];
        [quantityLabel setText:@"# of days"];
        
        if ([itemName isEqualToString:@"Dehumidifiers"]){
            [quantityLabel2 setText:@"# of dehumidifiers"];
        } else {
            [quantityLabel2 setText:@"# of blowers"];
        }
    } else if ([itemName isEqualToString:@"Biocide Application"]){
        [priceRateLabel setText:@"rate per sq.ft. ($/sq. ft.)"];
        [quantityLabel setText:@"square feet"];
        [quantityLabel2 setHidden:TRUE];
        [quantityField2 setHidden:TRUE];
    } else {
        [priceRateLabel setText:@"rate per hr ($/hr)"];
        [quantityLabel setText:@"# of hours"];
        [quantityLabel2 setHidden:TRUE];
        [quantityField2 setHidden:TRUE];
    }
    [self doCalculations];
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
    NSLog(@"%@", itemName);
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

-(IBAction) doCalculations {
    if (itemName){
        if ([itemName isEqualToString:@"Blowers"]){
            //pricePerItem = 30.0f;
            rate_price = [[priceRateField text] floatValue];
            quantity = [[quantityField text] integerValue];     // # of days
            quantity2 = [[quantityField2 text] integerValue];   // # of blowers/humidifiers
            price = rate_price * quantity * quantity2;
            //rate_price = 30.0f;
        } else if ([itemName isEqualToString:@"Dehumidifiers"]){
            //pricePerItem = 100.0f;
            rate_price = [[priceRateField text] floatValue];
            quantity = [[quantityField text] integerValue];     // # of days
            quantity2 = [[quantityField2 text] integerValue];   // # of blowers/humidifiers
            price = rate_price * quantity * quantity2;
        } else if ([itemName isEqualToString:@"Biocide Application"]){
            rate_price = [[priceRateField text] floatValue];
            quantity = [[quantityField text] integerValue];
            price = rate_price * quantity;
        } else if ([itemName isEqualToString:@"Demolition"]){
            rate_price = [[priceRateField text] floatValue];
            quantity = [[quantityField text] integerValue];
            price = rate_price * quantity;
        } else if ([itemName isEqualToString:@"Water Extraction"]){
            rate_price = [[priceRateField text] floatValue];
            quantity = [[quantityField text] integerValue];
            price = rate_price * quantity;
        }
    }
    [priceLabel setText:[NSString stringWithFormat:@"$ %.02f", price]];
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notes = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        //[FVCDelegate updateFloodDataTable:self editType:@"add" withItemName:itemName withRate:rate_price withQuantity:quantity withQuantity2: quantity2 withPrice:price andNotes:notes];
        
        
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        
        newCell.serviceType = @"floodcleanup";
        newCell.notes = notes;
        newCell.name = itemName;
        newCell.quantity = quantity;
        newCell.quantity2 = quantity2;
        newCell.ratePerHr = rate_price;
        newCell.price = price;
        [FVCDelegate updateFloodServicesDataTable:self editType:@"add" withServiceCell:newCell];
        //[FVCDelegate updateFloodDataTable:self editType:@"add" withItemName:nil withRate:0.0f withQuantity:0 withPrice:price andNotes:nil];
         
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [FVCDelegate updateFloodServicesDataTable:self editType:@"cancel" withServiceCell:nil];
        //[FVCDelegate updateFloodDataTable:self editType:@"cancel" withItemName:nil withRate:0.0f withQuantity:0 withQuantity2:0 withPrice:price andNotes:nil];
    }
}



@end
