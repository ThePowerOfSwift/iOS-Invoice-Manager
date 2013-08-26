
//  OptionsAutoSpaPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsSemiSpaPVC;

@protocol OptionsSemiSpaPVCdelegate <NSObject>
- (void)updateSemiSpaDataTable:(OptionsSemiSpaPVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsSemiSpaPVC : BasePopoverVC {
    
    // delegate variables
    id <OptionsSemiSpaPVCdelegate> SSVCDelegate;  // options view controller delegate
    
    // variables
    NSString *packageType;
    NSString *carType;
    NSString *notesAboutRoom;
    float price, priceRate;
    NSInteger quantity;
    
    // outlets
    IBOutlet UIImageView *selectedCarBg;
    IBOutlet UILabel *packageTypeLabel;
    IBOutlet UILabel *priceLabel;
    //IBOutlet UITextView *notesField;
    IBOutlet UITextField *quantityField;
    
    IBOutlet UIScrollView *scrollViewer;
}

@property (nonatomic, assign) id <OptionsSemiSpaPVCdelegate> SSVCDelegate;

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) float price, priceRate;
@property (assign, readwrite) NSString *packageType, *carType, *notesAboutRoom;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer;
//@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *lengthField, *widthField, *stairsField, *landingsField, *quantityField;
@property (nonatomic, assign) IBOutlet UILabel *packageTypeLabel, *priceLabel;
@property (nonatomic, assign) IBOutlet UIImageView *selectedCarBg;

-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onChoosingPackageType:(id) sender;
-(IBAction) onChoosingCarType: (id) sender;
-(IBAction) quantityChanged: (id) sender;

@end
