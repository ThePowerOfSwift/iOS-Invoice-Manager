//  OptionsDuctFurnaceCleanPVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsDuctFurnaceCleanPVC;

@protocol OptionsDuctFurnaceCleanPVCDelegate <NSObject>
- (void)updateDuctFurnaceCleanDataTable:(OptionsDuctFurnaceCleanPVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsDuctFurnaceCleanPVC : BasePopoverVC {
    
    // delegate variables
    id <OptionsDuctFurnaceCleanPVCDelegate> ADelegate;  // options view controller delegate
    
    // variables
    NSString *serviceType;  // '1st Rock Chip', '2nd Rock Chip', 'Additional Rock Chip', etc..
    NSString *serviceTypeRestorationID;
    NSString *notesAboutRoom;
    float price, priceRate;
    NSInteger quantity;
    float houseAreaPrice, houseArea;   // 'houseAreaPrice' holds the value of the house area
    NSInteger numberOfFurnaces;
    BOOL brushCleanAddon;
    NSMutableArray *furnaceInformation;
    // NSMutableArray *listOfFurnacesInformation; // implement this later for more furnaces. this will hold 'NSMutableArray *furnaceInformation' objects;
    NSMutableArray *addonList;
    NSMutableArray *selectedAddonsList;
    NSString *chimneyAccess;
    
    // outlets
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextField *quantityField, *numberOfFurnacesField, *houseAreaField, *houseAreaCustomPrice;
    
    IBOutlet UIButton *houseAreaOneBtn, *houseAreaTwoBtn, *houseAreaThreeBtn, *houseAreaFourBtn, *numberOfFurnacesCustomBtn, *intChimneyBtn, *extChimneyBtn;
    IBOutlet UIScrollView *scrollViewer, *furnacesScroller;
}

@property (nonatomic, assign) id <OptionsDuctFurnaceCleanPVCDelegate> ADelegate;

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) float price, priceRate, houseArea, houseAreaPrice;
@property (assign, readwrite) NSString *serviceType, *serviceTypeRestorationID, *notesAboutRoom, *chimneyAccess;
@property (assign, readwrite) NSInteger numberOfFurnaces;
@property (assign, readwrite) BOOL brushCleanAddon;
@property (assign, readwrite) NSMutableArray *furnaceInformation, *addonList, *selectedAddonsList;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer, *furnacesScroller;
@property (nonatomic, assign) IBOutlet UITextField *quantityField, *numberOfFurnacesField, *houseAreaField, *houseAreaCustomPrice;
@property (nonatomic, assign) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) IBOutlet UIButton *houseAreaOneBtn, *houseAreaTwoBtn, *houseAreaThreeBtn, *houseAreaFourBtn, *numberOfFurnacesCustomBtn, *intChimneyBtn;
@property (nonatomic, assign) IBOutlet UIButton *extChimneyBtn;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onChoosingServiceType: (id) sender;
-(IBAction) quantityChanged: (id) sender;
-(IBAction) addFurnace: (id) sender;
-(IBAction) onChangeHouseAreaField: (id) sender;
-(IBAction) onChoosingHouseAreaBtn: (id) sender;
-(IBAction) onChoosingNumberOfFurnaces: (id) sender;
-(IBAction) onChangeNumberOfFurnacesField: (id) sender;
-(IBAction) onChoosingAnyBtn:(id)sender;
-(IBAction) onEnteringInformation: (id) sender;
-(IBAction) onSelectingAddon: (id) sender;

@end
