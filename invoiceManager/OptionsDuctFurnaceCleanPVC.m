//  OptionsDuctFurnaceCleanPVC.m
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import "OptionsDuctFurnaceCleanPVC.h"

@interface OptionsDuctFurnaceCleanPVC ()

@end

@implementation OptionsDuctFurnaceCleanPVC

@synthesize ADelegate;
@synthesize scrollViewer, furnacesScroller;
@synthesize price, notesAboutRoom, priceRate, priceLabel, serviceType, serviceTypeRestorationID;
@synthesize quantity, houseArea, houseAreaPrice;
@synthesize quantityField, numberOfFurnacesField, houseAreaField, houseAreaCustomPrice;
@synthesize numberOfFurnaces;
@synthesize houseAreaOneBtn, houseAreaTwoBtn, houseAreaThreeBtn, houseAreaFourBtn;
@synthesize numberOfFurnacesCustomBtn;
@synthesize brushCleanAddon;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 6540)];
    
    [furnacesScroller setScrollEnabled:YES];
    [furnacesScroller setContentSize:CGSizeMake(358, 564)];
    [furnacesScroller flashScrollIndicators];
    
    [self setNumberOfFurnaces:1];
    [self setBrushCleanAddon:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// restore the selected gui buttons to the ones saved in the 'editingCell'
-(void) restoreSavedSelections {
    
    // de-select all buttons with a specific tag and select the ones that were saved
    for (UIButton *v in scrollViewer.subviews) {
        if ([v isKindOfClass:[UIButton class]]){
            if ( ([v tag] == 5) || ([v tag] == 10) ){
                [v setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
            if ([[v restorationIdentifier] isEqualToString:[editingCell materialType]]){
                [v setTag:10];
                [v setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    [self setQuantity:[editingCell quantity]];
    [self setNotesAboutRoom:[editingCell notes]];
    [priceLabel setText:[NSString stringWithFormat:@"$%.02f", [editingCell price]]];
    [quantityField setText:[NSString stringWithFormat:@"%d", [editingCell quantity]]];
    
    // restore the notes saved
    [notesField setText:[editingCell notes]];
}

// action for choosing a number of furnaces, either selecting a button or writing a number in the custom textfield
// tag = 20 for the selected one, tag = 19 for the unselected ones
-(IBAction) onChoosingNumberOfFurnaces: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview in scrollViewer.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 20){
                [aSubview setTag:19];
                [aSubview setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
    [sender setTag:20];
    
    if ([[sender restorationIdentifier] isEqualToString:@"oneFurnace"]){
        [self setNumberOfFurnaces:1];
    } else if ([[sender restorationIdentifier] isEqualToString:@"twoFurnace"]){
        [self setNumberOfFurnaces:2];
    } else if ([[sender restorationIdentifier] isEqualToString:@"threeFurnace"]){
        [self setNumberOfFurnaces:3];
    } else if ([[sender restorationIdentifier] isEqualToString:@"fourFurnace"]){
        [self setNumberOfFurnaces:[[numberOfFurnacesField text] integerValue]];
    }
    
    NSLog(@"number of furnaces is %u", [self numberOfFurnaces]);
}

-(IBAction) onChangeNumberOfFurnacesField: (id) sender {
    for (UIButton *aSubview in scrollViewer.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 20){
                [aSubview setTag:19];
                [aSubview setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
        }
    }
     
    [numberOfFurnacesCustomBtn setTag:20];
    [numberOfFurnacesCustomBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
    [self setNumberOfFurnaces:[[numberOfFurnacesField text] integerValue]];
    
    NSLog(@"number of furnaces is %u", [self numberOfFurnaces]);
}

// brush clean addon button (if selected, tag = 9, if not selected, tag = 8)
-(IBAction)onChoosingAnyBtn:(id)sender {
    if ([[sender restorationIdentifier] isEqualToString:@"brushCleanBtn"]){
        if ([sender tag] == 8){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:9];
            [self setBrushCleanAddon:TRUE];
        } else if ([sender tag] == 9){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:8];
            [self setBrushCleanAddon:FALSE];
        }
    }
}

// House Area, selecting a button (price), entering a custom price, or entering the house's square feet ( which will auto select )
-(IBAction) onChoosingHouseAreaBtn: (id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"houseAreaOne"]){
        
        [self setHouseAreaPrice:249.95f];
    } else if ([[sender restorationIdentifier] isEqualToString:@"houseAreaTwo"]){
        [self setHouseAreaPrice:279.95f];
    } else if ([[sender restorationIdentifier] isEqualToString:@"houseAreaThree"]){
        [self setHouseAreaPrice:309.95f];
    } else if ([[sender restorationIdentifier] isEqualToString:@"houseAreaFour"]){
        [self setHouseAreaPrice:[[houseAreaCustomPrice text] floatValue]];
    }
    
    [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    
    [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
    NSLog(@"THE PRICE IS %f", [self houseAreaPrice]);
}

-(IBAction) onChangeHouseAreaField: (id) sender {
    UITextField *houseAreaCustomField = (UITextField *) sender;
    
    if ([[sender restorationIdentifier] isEqualToString:@"houseAreaSquareFeet"]){
        [self setHouseArea:[[houseAreaCustomField text] floatValue]];
        
        if ([self houseArea] < 1600){
            [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [self setHouseAreaPrice:249.95f];
        } else if ( ([self houseArea] > 1599) && ([self houseArea] < 2300)){
            [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [self setHouseAreaPrice:279.95f];
        } else if ([self houseArea] > 2299){
            [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [self setHouseAreaPrice:309.95f];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"houseAreaCustomPrice"]){
        [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
        [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
        [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
        [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
        [self setHouseAreaPrice:[[houseAreaCustomPrice text] floatValue]];
    }
    NSLog(@"THE PRICE IS %f", [self houseAreaPrice]);
}

-(IBAction) addFurnace: (id) sender {
    [self setNumberOfFurnaces:([self numberOfFurnaces] + 1)];
    NSInteger tagForFurnace = 100 + 10 * [self numberOfFurnaces];
    
    UILabel* furnaceTitle = [[[UILabel alloc] initWithFrame:CGRectMake(31, 55, 128, 36)] autorelease];
    [furnaceTitle setText:@"Furnace 1"];
    [furnaceTitle setBackgroundColor:[UIColor clearColor]];
    [furnaceTitle setTag:tagForFurnace];
    [furnacesScroller addSubview:furnaceTitle];
    
    UIImageView *horizLine = [[[UIImageView alloc] initWithFrame:CGRectMake(24, 87, 556, 4)] autorelease];
    [horizLine setImage:[UIImage imageNamed:@"horizontalLine.png"]];
    [horizLine setBackgroundColor:[UIColor clearColor]];
    [horizLine setTag:tagForFurnace];
    [furnacesScroller addSubview:horizLine];
    
    UILabel *makeLabel = [[[UILabel alloc] initWithFrame:CGRectMake(31, 55, 128, 36)] autorelease];
    [furnaceTitle setText:@"Make"];
    [furnaceTitle setBackgroundColor:[UIColor clearColor]];
    [furnaceTitle setTag:tagForFurnace];
    [furnacesScroller addSubview:furnaceTitle];
}

// only supports UIButton's right now
-(IBAction) onChoosingServiceType: (id) sender {
    // set last selected back to normal
    for (UIButton *aSubview in scrollViewer.subviews){
        if ([aSubview isKindOfClass:[UIButton class]]){
            if ([aSubview tag] == 10){
                [aSubview setTag:5];
                [aSubview setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    // put background image view under the newly selected button
    UIButton *btn = (UIButton*)sender;
    NSString *senderID = [btn restorationIdentifier];
    [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
    
    // save the restoration id of the button selected
    [self setServiceTypeRestorationID:senderID];
    
    if ([senderID isEqualToString:@"firstRockChip"]){
        [self setPriceRate:30.0f];
        [self setServiceType:@"1st Rock Chip"];
    } else if ([senderID isEqualToString:@"secondRockChip"]){
        [self setPriceRate:15.00f];
        [self setServiceType:@"2nd Rock Chip"];
    } else if ([senderID isEqualToString:@"additionalRockChip"]){
        [self setPriceRate:15.00f];
        [self setServiceType:@"Additional Rock Chip"];
    } else if ([senderID isEqualToString:@"windshieldCrack"]){
        [self setPriceRate:50.00f];
        [self setServiceType:@"Windshield Crack"];
    } else if ([senderID isEqualToString:@"windshieldCrackRockChip"]){
        [self setPriceRate:65.00f];
        [self setServiceType:@"Windshield Crack + 1 Rock Chip"];
    }
    
    [btn setTag:10];
    
    [self doCalculations];
}

-(IBAction) quantityChanged: (id) sender {
    UITextField* qField = (UITextField*) sender;
    // NSLog(@"the quantity is %ld", (long)[[qField text] integerValue]);
    [self setQuantity:[[qField text] integerValue]];
    [self doCalculations];
}

-(void) doCalculations {
    // if quantity is > 0
    if ([self quantity] && [self serviceType]){
        //NSLog(@"GOT HERE? price rate is %f", [self priceRate]);
        [self setPrice: ([self priceRate] * [self quantity]) ];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price] ]];
    } else {
        
        [self setPrice:0.0f];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price]]];
    }
    
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notesAboutRoom = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"autoSpa";
        newCell.name = [self serviceType];  // '1st Rock Chip', '2nd Rock Chip', 'Additional Rock Chip', etc..
        newCell.materialType = [self serviceTypeRestorationID]; // 'firstRockChip', 'secondRockChip', etc
        newCell.quantity = [self quantity];
        newCell.priceRate = [self priceRate];
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"add" withServiceCell:newCell];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"autoSpa"];
        [[self editingCell] setName:[self serviceType]];
        [[self editingCell] setMaterialType:[self serviceTypeRestorationID]];
        [[self editingCell] setQuantity:[self quantity]];
        [[self editingCell] setPriceRate:[self priceRate]];
        [[self editingCell] setPrice:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}



@end
