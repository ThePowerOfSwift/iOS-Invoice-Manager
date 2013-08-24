//  OptionsSemiDetailPVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsAluminumMetalPVC;

@protocol OptionsAluminumMetalPVCDelegate <NSObject>
- (void)updateSpaAluminumMetalDataTable:(OptionsAluminumMetalPVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsAluminumMetalPVC : BasePopoverVC {
    
    // delegate variables
    id <OptionsAluminumMetalPVCDelegate> ADelegate;  // options view controller delegate
    
    // variables
    NSString *serviceType, *serviceTypeRestorationID;
    NSString *carType;      // 'Car' or 'SUV'
    NSString *notesAboutRoom;
    float price, priceRate;
    NSInteger quantity;
    
    // outlets
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextField *quantityField;
    
    IBOutlet UIScrollView *scrollViewer;
}

@property (nonatomic, assign) id <OptionsAluminumMetalPVCDelegate> ADelegate;

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) float price, priceRate;
@property (assign, readwrite) NSString *serviceType, *carType, *notesAboutRoom, *serviceTypeRestorationID;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (nonatomic, assign) IBOutlet UITextField *quantityField;
@property (nonatomic, assign) IBOutlet UILabel *priceLabel;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onChoosingServiceType: (id) sender;
-(IBAction) quantityChanged: (id) sender;
-(IBAction) clearAllSelections;

@end
