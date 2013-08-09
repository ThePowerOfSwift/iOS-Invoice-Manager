//
//  OptionsAutoSpaPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsAutoSpaPVC.h"

@interface OptionsAutoSpaPVC ()

@end

@implementation OptionsAutoSpaPVC

@synthesize selectedCarBg;
@synthesize ASVCDelegate;
@synthesize scrollViewer;
@synthesize price, notesAboutRoom, priceRate, priceLabel, carType, packageType;
//@synthesize notesField;
@synthesize packageTypeLabel;
@synthesize quantity, quantityField;

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
        //[self doCalculations];  // do calculations in case some variables changes ( rate per square feet )
        [self restoreSavedSelections];
    } else {
        // set up the notes field
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        price = 0;
        
    }
    
    // set initial selected options
    [self setCarType:@"Compact"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set up the scroll view
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 3100)];
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
                NSLog(@"Attribute is %@", [editingCell itemAttribute]);
                if ([[btn restorationIdentifier] isEqualToString:[editingCell itemAttribute]]){
                    [btn setTag:10];
                    if ([[editingCell itemAttribute] isEqualToString:@"SUV"]){
                        [selectedCarBg setFrame:CGRectMake(466.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
                    } else if ([[editingCell itemAttribute] isEqualToString:@"Compact"]){
                        [selectedCarBg setFrame:CGRectMake(75.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
                    } else if ([[editingCell itemAttribute] isEqualToString:@"Midsize"]){
                        [selectedCarBg setFrame:CGRectMake(75.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
                    }
                }
            }
        }
    }
    
    [packageTypeLabel setText:[editingCell name]];
    /*if ([[editingCell name] isEqualToString:@"bronze"]){
        [packageTypeLabel setText:@"Bronze"];
    } else if ([[editingCell name] isEqualToString:@"silver"]){
        [packageTypeLabel setText:@"Silver"];
    } else if ([[editingCell name] isEqualToString:@"gold"]){
        [packageTypeLabel setText:@"Gold"];
    } else if ([[editingCell name] isEqualToString:@"platinum"]){
        [packageTypeLabel setText:@"Platinum"];
    }*/
    
    [priceLabel setText:[NSString stringWithFormat:@"%.02f", [editingCell price]]];
    [quantityField setText:[NSString stringWithFormat:@"%d", [editingCell quantity]]];
    // restore the notes saved
    [notesField setText:[editingCell notes]];
}

-(IBAction) onChoosingPackageType:(id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"bronze"]){
        [packageTypeLabel setText:@"Bronze"];
        [self setPackageType:@"Bronze"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"silver"]){
        [packageTypeLabel setText:@"Silver"];
        [self setPackageType:@"Silver"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"gold"]){
        [packageTypeLabel setText:@"Gold"];
        [self setPackageType:@"Gold"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"platinum"]){
        [packageTypeLabel setText:@"Platinum"];
        [self setPackageType:@"Platinum"];
    }
    [self doCalculations];
}

// only supports UIButton's right now
-(IBAction) onChoosingCarType: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview in self.view.subviews){
        //for (id aSubview in aSubview2.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 10){                
                [aSubview setTag:0];
            }
        }
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    
    if ([senderID isEqualToString:@"SUV"]){
        [selectedCarBg setFrame:CGRectMake(466.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
        [self setCarType:@"SUV"];
    } else if ([senderID isEqualToString:@"Compact"]){
        [selectedCarBg setFrame:CGRectMake(75.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
        [self setCarType:@"Compact"];
    } else if ([senderID isEqualToString:@"Midsize"]){
        [selectedCarBg setFrame:CGRectMake(272.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
        [self setCarType:@"Midsize"];
    }
    [btn setTag:10];
    
    [self doCalculations];
}

-(IBAction) quantityChanged: (id) sender {
    UITextField* qField = (UITextField*) sender;
    NSLog(@"the quantity is %ld", (long)[[qField text] integerValue]);
    [self setQuantity:[[qField text] integerValue]];
    [self doCalculations];
}

-(void) doCalculations {
    // if quantity is > 0
    if ([self quantity] && [self packageType] && [self carType]){
        if ([[self packageType] isEqualToString:@"Bronze"]){
            if ([[self carType] isEqualToString:@"Compact"]){
                [self setPriceRate:49.95f];
            } else if ([[self carType] isEqualToString:@"Midsize"]){
                // N/A
                [self setPriceRate:0.0f];
            } else if ([[self carType] isEqualToString:@"SUV"]){
                [self setPriceRate:69.95f];
            }
        } else if ([[self packageType] isEqualToString:@"Silver"]){
            if ([[self carType] isEqualToString:@"Compact"]){
                [self setPriceRate:99.95f];
            } else if ([[self carType] isEqualToString:@"Midsize"]){
                // N/A
                [self setPriceRate:0.0f];
            } else if ([[self carType] isEqualToString:@"SUV"]){
                [self setPriceRate:129.95f];
            }
        } else if ([[self packageType] isEqualToString:@"Gold"]){
            if ([[self carType] isEqualToString:@"Compact"]){
                [self setPriceRate:199.95f];
            } else if ([[self carType] isEqualToString:@"Midsize"]){
                [self setPriceRate:249.95f];
            } else if ([[self carType] isEqualToString:@"SUV"]){
                [self setPriceRate:289.95f];
            }
        } else if ([[self packageType] isEqualToString:@"Platinum"]){
            if ([[self carType] isEqualToString:@"Compact"]){
                [self setPriceRate:349.95f];
            } else if ([[self carType] isEqualToString:@"Midsize"]){
                [self setPriceRate:399.95f];
            } else if ([[self carType] isEqualToString:@"SUV"]){
                [self setPriceRate:449.95f];
            }
        }
        [self setPrice: ([self priceRate] * [self quantity]) ];
        [[self priceLabel] setText:[NSString stringWithFormat:@"%.02f", [self price] ]];
    } else {
        [self setPriceRate:0.0f];
        [self setPrice:0.0f];
        [[self priceLabel] setText:[NSString stringWithFormat:@"%.02f", [self price]]];
    }
    
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notesAboutRoom = notesField.text;
    NSLog(@"hekki wirkd");
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"autoSpa";
        newCell.name = [self packageType];
        newCell.itemAttribute = [self carType];
        newCell.quantity = [self quantity];
        newCell.priceRate = [self priceRate];
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        
        NSLog(@"SENT UPDATE ?");
        [ASVCDelegate updateAutoSpaDataTable:self editType:@"add" withServiceCell:newCell];

    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self packageType]];
        [[self editingCell] setItemAttribute:[self carType]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        
        [ASVCDelegate updateAutoSpaDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ASVCDelegate updateAutoSpaDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
