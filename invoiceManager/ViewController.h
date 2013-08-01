//
//  ViewController.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-14.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceTypeViewController.h"
#import "ServiceTypeTwoVC.h"
#import "CCSecondVC.h"
#import "InvoiceVC.h"
#import "CustomTableViewCell.h"

@interface ViewController : UIViewController <SecondViewControllerDelegate> {
    IBOutlet UITextField *nameTextField;
    IBOutlet UIScrollView *scrollViewer;
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UIButton *testBtn;
    
    IBOutlet UIImageView *selectedBtnBg;
    IBOutlet UIImageView *selectedBtnBgTwo;
    
    IBOutlet UITextField *invoiceField, *poField, *currentDateField, *techNameField, *customerFirstNameField, *customerLastNameField, *customerAddressOneField, *customerAddressTwoField, *customerPhoneField, *customerEmailField, *customerReferredField;
    NSArray *pickerViewArray;
    NSMutableArray *list1;
    
    IBOutlet UIView* carpetCareOptionsView;
}
@property (assign, nonatomic) IBOutlet UIView* carpetCareOptionsView;
@property (assign, nonatomic) IBOutlet UITextField *invoiceField;
//@property (retain) UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (assign, readwrite) IBOutlet UIImageView *selectedBtnBg, *selectedBtnBgTwo;

-(IBAction) textFieldDidEndEditing:(UITextField *)textField;
-(IBAction) onTouchDownIcon;
-(IBAction) onChoosingGreenProducts: (id) sender;
-(IBAction) gotoNextView;
-(IBAction) gotoLastView;

@end
