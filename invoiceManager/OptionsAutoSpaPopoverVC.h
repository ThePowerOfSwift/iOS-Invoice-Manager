
//  OptionsAutoSpaPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsAutoSpaPopoverVC;

@protocol OptionsAutoSpaPopoverVCDelegate <NSObject>
- (void)updateAutoSpaDataTable:(OptionsAutoSpaPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsAutoSpaPopoverVC : BasePopoverVC <UITextViewDelegate> {
    
    // delegate variables
    id <OptionsAutoSpaPopoverVCDelegate> ASVCDelegate;  // options view controller delegate
    
    // variables
    NSString *packageType;
    NSString *carType;
    NSString *notesAboutRoom;
    float price;
    
    // outlets
    IBOutlet UILabel *packageTypeLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextView *notesField;
    
    IBOutlet UIScrollView *scrollViewer;
}

@property (nonatomic, assign) id <OptionsAutoSpaPopoverVCDelegate> ASVCDelegate;

@property (assign, readwrite) float price;
@property (assign, readwrite) NSString *packageType, *carType, *notesAboutRoom;

@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *lengthField, *widthField, *stairsField, *landingsField;
@property (nonatomic, assign) IBOutlet UILabel *packageTypeLabel, *priceLabel;

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(IBAction) saveAddon:(id) sender;
-(IBAction) onChoosingPackageType:(id) sender;
@end
