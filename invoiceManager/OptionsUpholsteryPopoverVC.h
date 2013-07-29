//
//  OptionsPopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePopoverVC.h"

@class OptionsUpholsteryPopoverVC;

@protocol OptionsUpholsteryPopoverVCDelegate <NSObject>

//- (void)updateUpholsteryDataTable:(OptionsUpholsteryPopoverVC *)optionsVS editType:(NSString*) editType withItemName: (NSString*) item_name_arg withMaterialType: (NSString*) item_material_arg withCleanType: (NSString*) vac_or_full_arg andQuantity: (NSInteger) quantity_arg andPrice: (float) item_price_arg andNotes: (NSString*) notes_arg;
- (void)updateUpholsteryDataTable:(OptionsUpholsteryPopoverVC *)optionsVS editType:(NSString*) editType withServiceCell: (ServiceDataCell*) cell_arg;
@end

@interface OptionsUpholsteryPopoverVC : BasePopoverVC <UITextViewDelegate> {
    
    // delegate variables
    id <OptionsUpholsteryPopoverVCDelegate> UVCDelegate;  // options view controller delegate
    
    // variables
    NSString *itemName;
    NSString *notes;
    float price;
    NSString *vacOrFull;
    NSString *materialType;
    NSInteger quantity;
    
    bool addonDeodorizer, addonFabricSoftener, addonBiocide;
    
    // outlets
    IBOutlet UITextField *quantityField;
    IBOutlet UILabel *priceLabel;
    IBOutlet UITextView *notesField;
    IBOutlet UIButton *powerVacBtn;
}

@property (nonatomic, assign) id <OptionsUpholsteryPopoverVCDelegate> UVCDelegate;

@property (assign, readwrite) float price;
@property (assign, readwrite) NSInteger quantity;
@property (assign, readwrite) NSString *itemName, *notes, *vacOrFull, *materialType;
@property (assign, readwrite) bool addonDeodorizer, addonFabricSoftener, addonBiocide;

@property (nonatomic, assign) IBOutlet UITextView *notesField;
@property (nonatomic, assign) IBOutlet UILabel *priceLabel;
@property (nonatomic, assign) IBOutlet UIButton *powerVacBtn;

-(BOOL)textViewShouldBeginEditing: (UITextView*)textView;
-(IBAction) saveOrCancel: (id) sender;
-(IBAction) onClickingBtn: (id) sender;
-(IBAction) onCustomEditingDone: (id) sender;
-(IBAction) saveAddon:(id)sender;
@end
