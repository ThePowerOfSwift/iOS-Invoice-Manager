
//  OptionsAutoSpaPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsAutoSpaPVC;

@protocol OptionsAutoSpaPVCdelegate <NSObject>
- (void)updateAutoSpaDataTable:(OptionsAutoSpaPVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsAutoSpaPVC : BasePopoverVC {
    
    // delegate variables
    id <OptionsAutoSpaPVCdelegate> ASVCDelegate;  // options view controller delegate
    
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
    IBOutlet UITextField *quantityField;
    //IBOutlet UITextView *notesField;
    
    IBOutlet UIScrollView *scrollViewer;
}

@property (nonatomic, assign) id <OptionsAutoSpaPVCdelegate> ASVCDelegate;

@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) float price, priceRate;
@property (assign, readwrite) NSString *packageType, *carType, *notesAboutRoom;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer;
//@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *lengthField, *widthField, *stairsField, *landingsField, *quantityField;
@property (nonatomic, assign) IBOutlet UILabel *packageTypeLabel, *priceLabel;
@property (nonatomic, assign) IBOutlet UIImageView *selectedCarBg;

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(IBAction) saveAddon:(id) sender;
-(IBAction) onChoosingPackageType:(id) sender;
-(IBAction) onChoosingCarType: (id) sender;
-(IBAction) quantityChanged: (id) sender;

@end
