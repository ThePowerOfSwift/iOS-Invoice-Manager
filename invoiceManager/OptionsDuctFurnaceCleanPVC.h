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
    
    // outlets
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextField *quantityField, *numberOfFurnacesField;
    
    IBOutlet UIScrollView *scrollViewer, *furnacesScroller;
}

@property (nonatomic, assign) id <OptionsDuctFurnaceCleanPVCDelegate> ADelegate;

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) float price, priceRate;
@property (assign, readwrite) NSString *serviceType, *serviceTypeRestorationID, *notesAboutRoom;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer, *furnacesScroller;
@property (nonatomic, assign) IBOutlet UITextField *quantityField, *numberOfFurnacesField;
@property (nonatomic, assign) IBOutlet UILabel *priceLabel;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onChoosingServiceType: (id) sender;
-(IBAction) quantityChanged: (id) sender;

@end
