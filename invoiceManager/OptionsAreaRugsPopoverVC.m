//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsAreaRugsPopoverVC.h"

@interface OptionsAreaRugsPopoverVC ()

@end

@implementation OptionsAreaRugsPopoverVC

@synthesize quantity, quantity2, itemName, notes, vacOrFull, price, rate_price, itemType;
@synthesize priceRateLabel, quantityLabel, quantityLabel2;
@synthesize notesField;
@synthesize priceRateField, quantityField, quantityField2, priceLabel;
@synthesize ARVCDelegate;
@synthesize addonDeodorizer, addonFabricSoftener, addonBiocide;

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
        [saveOrEditBtn setRestorationIdentifier:@"edit"];
        [saveOrEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        itemName = @"";
        itemType = @"";
        //vacOrFull = @"empty";
        
        //[noOfItems setHidden:TRUE];
        //[noOfItemsLabel setHidden:TRUE];
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

-(IBAction) onSelectingType:(id)sender {
    [priceRateField setHidden:FALSE];
    [quantityLabel setHidden:FALSE];
    [quantityLabel2 setHidden:FALSE];
    [quantityField2 setHidden:FALSE];
    if ([itemName isEqualToString:@"Blowers"] || [itemName isEqualToString:@"Dehumidifiers"]){
        NSLog(@"heeey");
        [priceRateLabel setText:@"rate per day"];
        [quantityLabel setText:@"# of days"];
        [quantityLabel2 setText:@"# of blowers"];
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
    
    itemType = [[btnEx titleLabel] text];
    NSLog(@"item type: %@", itemType);
    [self doCalculations];
}

-(IBAction)onCustomEditingDone:(id)sender {
    //if ([[sender restorationIdentifier] isEqualToString:@"quantity"]){
    quantity = [[quantityField text] integerValue];
    NSLog(@"quantity: %u", quantity);
    [self doCalculations];
    //}
}

-(IBAction) saveAddon:(id)sender {
    if ([[sender restorationIdentifier] isEqualToString:@"deodorizer"]) {
        if (addonDeodorizer){
            addonDeodorizer = FALSE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            addonDeodorizer = TRUE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"fabricProtector"]) {
        if (addonFabricSoftener){
            addonFabricSoftener = FALSE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            addonFabricSoftener = TRUE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"biocide"]) {
        if (addonBiocide){
            addonBiocide = FALSE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            addonBiocide = TRUE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
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
    float pricePerItem = 0.0f;
    // increase price rate if any addons are selected
    float deod = 0.10f;
    float biocide = 0.15f;
    float fabric = 0.15f;
    
    if (itemName && itemType && quantity){
        if ([itemName isEqualToString:@"2x3"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 5.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 15.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 6);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 6);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 6);
            }
        } else if ([itemName isEqualToString:@"2x4"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 10.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 25.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 8);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 8);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 8);
            }
        } else if ([itemName isEqualToString:@"4x6"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 25.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 59.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 24);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 24);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 24);
            }
        } else if ([itemName isEqualToString:@"5x7"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 35.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 89.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 35);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 35);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 35);
            }
        } else if ([itemName isEqualToString:@"6x9"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 55.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 99.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 45);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 45);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 45);
            }
        } else if ([itemName isEqualToString:@"8x10"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 99.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 129.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 80);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 80);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 80);
            }
        } else if ([itemName isEqualToString:@"9x12"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 129.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 229.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 108);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 108);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 108);
            }
        } else if ([itemName isEqualToString:@"12x15"]){
            if ([itemType isEqualToString:@"synthetic"]){
                pricePerItem = 250.0f;
            } else if ([itemType isEqualToString:@"wool"]){
                pricePerItem = 450.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + (biocide * 180);
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + (deod * 180);
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + (fabric * 180);
            }
        }
    }
    price = pricePerItem * quantity;
    [priceLabel setText:[NSString stringWithFormat:@"$ %.02f", price]];
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notes = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        //[ARVCDelegate updateFloodDataTable:self editType:@"add" withItemName:itemName withRate:rate_price withQuantity:quantity withQuantity2: quantity2 withPrice:price andNotes:notes];
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        
        newCell.serviceType = @"areaRugs";
        newCell.name = itemName;
        newCell.materialType = itemType;
        newCell.quantity = quantity;
        newCell.price = price;
        newCell.notes = notes;
        newCell.addonBiocide = addonBiocide;
        newCell.addonDeodorizer = addonDeodorizer;
        newCell.addonFabricProtector = addonFabricSoftener;
        [ARVCDelegate updateAreaRugsDataTable:self editType:@"add" withServiceCell:newCell];
        //[FVCDelegate updateFloodDataTable:self editType:@"add" withItemName:nil withRate:0.0f withQuantity:0 withPrice:price andNotes:nil];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        //[ARVCDelegate updateAreaRugsDataTable:self editType:@"cancel" withServiceCell:nil];
        // [ARVCDelegate updateFloodDataTable:self editType:@"cancel" withItemName:nil withRate:0.0f withQuantity:0 withQuantity2:0 withPrice:price andNotes:nil];
        
        self.editingCell.serviceType = @"areaRugs";
        self.editingCell.name = itemName;
        self.editingCell.materialType = itemType;
        self.editingCell.quantity = quantity;
        self.editingCell.price = price;
        self.editingCell.notes = notes;
        self.editingCell.addonBiocide = addonBiocide;
        self.editingCell.addonDeodorizer = addonDeodorizer;
        self.editingCell.addonFabricProtector = addonFabricSoftener;
        [ARVCDelegate updateAreaRugsDataTable:self editType:@"edit" withServiceCell:nil];
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ARVCDelegate updateAreaRugsDataTable:self editType:@"cancel" withServiceCell:nil];
        // [ARVCDelegate updateFloodDataTable:self editType:@"cancel" withItemName:nil withRate:0.0f withQuantity:0 withQuantity2:0 withPrice:price andNotes:nil];
    }
}



@end
