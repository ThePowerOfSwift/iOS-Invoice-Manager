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
@synthesize quantity, houseArea, houseAreaPrice, addonsOverallPrice;
@synthesize quantityField, numberOfFurnacesField, houseAreaField, houseAreaCustomPrice;
@synthesize numberOfFurnaces;
@synthesize houseAreaOneBtn, houseAreaTwoBtn, houseAreaThreeBtn, houseAreaFourBtn;
@synthesize numberOfFurnacesCustomBtn;
@synthesize brushCleanAddon;
@synthesize furnaceInformation, addonList, selectedAddonsList;
@synthesize intChimneyBtn;
@synthesize extChimneyBtn;
@synthesize chimneyAccess;
@synthesize itemDescrip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void) dealloc {
    [addonList dealloc];
    [furnaceInformation dealloc];
    [selectedAddonsList dealloc];
    [super dealloc];
}

-(void) viewWillAppear:(BOOL)animated {
    if ([self editMode]){
        [saveOrEditBtn setRestorationIdentifier:@"edit"];
        [saveOrEditBtn setTitle:@"Edit" forState:UIControlStateNormal];
        //[self doCalculations];  // do calculations in case some variables changes ( rate per square feet )
        [self restoreSavedSelections];
    } else {
        // set up the notes field
        [self setItemDescrip:@"initial !"];
        notesField.text = @"Place notes and comments here";
        notesField.textColor = [UIColor lightGrayColor];
        [notesField setDelegate:self];
        
        // init vars in case error occurs
        [self setPrice:0];
        [self setAddonsOverallPrice:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [scrollViewer setScrollEnabled:YES];
    [scrollViewer setContentSize:CGSizeMake(614, 4660)];
    
    [furnacesScroller setScrollEnabled:YES];
    [furnacesScroller setContentSize:CGSizeMake(358, 564)];
    [furnacesScroller flashScrollIndicators];
    
    if (!addonList) {
        furnaceInformation = [[NSMutableArray alloc] initWithCapacity:1];
        for (NSInteger i = 0; i < 6; i++){
            [furnaceInformation addObject:[NSString stringWithFormat:@""]];
        }
        
        addonList = [[NSMutableArray alloc] initWithCapacity:23];       // have to init at least 16; inserting objects at certain indices
        selectedAddonsList = [[NSMutableArray alloc] initWithCapacity:23];
        for (NSInteger i = 0; i < 24; i++){
            [addonList addObject:[NSString stringWithFormat:@""]];
            [selectedAddonsList addObject:[NSNumber numberWithBool:FALSE]];
        }
        
    }
    
    //[self setNumberOfFurnaces:1];
    //[self setBrushCleanAddon:FALSE];
    /*if ([self brushCleanAddon]){
        NSLog(@"brush clean is TRUE");
    } else {
        NSLog(@"brush clean is NOT TRUE");
    }*/
    NSLog(@"haha %u", [self numberOfFurnaces]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"PROBLEMS  WITH MEMOR Y!@!!");
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
    NSLog(@"I SHOULD BE UNSELECTED ! my tag is %u", [sender tag]);
    // if the button clicked is already 'selected' ( has tag = 20 ), then un-select it
    if ([sender tag] == 20){
        [self setNumberOfFurnaces:0];
        [(UIButton*) sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
        [sender setTag:19];
    } else {
        
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
        
        [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
        [sender setTag:20];
        NSLog(@"tag is %u", [sender tag]);
        
        if ([[sender restorationIdentifier] isEqualToString:@"oneFurnace"]){
            [self setNumberOfFurnaces:1];
        } else if ([[sender restorationIdentifier] isEqualToString:@"twoFurnace"]){
            [self setNumberOfFurnaces:2];
        } else if ([[sender restorationIdentifier] isEqualToString:@"threeFurnace"]){
            [self setNumberOfFurnaces:3];
        } else if ([[sender restorationIdentifier] isEqualToString:@"fourFurnace"]){
            [self setNumberOfFurnaces:[[numberOfFurnacesField text] integerValue]];
        }
    }
    
    [self calculateOverallPrice];
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
    
    [self calculateOverallPrice];
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
    
    [self calculateOverallPrice];
}

// House Area, selecting a button (price), entering a custom price, or entering the house's square feet ( which will auto select )
// tag = 6 is button is not selected, tag = 7 if it is selected
-(IBAction) onChoosingHouseAreaBtn: (id) sender {
    
    UIButton *houseAreaBtn = (UIButton*) sender;
    
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
    
    if ([houseAreaBtn tag] == 6){
        [houseAreaOneBtn setTag:6];
        [houseAreaTwoBtn setTag:6];
        [houseAreaThreeBtn setTag:6];
        [houseAreaFourBtn setTag:6];
        [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
        [houseAreaBtn setTag:7];
    } else if ([houseAreaBtn tag] == 7){
        [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
        [houseAreaBtn setTag:6];
        [self setHouseAreaPrice:0];
    }
    NSLog(@"THE PRICE IS %f", [self houseAreaPrice]);
    
    [self calculateOverallPrice];
}

-(IBAction) onChangeHouseAreaField: (id) sender {
    UITextField *houseAreaCustomField = (UITextField *) sender;
    
    // unselect all buttons, set their background image to 'UnSel', and set all their tags to 6
    [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
    [houseAreaOneBtn setTag:6];
    [houseAreaTwoBtn setTag:6];
    [houseAreaThreeBtn setTag:6];
    [houseAreaFourBtn setTag:6];
    
    if ([[sender restorationIdentifier] isEqualToString:@"houseAreaSquareFeet"]){
        [self setHouseArea:[[houseAreaCustomField text] floatValue]];
        
        if ([self houseArea] < 1600){
            [houseAreaOneBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaOneBtn setTag:7];
            [self setHouseAreaPrice:249.95f];
        } else if ( ([self houseArea] > 1599) && ([self houseArea] < 2300)){
            [houseAreaTwoBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaTwoBtn setTag:7];
            [self setHouseAreaPrice:279.95f];
        } else if ([self houseArea] > 2299){
            [houseAreaThreeBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [houseAreaThreeBtn setTag:7];
            [self setHouseAreaPrice:309.95f];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"houseAreaCustomPrice"]){
        [houseAreaFourBtn setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
        [houseAreaFourBtn setTag:7];
        [self setHouseAreaPrice:[[houseAreaCustomPrice text] floatValue]];
    }
    
    // add this to the price 
    //[self setPrice:([self price] + [self houseAreaPrice])];
    
    [self calculateOverallPrice];
    
    NSLog(@"THE PRICE IS %f", [self houseAreaPrice]);
}

// calculate the overall price !
-(void) calculateOverallPrice {
    // set price to 0 initially
    [self setPrice:0.0];
    [self setItemDescrip:@""];
    
    // adding the price of the house area ( if the 'whip clean' package is selected - otherwise, just addons should be considered )
    if ([self houseAreaPrice]){
        [self setPrice:([self price] + [self houseAreaPrice])];
        //[self setItemDescrip:[NSString stringWithFormat:@"This is the startwef awef awe fawe faw efawe fawe fawf wef awef awe fawe faw efawe fawe fawf wef awef awe fawe faw efawe fawe fawf wef awef awe fawe faw efawe fawe fawf  wef awef awe fawe faw efawe fawe fawf awf wae fwf23fa32f a23f a23f a23f 23a f3a2  32fHouse Area: %f and this is the end of THE Long long long paragraph which is supposed to determine the length of my label's frame. get it ? now blah blah and lets go hey dude cmon go ha ha ter rradactil pterdor", [self houseArea]]];
        [self setItemDescrip:[NSString stringWithFormat:@"House Area: %.02f square feet", [self houseArea]]];
        
        NSLog(@"ITEM NAME IS %@, %f", [self itemDescrip], [self houseArea]);
    }
    
    // adding the price of any extra furnaces ( if any )
    if ([self numberOfFurnaces] > 0){   // first furnace included in the package for free; any additional furnace is +$49.95.
        float furnacesExtraCost = ( [self numberOfFurnaces] - 1 ) * 49.95;
        [self setPrice:([self price] + furnacesExtraCost)];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nNumber of Furnaces: %u", [self itemDescrip], [self numberOfFurnaces]]];
    }
    
    // adding the price of the 'brush clean addon' ( if selected )
    if ([self brushCleanAddon]){
        [self setPrice:([self price] + 99.95)];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nBrush Clean Addon (+$99.95)", [self itemDescrip]]];
    }
    
    // addonList: [0] = main lines quantity; [1] = addtn. main lines quantity; [2] = hot vents quantity; [3] = cold vents quantity; [4] = addtn vents quantity;
    // [5] = dryer vent quantity; [6] = hot water tank quantity; [7] = central vac quantity; [8] = central vac & dryer vent quantity;
    // [9] = heat recover ventilation box quantity; [10] = humidifier quantity; [11] = sanitizer quantity; [12] = air conditioner quantity; [13] = fire place quantity;
    // [14] = chimney quantity; [15] = crawl space quantity; [16] = miscellaneous quantity; [17] = hot water tank price; [18] = sanitizer price; [19] = fire place price;
    // [20] = chimney price; [21] = crawl space price; [22] = miscellaneous price; [23] = full item description
    
    // selectedAddonsList: [0] = dryer vent; [1] = hot water tank; [2] = central vac; [3] = central vac & dryer vent; [4] = heat recover ventilation box; [5] = humidifier;
    // [6] = sanitizer; [7] = air conditioner; [8] = fire place; [9] = chimney; [10] = crawl space; [11] = miscellaneous
    // adding the prices of addons ( the ones that have 'true' booleans in the 'selectedAddonsList' array
    addonsOverallPrice = 0; // set it to 0 initially, then check and add up each addon price ( if selected )
    if ([[selectedAddonsList objectAtIndex:0] boolValue]){
        addonsOverallPrice += 19.95;    // dryer vent addon price
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Dryer Vent Addon(s) (+$19.95)", [self itemDescrip], [[addonList objectAtIndex:5] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:1] boolValue]){  // hot water tank addon price
        addonsOverallPrice += [[addonList objectAtIndex:6] integerValue] * [[addonList objectAtIndex:17] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Hot Water Tank Addon(s) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:6] integerValue], [[addonList objectAtIndex:17] floatValue] ]];
        //NSLog(@" ! ! ! ! ! it is %f", ( [[addonList objectAtIndex:6] integerValue] * [[addonList objectAtIndex:17] floatValue] ) );
    }
    
    if ([[selectedAddonsList objectAtIndex:2] boolValue]){  // central vac addon price
        addonsOverallPrice += 49.95  * [[addonList objectAtIndex:7] integerValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Central Vac Addon(s) (+$49.95)", [self itemDescrip], [[addonList objectAtIndex:7] integerValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:3] boolValue]){  // central vac & dryer vent addon price
        addonsOverallPrice += 39.95 * [[addonList objectAtIndex:8] integerValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Central Vac & Dryer Vent Addon(s) (+$39.95)", [self itemDescrip], [[addonList objectAtIndex:8] integerValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:4] boolValue]){  // heat recover ventilation box addon price
        addonsOverallPrice += 49.95 * [[addonList objectAtIndex:9] integerValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Heat Recover Ventilation Box Addon(s) (+$49.95)", [self itemDescrip], [[addonList objectAtIndex:9] integerValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:5] boolValue]){  // humidifier addon price
        addonsOverallPrice += 39.95 * [[addonList objectAtIndex:10] integerValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Humidifier Addon(s) (+$39.95)", [self itemDescrip], [[addonList objectAtIndex:10] integerValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:6] boolValue]){  // sanitizer addon price
        addonsOverallPrice += [[addonList objectAtIndex:11] integerValue] * [[addonList objectAtIndex:18] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Sanitizer Addon(s) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:11] integerValue], [[addonList objectAtIndex:18] floatValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:7] boolValue]){  // air conditioner addon price
        addonsOverallPrice += 49.95 * [[addonList objectAtIndex:12] integerValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Air Conditioner Addon(s) (+$49.95)", [self itemDescrip], [[addonList objectAtIndex:12] integerValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:8] boolValue]){  // fire place addon price
        addonsOverallPrice += [[addonList objectAtIndex:13] integerValue] * [[addonList objectAtIndex:19] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Fire Place Addon(s) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:13] integerValue], [[addonList objectAtIndex:19] floatValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:9] boolValue]){  // chimney addon price
        addonsOverallPrice += [[addonList objectAtIndex:14] integerValue] * [[addonList objectAtIndex:20] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Chimney Addon(s) (%@) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:14] integerValue], [self chimneyAccess], [[addonList objectAtIndex:20] floatValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:10] boolValue]){ // crawl space addon price
        addonsOverallPrice += [[addonList objectAtIndex:15] integerValue] * [[addonList objectAtIndex:21] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Crawl Space Addon(s) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:15] integerValue], [[addonList objectAtIndex:21] floatValue]]];
    }
    if ([[selectedAddonsList objectAtIndex:11] boolValue]){ // miscellaneous addon price
        addonsOverallPrice += [[addonList objectAtIndex:16] integerValue] * [[addonList objectAtIndex:22] floatValue];
        [self setItemDescrip:[NSString stringWithFormat:@"%@\n%u Miscellaneous Addon(s) (+$%.02f)", [self itemDescrip], [[addonList objectAtIndex:16] integerValue], [[addonList objectAtIndex:22] floatValue]]];
        NSLog(@" ! ! ! ! ! it is %f", ( [[addonList objectAtIndex:16] integerValue] * [[addonList objectAtIndex:22] floatValue] ) );
    }
    
    // addonList: [0] = main lines quantity; [1] = addtn. main lines quantity; [2] = hot vents quantity; [3] = cold vents quantity; [4] = addtn vents quantity;
    // [5] = dryer vent quantity; [6] = hot water tank quantity; [7] = central vac quantity; [8] = central vac & dryer vent quantity;
    // [9] = heat recover ventilation box quantity; [10] = humidifier quantity; [11] = sanitizer quantity; [12] = air conditioner quantity; [13] = fire place quantity;
    // [14] = chimney quantity; [15] = crawl space quantity; [16] = miscellaneous quantity; [17] = hot water tank price; [18] = sanitizer price; [19] = fire place price;
    // [20] = chimney price; [21] = crawl space price; [22] = miscellaneous price; [23] = full item description
    
    [self setItemDescrip:[NSString stringWithFormat:@"%@\n\nFurnace Make: %@, Filter: %@, Serial No: %@, Model: %@, Last Serviced: %@, Fan Belt: %@ \n", [self itemDescrip], [furnaceInformation objectAtIndex:0], [furnaceInformation objectAtIndex:1], [furnaceInformation objectAtIndex:2], [furnaceInformation objectAtIndex:3], [furnaceInformation objectAtIndex:4], [furnaceInformation objectAtIndex:5]]];
    
    // furnaceInformation: [0] = furnace Make; [1] = Filter No; [2] = Serial No; [3] = Model; [4] = Last Serviced; [5] = Fan Belt
    if ([[addonList objectAtIndex:0] integerValue] > 0){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nMain Lines: %u", [self itemDescrip], [[addonList objectAtIndex:0] integerValue]]];
    }
    
    if ([[addonList objectAtIndex:1] integerValue] > 0){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nAddtn. Main Lines: %u", [self itemDescrip], [[addonList objectAtIndex:1] integerValue]]];
    }
    
    if ( ([[addonList objectAtIndex:2] integerValue] > 0 ) || ([[addonList objectAtIndex:3] integerValue] > 0 ) ){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nHot Vents: %u, Cold Vents: %u", [self itemDescrip], [[addonList objectAtIndex:2] integerValue], [[addonList objectAtIndex:3] integerValue]]];
    }
    
    if ([[addonList objectAtIndex:4] integerValue] > 0){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nAddtn. Vents: %u", [self itemDescrip], [[addonList objectAtIndex:4] integerValue]]];
    }
    
    // selectedAddonsList: [0] = dryer vent; [1] = hot water tank; [2] = central vac; [3] = central vac & dryer vent; [4] = heat recover ventilation box; [5] = humidifier;
    // [6] = sanitizer; [7] = air conditioner; [8] = fire place; [9] = chimney; [10] = crawl space; [11] = miscellaneous
    
    /*if ([[selectedAddonsList objectAtIndex:0] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nDryer Vents: %u", [self itemDescrip], [[addonList objectAtIndex:5] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:1] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nHot Water Tanks: %u", [self itemDescrip], [[addonList objectAtIndex:6] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:2] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nCentral Vac: %u", [self itemDescrip], [[addonList objectAtIndex:7] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:3] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nCentral Vac & Dryer Vents: %u", [self itemDescrip], [[addonList objectAtIndex:8] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:4] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nHeat Recover Ventilation Box(es): %u", [self itemDescrip], [[addonList objectAtIndex:9] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:5] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nHumidifiers: %u", [self itemDescrip], [[addonList objectAtIndex:10] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:6] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nSanitizers: %u", [self itemDescrip], [[addonList objectAtIndex:11] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:7] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nAir Conditioners: %u", [self itemDescrip], [[addonList objectAtIndex:12] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:8] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nFire Places: %u", [self itemDescrip], [[addonList objectAtIndex:13] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:9] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nChimneys: %u", [self itemDescrip], [[addonList objectAtIndex:14] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:10] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nCrawl Spaces: %u", [self itemDescrip], [[addonList objectAtIndex:15] integerValue]]];
    }
    
    if ([[selectedAddonsList objectAtIndex:11] boolValue]){
        [self setItemDescrip:[NSString stringWithFormat:@"%@\nMiscellaneous Quantity: %u", [self itemDescrip], [[addonList objectAtIndex:16] integerValue]]];
    }*/
    
    [addonList replaceObjectAtIndex:23 withObject:itemDescrip];
    
    // add the overall addons price to the price
    [self setPrice:([self price] + addonsOverallPrice)];
    
    // set price to the priceLabel's text
    [priceLabel setText:[NSString stringWithFormat:@"$%.02f", [self price]]];
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

// selectedAddonsList: [0] = dryer vent; [1] = hot water tank; [2] = central vac; [3] = central vac & dryer vent; [4] = heat recover ventilation box; [5] = humidifier;
// [6] = sanitizer; [7] = air conditioner; [8] = fire place; [9] = chimney; [10] = crawl space; [11] = miscellaneous
// all addon buttons have tag = 21 when not selected and tag = 22 when selected
-(IBAction) onSelectingAddon: (id) sender {
    if ([[sender restorationIdentifier] isEqualToString:@"dryerVentBtn"]){
        if ([sender tag] == 21){             // select this addon
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            //[selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:0];
            [selectedAddonsList replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:TRUE]];
        } else if ([sender tag] == 22){      // deselect this addon
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            //[selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:0];
            [selectedAddonsList replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:FALSE]];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"hotWaterTankBtn"]){
        if ([sender tag] == 21){    
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            //[selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:1];
            [selectedAddonsList replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:TRUE]];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            //[selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:1];
            [selectedAddonsList replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:FALSE]];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"centralVacBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:2];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:2];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"centralVacDryerVentBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:3];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:3];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"HeatRecoverVentilationBoxBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:4];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:4];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"humidifierBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:5];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:5];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"sanitizerBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:6];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:6];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"airConditionerBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:7];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:7];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"firePlaceBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:8];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:8];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"chimneyBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:9];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:9];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"crawlSpaceBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:10];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:10];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"miscellaneousBtn"]){
        if ([sender tag] == 21){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:22];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:TRUE] atIndex:11];
        } else if ([sender tag] == 22){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:21];
            [selectedAddonsList insertObject:[NSNumber numberWithBool:FALSE] atIndex:11];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"chimneyInteriorAccessBtn"]){
        // for 'interior chimney access' or 'exterior ..', the selected one has tag = 24 and the other has tag = 23
        
        if ([sender tag] == 24){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:23];
            [extChimneyBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [extChimneyBtn setTag:23];
            [self setChimneyAccess:@"none"];
        } else if ([sender tag] == 23){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:24];
            [extChimneyBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [extChimneyBtn setTag:23];
            [self setChimneyAccess:@"interior"];
        }
    } else if ([[sender restorationIdentifier] isEqualToString:@"chimneyExteriorAccessBtn"]){
        // for 'interior chimney access' or 'exterior ..', the selected one has tag = 24 and the other has tag = 23
        
        if ([sender tag] == 24){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [sender setTag:23];
            [intChimneyBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [intChimneyBtn setTag:23];
            [self setChimneyAccess:@"none"];
        } else if ([sender tag] == 23){
            [sender setBackgroundImage:[UIImage imageNamed:@"bulletSel.png"] forState:UIControlStateNormal];
            [sender setTag:24];
            [intChimneyBtn setBackgroundImage:[UIImage imageNamed:@"bulletUnSel.png"] forState:UIControlStateNormal];
            [intChimneyBtn setTag:23];
            [self setChimneyAccess:@"exterior"];
        }
    }
    
    [self calculateOverallPrice];
}

-(IBAction) onEnteringInformation: (id) sender {
    
    // furnaceInformation: [0] = furnace Make; [1] = Filter No; [2] = Serial No; [3] = Model; [4] = Last Serviced; [5] = Fan Belt

    // addonList: [0] = main lines quantity; [1] = addtn. main lines quantity; [2] = hot vents quantity; [3] = cold vents quantity; [4] = addtn vents quantity;
    // [5] = dryer vent quantity; [6] = hot water tank quantity; [7] = central vac quantity; [8] = central vac & dryer vent quantity;
    // [9] = heat recover ventilation box quantity; [10] = humidifier quantity; [11] = sanitizer quantity; [12] = air conditioner quantity; [13] = fire place quantity;
    // [14] = chimney quantity; [15] = crawl space quantity; [16] = miscellaneous quantity; [17] = hot water tank price; [18] = sanitizer price; [19] = fire place price;
    // [20] = chimney price; [21] = crawl space price; [22] = miscellaneous price; [23] = full item description
    //
    
    UITextField *info = (UITextField *) sender;
    if ([[sender restorationIdentifier] isEqualToString:@"furnace1Make"]){
        [furnaceInformation replaceObjectAtIndex:0 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"furnace1Filter"]){
        [furnaceInformation replaceObjectAtIndex:1 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"furnace1SerialNo"]){
        [furnaceInformation replaceObjectAtIndex:2 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"furnace1Model"]){
        [furnaceInformation replaceObjectAtIndex:3 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"furnace1LastServiced"]){
        [furnaceInformation replaceObjectAtIndex:4 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"furnace1FanBelt"]){
        [furnaceInformation replaceObjectAtIndex:5 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"mainLinesQuantity"]){
        [addonList replaceObjectAtIndex:0 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"additionalLinesQuantity"]){
        [addonList replaceObjectAtIndex:1 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"hotVentsQuantity"]){
        [addonList replaceObjectAtIndex:2 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"coldVentsQuantity"]){
        [addonList replaceObjectAtIndex:3 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"additionalVentsQuantity"]){
        [addonList replaceObjectAtIndex:4 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"dryerVentQuantity"]){
        [addonList replaceObjectAtIndex:5 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"hotWaterTankQuantity"]){
        [addonList replaceObjectAtIndex:6 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"centralVacQuantity"]){
        [addonList replaceObjectAtIndex:7 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"centralVacDryerVentQuantity"]){
        [addonList replaceObjectAtIndex:8 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"HeatRecoverVentilationBoxQuantity"]){
        [addonList replaceObjectAtIndex:9 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"humidifierQuantity"]){
        [addonList replaceObjectAtIndex:10 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"sanitizerQuantity"]){
        [addonList replaceObjectAtIndex:11 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"airConditionerQuantity"]){
        [addonList replaceObjectAtIndex:12 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"firePlaceQuantity"]){
        [addonList replaceObjectAtIndex:13 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"chimneyQuantity"]){
        [addonList replaceObjectAtIndex:14 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"crawlSpaceQuantity"]){
        [addonList replaceObjectAtIndex:15 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"miscellaneousQuantity"]){
        [addonList replaceObjectAtIndex:16 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"hotWaterTankPrice"]){
        [addonList replaceObjectAtIndex:17 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"sanitizerPrice"]){
        [addonList replaceObjectAtIndex:18 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"firePlacePrice"]){
        [addonList replaceObjectAtIndex:19 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"chimneyPrice"]){
        [addonList replaceObjectAtIndex:20 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"crawlSpacePrice"]){
        [addonList replaceObjectAtIndex:21 withObject:[info text]];
    } else if ([[sender restorationIdentifier] isEqualToString:@"miscellaneousPrice"]){
        [addonList replaceObjectAtIndex:22 withObject:[info text]];
    }
    
    [self calculateOverallPrice];
    
}

-(IBAction) quantityChanged: (id) sender {
    UITextField* qField = (UITextField*) sender;
    // NSLog(@"the quantity is %ld", (long)[[qField text] integerValue]);
    [self setQuantity:[[qField text] integerValue]];
    [self doCalculations];
}

-(void) doCalculations {
    // if quantity is > 0
    /*if ([self quantity] && [self serviceType]){
        //NSLog(@"GOT HERE? price rate is %f", [self priceRate]);
        [self setPrice: ([self priceRate] * [self quantity]) ];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price] ]];
    } else {
        
        [self setPrice:0.0f];
        [[self priceLabel] setText:[NSString stringWithFormat:@"$%.02f", [self price]]];
    }*/
    
    
    
    //[self setPrice:0.0];
    
    
    
}

-(IBAction) saveOrCancel: (id) sender {
    [self doCalculations];
    notesAboutRoom = notesField.text;
    
    if ([[sender restorationIdentifier] isEqualToString:@"save"]){
        
        // To save:
        // furnaceInformation: [0] = furnace Make; [1] = Filter No; [2] = Serial No; [3] = Model; [4] = Last Serviced; [5] = Fan Belt
        
        // addonList: [0] = main lines quantity; [1] = addtn. main lines quantity; [2] = hot vents quantity; [3] = cold vents quantity; [4] = addtn vents quantity;
        // [5] = dryer vent quantity; [6] = hot water tank quantity; [7] = central vac quantity; [8] = central vac & dryer vent quantity;
        // [9] = heat recover ventilation box quantity; [10] = humidifier quantity; [11] = sanitizer quantity; [12] = air conditioner quantity; [13] = fire place quantity;
        // [14] = chimney quantity; [15] = crawl space quantity; [16] = miscellaneous quantity; [17] = hot water tank price; [18] = sanitizer price; [19] = fire place price;
        // [20] = chimney price; [21] = crawl space price; [22] = miscellaneous price; [23] = full item description
        
        // selectedAddonsList: [0] = dryer vent; [1] = hot water tank; [2] = central vac; [3] = central vac & dryer vent; [4] = heat recover ventilation box; [5] = humidifier;
        // [6] = sanitizer; [7] = air conditioner; [8] = fire place; [9] = chimney; [10] = crawl space; [11] = miscellaneous
       
        // [self houseArea], [self houseAreaPrice];
        // [self numberOfFurnaces]
        // [self furnaceInformation] objectAtIndex:<#(NSUInteger)#>];
        // [self brushCleanAddon]
        // [self addonList] objectAtIndex:<#(NSUInteger)#>]
        // [self chimneyAccess];
        // [self itemName];
        
        ServiceDataCell *newCell = [[ServiceDataCell alloc] init];
        newCell.serviceType = @"ductFurnaceCleaning";
        NSLog(@"item name is %@", [addonList objectAtIndex:23]);
        // newCell.name = [self itemDescrip];      // name, description, all info of this service to be written on the invoice
        newCell.rlength = [self houseArea];  // house area
        newCell.priceRate = [self houseAreaPrice]; // house area price
        newCell.quantity = [self numberOfFurnaces]; // number of furnaces
        newCell.vacOrFull = [self chimneyAccess];   // chimney access
        newCell.addonDeodorizer = [self brushCleanAddon]; // brush clean addon
        newCell.price = [self price];
        newCell.notes = [self notesAboutRoom];
        
        [newCell setAttributesList:furnaceInformation];
        [newCell setAttributesListTwo:addonList];
        [newCell setAttributesListThree:selectedAddonsList];
        
        /*------------------------------------------- OptionsDuctFurnaceCleanPVC:
        ductFurnaceCleaning - Duct & Furnace Cleaning:
        service type = ductFurnaceCleaning
        rlength = house area
        priceRate = house area price
        quantity = number of furnaces
        vacOrFull = chimney access ('exterior' or 'interior')
        addonDeodorizer = brush clean addon bool
        materialType = service type restoration id (serviceTypeRestorationID)
        
        vacOrFull = 'Windshield Crack'
        quantity = # of cars
        price = price
        priceRate = price per one car
        notes = ..
         
        */
        
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"add" withServiceCell:newCell];
    } else if ([[sender restorationIdentifier] isEqualToString:@"edit"]){
        
        [[self editingCell] setServiceType:@"ductFurnaceCleaning"];
        //[[self editingCell] setName:[self itemDescrip]];
        [[self editingCell] setRlength:[self houseArea]];
        [[self editingCell] setPriceRate:[self houseAreaPrice]];
        [[self editingCell] setQuantity:[self numberOfFurnaces]];
        [[self editingCell] setVacOrFull:[self chimneyAccess]];
        [[self editingCell] setAddonDeodorizer:[self brushCleanAddon]];
        [[self editingCell] setPriceRate:[self price]];
        [[self editingCell] setNotes:[self notesAboutRoom]];
        
        
        [[self editingCell] setAttributesList:furnaceInformation];
        [[self editingCell] setAttributesListTwo:addonList];
        [[self editingCell] setAttributesListThree:selectedAddonsList];
        
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"edit" withServiceCell:nil];
        
    } else if ([[sender restorationIdentifier] isEqualToString:@"cancel"]){
        [ADelegate updateDuctFurnaceCleanDataTable:self editType:@"cancel" withServiceCell:nil];
    }
}

@end
