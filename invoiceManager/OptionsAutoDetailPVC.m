//
//  OptionsAutoSpaPopoverVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsAutoDetailPVC.h"

@interface OptionsAutoDetailPVC ()

@end

@implementation OptionsAutoDetailPVC

@synthesize selectedCarBg;
@synthesize SSVCDelegate;
@synthesize scrollViewer;
@synthesize price, notesAboutRoom, priceRate, priceLabel, carType, packageType;
//@synthesize notesField;
@synthesize packageTypeLabel;
@synthesize quantity;
@synthesize quantityField;

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
    [self setCarType:@"dayCab"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 3850)];
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
                    if ([[editingCell itemAttribute] isEqualToString:@"dayCab"]){
                        [selectedCarBg setFrame:CGRectMake(75.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
                    } else if ([[editingCell itemAttribute] isEqualToString:@"sleeperUnit"]){
                        [selectedCarBg setFrame:CGRectMake(468.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
                    }
                }
            }
        }
    }
    
    [packageTypeLabel setText:[editingCell name]];
    if ([[editingCell name] isEqualToString:@"completeExtWash"]){
        [packageTypeLabel setText:@"Complete Exterior Wash"];
    } else if ([[editingCell name] isEqualToString:@"completeExtDetail"]){
        [packageTypeLabel setText:@"Complete Exterior Detail"];
    } else if ([[editingCell name] isEqualToString:@"completeIntDetail"]){
        [packageTypeLabel setText:@"Complete Interior Detail"];
    } else if ([[editingCell name] isEqualToString:@"completeFullDetail"]){
        [packageTypeLabel setText:@"Complete Full Detail"];
    }
    
    [priceLabel setText:[NSString stringWithFormat:@"%.02f", [editingCell price]]];
    [quantityField setText:[NSString stringWithFormat:@"%d", [editingCell quantity]]];
    // restore the notes saved
    [notesField setText:[editingCell notes]];
}

-(IBAction) onChoosingPackageType:(id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"completeExtWash"]){
        [packageTypeLabel setText:@"Complete Exterior Wash"];
        [self setPackageType:@"completeExtWash"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"completeExtDetail"]){
        [packageTypeLabel setText:@"Complete Exterior Detail"];
        [self setPackageType:@"completeExtDetail"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"completeIntDetail"]){
        [packageTypeLabel setText:@"Complete Interior Detail"];
        [self setPackageType:@"completeIntDetail"];
    } else if ([[sender restorationIdentifier] isEqualToString:@"completeFullDetail"]){
        [packageTypeLabel setText:@"Complete Full Detail"];
        [self setPackageType:@"completeFullDetail"];
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
                //NSLog(@"hi, %@, %u", [aSubview restorationIdentifier], [aSubview tag]);
                //[aSubview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [aSubview setTag:0];
            }
            NSLog(@"ID: %@", [aSubview restorationIdentifier]);
        }
        //}
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    
    if ([senderID isEqualToString:@"dayCab"]){
        [selectedCarBg setFrame:CGRectMake(75.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
        [self setCarType:@"dayCab"];
    } else if ([senderID isEqualToString:@"sleeperUnit"]){
        [selectedCarBg setFrame:CGRectMake(468.0f, selectedCarBg.frame.origin.y, selectedCarBg.frame.size.width, selectedCarBg.frame.size.height)];
        [self setCarType:@"sleeperUnit"];
    }
    [btn setTag:10];
    //NSLog(@"%@ has tag 10 !", );
    
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
        if ([[self packageType] isEqualToString:@"completeExtWash"]){
            if ([[self carType] isEqualToString:@"dayCab"]){
                [self setPriceRate:299.95f];
            } else if ([[self carType] isEqualToString:@"sleeperUnit"]){
                [self setPriceRate:399.95f];
            }
        } else if ([[self packageType] isEqualToString:@"completeExtDetail"]){
            if ([[self carType] isEqualToString:@"dayCab"]){
                [self setPriceRate:349.95f];
            } else if ([[self carType] isEqualToString:@"sleeperUnit"]){
                [self setPriceRate:499.95f];
            }
        } else if ([[self packageType] isEqualToString:@"completeIntDetail"]){
            if ([[self carType] isEqualToString:@"dayCab"]){
                [self setPriceRate:349.95f];
            } else if ([[self carType] isEqualToString:@"sleeperUnit"]){
                [self setPriceRate:499.95f];
            }
        } else if ([[self packageType] isEqualToString:@"completeFullDetail"]){
            if ([[self carType] isEqualToString:@"dayCab"]){
                [self setPriceRate:599.95f];
            } else if ([[self carType] isEqualToString:@"sleeperUnit"]){
                [self setPriceRate:899.95f];
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
        
        [SSVCDelegate updateSemiSpaDataTable:self editType:@"add" withServiceCell:newCell];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self packageType]];
        [[self editingCell] setItemAttribute:[self carType]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        
        [SSVCDelegate updateSemiSpaDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [SSVCDelegate updateSemiSpaDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
