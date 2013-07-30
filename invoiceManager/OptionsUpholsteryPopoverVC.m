//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsUpholsteryPopoverVC.h"

@interface OptionsUpholsteryPopoverVC ()

@end

@implementation OptionsUpholsteryPopoverVC

@synthesize UVCDelegate;
@synthesize notes, vacOrFull, materialType, quantity, price, itemName;
@synthesize notesField, priceLabel;
@synthesize addonBiocide, addonFabricSoftener, addonDeodorizer;

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
        // set up the notes field
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        itemName = @"";
        notes = @"";
        materialType = @"";
        quantity = 0;
        price = 0;
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

-(IBAction) onClickingBtn: (id) sender {
    
    // de-select all buttons with a specific tag
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
    
    // select the button the user clicked and set a specific tag for it
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    //[btnEx setImage:[UIImage imageNamed:@"btnBackground2Sel.png" ] forState:UIControlStateNormal];
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:5];           // TAG = 5 means that this button is SELECTED
    
    itemName = [[btnEx titleLabel] text];
    NSLog(@"item name is %@", itemName);
    [self doCalculations];
}

// choose material type
-(IBAction) onClickingBtnTwo: (id) sender {
    
    // de-select all buttons with a specific tag
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 25){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    //[btn setTitleColor:[UIColor colorWithWhite:94.0/255.0 alpha:100.0] forState:UIControlStateNormal];
                    [btn setTag:20];
                }
            }
        }
    }
    
    // select the button the user clicked and set a specific tag for it
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    //[btnEx setImage:[UIImage imageNamed:@"btnBackground2Sel.png" ] forState:UIControlStateNormal];
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:25];           // TAG = 5 means that this button is SELECTED
    
    materialType = [[btnEx titleLabel] text];
    if ([materialType isEqualToString:@"leather"]){
        [powerVacBtn setHidden:TRUE];
    } else {
        [powerVacBtn setHidden:FALSE];
    }
    [self doCalculations];
}

// choose clean type
-(IBAction) onClickingBtnThree: (id) sender {
    
    // de-select all buttons with a specific tag
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 35){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    //[btn setTitleColor:[UIColor colorWithWhite:94.0/255.0 alpha:100.0] forState:UIControlStateNormal];
                    [btn setTag:30];
                }
            }
        }
    }
    
    // select the button the user clicked and set a specific tag for it
    UIButton *btnEx = (UIButton*) sender;
    NSLog(@"title is: %@", [[btnEx titleLabel] text]);
    //[btnEx setImage:[UIImage imageNamed:@"btnBackground2Sel.png" ] forState:UIControlStateNormal];
    [btnEx setBackgroundImage:[UIImage imageNamed:@"btnBackground2Sel.png"] forState:UIControlStateNormal];
    [btnEx setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnEx setTag:35];           // TAG = 5 means that this button is SELECTED
    
    vacOrFull = [[btnEx titleLabel] text];
    [self doCalculations];
}

// ------------------------ UITextView procol implementation BELOW
// when the text view is getting edited, this will be called

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
// ------------------------ UITextView procol implementation ABOVE

-(IBAction) onCustomEditingDone: (id) sender {
    quantity = [[quantityField text] integerValue];
    [self doCalculations];
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

// FOR ottoman, recliner, chair, and sectional, and dining chairs small or large,  THERE IS NO LEATHER.
// LEATHER IS ONLY FOR sofa, loveseat and chair
-(void) doCalculations {
    quantity = [[quantityField text] integerValue];
    float pricePerItem = 0.0f;
    if (itemName && vacOrFull && materialType && quantity){
        if ([itemName isEqualToString:@"Sofa"]){
            if ([vacOrFull isEqualToString:@"full clean"]){
                if ([materialType isEqualToString:@"leather"]){
                    pricePerItem = 79.0f;
                } else if ([materialType isEqualToString:@"synthetic"]){
                    pricePerItem = 129.0f;
                } else if ([materialType isEqualToString:@"natural"]){
                    pricePerItem = 189.0f;
                } else if ([materialType isEqualToString:@"specialty"]){
                    pricePerItem = 229.0f;
                }
                if (addonBiocide){
                    pricePerItem = pricePerItem + 49.0f;
                }
                if (addonDeodorizer){
                    pricePerItem = pricePerItem + 49.0f;
                }
                if (addonFabricSoftener){
                    pricePerItem = pricePerItem + 49.0f;
                }
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 69.0f;
            }
        } else if ([itemName isEqualToString:@"Ottoman"]){
            pricePerItem = 29.0f;
            if (addonBiocide){
                pricePerItem = pricePerItem + 19.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 19.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 19.0f;
            }
        } else if ([itemName isEqualToString:@"Loveseat"]){
            if ([vacOrFull isEqualToString:@"full clean"]){
                if ([materialType isEqualToString:@"leather"]){
                    pricePerItem = 69.0f;
                } else if ([materialType isEqualToString:@"synthetic"]){
                    pricePerItem = 99.0f;
                } else if ([materialType isEqualToString:@"natural"]){
                    pricePerItem = 159.0f;
                } else if ([materialType isEqualToString:@"specialty"]){
                    pricePerItem = 189.0f;
                }
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 59.0f;
            }
            
            if (addonBiocide){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 39.0f;
            }
        } else if ([itemName isEqualToString:@"Recliner"]){ // material is irrelevant OR only synthetic
            if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 89.0f;   // ALL MATERIALS EXCEPT NO LEATHER FOR EITHER POWER VAC OR FULL CLEAN
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 39.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 39.0f;
            }
        } else if ([itemName isEqualToString:@"Chair"]){
            if ([vacOrFull isEqualToString:@"full clean"]){
                if ([materialType isEqualToString:@"leather"]){
                    pricePerItem = 59.0f;
                } else {
                    pricePerItem = 89.0f;
                }
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 39.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 29.0f;
            }
        } else if ([itemName isEqualToString:@"Sectional"]){
            if ([vacOrFull isEqualToString:@"full clean"]){     // NO LEATHER FOR THIS
                pricePerItem = 289.0f;
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 139.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 59.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 59.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 59.0f;
            }
        } else if ([itemName isEqualToString:@"Small Dining Chair"]){
            if ([vacOrFull isEqualToString:@"full clean"]){     // NO LEATHER FOR THIS
                pricePerItem = 15.0f;
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 5.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 29.0f;
            }
        } else if ([itemName isEqualToString:@"Large Dining Chair"]){
            if ([vacOrFull isEqualToString:@"full clean"]){     // NO LEATHER FOR THIS
                pricePerItem = 39.0f;
            } else if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 10.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonFabricSoftener){
                pricePerItem = pricePerItem + 29.0f;
            }
        }
    }
    quantity = [[quantityField text] integerValue];
    price = pricePerItem * quantity;
    [priceLabel setText:[NSString stringWithFormat:@"$ %0.02f", price ]];
}

-(IBAction) saveOrCancel: (id) sender {
    notes = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
         
        newCell.serviceType = @"upholstery";
        newCell.notes = notes;
        newCell.name = itemName;
        newCell.materialType = materialType;
        newCell.vacOrFull = vacOrFull;
        newCell.quantity = quantity;
        newCell.price = price;
        newCell.addonFabricProtector = addonFabricSoftener;
        newCell.addonDeodorizer = addonDeodorizer;
        newCell.addonBiocide = addonBiocide;
        
        [UVCDelegate updateUpholsteryDataTable:self editType:@"add" withServiceCell:newCell];
        //[UVCDelegate updateUpholsteryDataTable:self editType:@"add" withItemName:itemName withMaterialType:materialType withCleanType:vacOrFull andQuantity:quantity andPrice:price andNotes:notes];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        //[UVCDelegate updateUpholsteryDataTable:self editType:@"cancel" withServiceCell:nil];
        //[UVCDelegate updateUpholsteryDataTable:self editType:@"cancel" withItemName:nil withMaterialType:nil withCleanType:nil andQuantity:0 andPrice:0.0f andNotes:nil];
        
        self.editingCell.serviceType = @"upholstery";
        self.editingCell.notes = notes;
        self.editingCell.name = itemName;
        self.editingCell.materialType = materialType;
        self.editingCell.vacOrFull = vacOrFull;
        self.editingCell.quantity = quantity;
        self.editingCell.price = price;
        self.editingCell.addonFabricProtector = addonFabricSoftener;
        self.editingCell.addonDeodorizer = addonDeodorizer;
        self.editingCell.addonBiocide = addonBiocide;
        
        [UVCDelegate updateUpholsteryDataTable:self editType:@"edit" withServiceCell:nil];
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [UVCDelegate updateUpholsteryDataTable:self editType:@"cancel" withServiceCell:nil];
        //[UVCDelegate updateUpholsteryDataTable:self editType:@"cancel" withItemName:nil withMaterialType:nil withCleanType:nil andQuantity:0 andPrice:0.0f andNotes:nil];
    }
}



@end
