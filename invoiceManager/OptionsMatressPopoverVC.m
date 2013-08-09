//
//  OptionsPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsMatressPopoverVC.h"

@interface OptionsMatressPopoverVC ()

@end

@implementation OptionsMatressPopoverVC

//@synthesize notesField;
@synthesize itemName, price, notes;
@synthesize MVCDelegate;
@synthesize vacOrFull;
@synthesize quantityField;
@synthesize quantity;
@synthesize addonBiocide, addonFabricProtector, addonDeodorizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    
}

-(void) viewDidAppear:(BOOL)animated {
    if ([self editMode]){
        [saveOrEditBtn setRestorationIdentifier:@"edit"];
        [saveOrEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [self restoreSavedSelections];
    } else {
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        itemName = @"empty";
        notes = @"";
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

// restore the selected gui buttons to the ones saved in the 'editingCell'
-(void) restoreSavedSelections {
    
    // de-select all buttons with a specific tag and select the ones that were saved
    for (UIButton *v in self.view.subviews) {
        for (UIButton *btn in v.subviews){
            if ([btn isKindOfClass:[UIButton class]]){
                if ([btn tag] == 5){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTag:0];
                }
                
                if ([btn tag] == 25){    // TAG = 5 means that this button is SELECTED
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [btn setTag:20];
                }
                
                // select the room name/ stairs button which is set in the editing cell
                if ([[[btn titleLabel] text] isEqualToString:[editingCell name]]){
                    [btn setTag:5];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                // select the room name/ stairs button which is set in the editing cell
                if ([[[btn titleLabel] text] isEqualToString:[editingCell vacOrFull]]){
                    [btn setTag:25];
                    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                
                // restore the addon's ( as selected or not ) based on the editing cell
                if ([[btn restorationIdentifier] isEqualToString:@"deodorizer"]){
                    if ([editingCell addonDeodorizer]){
                        addonDeodorizer = TRUE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        addonDeodorizer = FALSE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    }
                } else if ([[btn restorationIdentifier] isEqualToString:@"fabricProtector"]){
                    if ([editingCell addonFabricProtector]){
                        addonFabricProtector = TRUE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        addonFabricProtector = FALSE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    }
                } else if ([[btn restorationIdentifier] isEqualToString:@"biocide"]){
                    if ([editingCell addonBiocide]){
                        addonBiocide = TRUE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5Sel.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    } else {
                        addonBiocide = FALSE;
                        [btn setBackgroundImage:[UIImage imageNamed:@"btnBackground5.png"] forState:UIControlStateNormal];
                        [btn setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
    
    // restore the quantity saved
    [quantityField setText:[NSString stringWithFormat:@"%ld",(long)[editingCell quantity] ]];
    
    // restore the notes saved
    [notesField setText:[editingCell notes]];
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

-(IBAction) onCustomEditingDone: (id) sender {
    
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
        if (addonFabricProtector){
            addonFabricProtector = FALSE;
            [sender setBackgroundImage:[UIImage imageNamed:@"btnBackground2.png"] forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else {
            addonFabricProtector = TRUE;
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

-(IBAction) doCalculations {
    float pricePerItem = 0;
    
    if (addonBiocide){
        
    }
    if (addonDeodorizer){
        
    }
    if (addonFabricProtector){
        
    }
    
    if (vacOrFull && itemName) {
        //NSLog(@"vac or full is %@", vacOrFull);
        if ([itemName isEqualToString:@"King Size"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 79.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 119.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 49.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 49.0f;
            }
            if (addonFabricProtector){
                pricePerItem = pricePerItem + 49.0f;
            }
        } else if ([itemName isEqualToString:@"Double"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 69.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 109.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 29.0f;
            }
            if (addonFabricProtector){
                pricePerItem = pricePerItem + 29.0f;
            }
        } else if ([itemName isEqualToString:@"Queen Size"]){
            if ([vacOrFull isEqualToString:@"power-vac only"]){
                pricePerItem = 59.0f;
            } else if ([vacOrFull isEqualToString:@"full clean"]){
                pricePerItem = 79.0f;
            }
            if (addonBiocide){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonDeodorizer){
                pricePerItem = pricePerItem + 39.0f;
            }
            if (addonFabricProtector){
                pricePerItem = pricePerItem + 39.0f;
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
        NSLog(@"Notes are: %@", notes);
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"mattress";
        newCell.quantity = quantity;
        newCell.name = itemName;
        newCell.price = price;
        newCell.vacOrFull = vacOrFull;
        newCell.notes = notes;
        newCell.addonBiocide = addonBiocide;
        newCell.addonDeodorizer = addonDeodorizer;
        newCell.addonFabricProtector = addonFabricProtector;
        
        [MVCDelegate updateMatressDataTable:self editType:@"add" withServiceCell:newCell];
        //[MVCDelegate updateMatressDataTable:self editType:@"add" withItem:itemName withCleanType:vacOrFull andQuantity:quantity andPrice:price andNotes:notes];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        //[MVCDelegate updateMatressDataTable:self editType:@"cancel" withServiceCell:nil];
        //[MVCDelegate updateMatressDataTable:self editType:@"cancel" withItem:itemName withCleanType:vacOrFull andQuantity:quantity  andPrice:price andNotes:notes];
        self.editingCell.serviceType = @"mattress";
        self.editingCell.quantity = quantity;
        self.editingCell.name = itemName;
        self.editingCell.price = price;
        self.editingCell.vacOrFull = vacOrFull;
        self.editingCell.notes = notes;
        self.editingCell.addonBiocide = addonBiocide;
        self.editingCell.addonDeodorizer = addonDeodorizer;
        self.editingCell.addonFabricProtector = addonFabricProtector;
        [MVCDelegate updateMatressDataTable:self editType:@"edit" withServiceCell:nil];
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [MVCDelegate updateMatressDataTable:self editType:@"cancel" withServiceCell:nil];
        //[MVCDelegate updateMatressDataTable:self editType:@"cancel" withItem:itemName withCleanType:vacOrFull andQuantity:quantity  andPrice:price andNotes:notes];
    }
}



@end
