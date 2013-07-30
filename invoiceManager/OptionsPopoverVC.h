//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDataCell.h"
#import "BasePopoverVC.h"

@class OptionsPopoverVC;

@protocol OptionsPopoverVCDelegate <NSObject>
/*- (void)updateDataTable:(OptionsPopoverVC *)optionsVS editType:(NSString*) editType withLength: (float) length_arg withWidth: (float) width_arg
 andRoom: (NSString*) roomName withPriceRate: (float) priceRate_arg andNotes: (NSString*) notesAboutRoom;*/
- (void)updateDataTable:(OptionsPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsPopoverVC : BasePopoverVC <UITextViewDelegate> {
    
    // delegate variables
    id <OptionsPopoverVCDelegate> OVCDelegate;  // options view controller delegate
    
    // variables
    float rLength;
    float rWidth;
    NSString *roomName;
    NSString *notesAboutRoom;
    float price;
    float squareFeet;
    float priceRate;
    
    NSInteger stairs, landings;
    bool stairsService;             // if this is TRUE, then deodorizer and others are ignored;
    
    bool addonDeodorizer, addonFabricProtector, addonBiocide;
    
    // outlets
    IBOutlet UILabel *sqfeetLabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextField *lengthField;
    IBOutlet UITextField *widthField;
    IBOutlet UITextView *notesField;
    
    IBOutlet UITextField *stairsField, *landingsField;
    
    //IBOutlet UIButton *saveOrEditBtn;
}

@property (nonatomic, assign) id <OptionsPopoverVCDelegate> OVCDelegate;

@property (assign, readwrite) bool addonDeodorizer, addonFabricProtector, addonBiocide, stairsService;
@property (assign, readwrite) float rLength, rWidth, price, squareFeet, priceRate;
@property (assign, readwrite) NSString *roomName, *notesAboutRoom;
@property (assign, readwrite) NSInteger stairs, landings;

@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UITextField *lengthField, *widthField, *stairsField, *landingsField;
//@property (nonatomic, assign) IBOutlet UIButton *saveOrEditBtn;

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(IBAction) saveAddon:(id)sender;
@end
