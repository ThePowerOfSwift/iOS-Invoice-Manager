//
//  InvoiceVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-28.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageUI/MessageUI.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "CoreText/CoreText.h"
#import "customLabel.h"
#import "SignaturePopoverVC.h"
#import "InvoiceDiscountVC.h"

@interface InvoiceVC : UIViewController <MFMailComposeViewControllerDelegate, SignaturePopoverVCDelegate, InvoiceDiscountVCDelegate> {
    id <MFMailComposeViewControllerDelegate> mailDel;
    IBOutlet UIScrollView *mainView;
    IBOutlet UILabel *test;
    
    CGSize pageSize;
    UIPopoverController *popoverController;
    IBOutlet UIView *signatureView;
    /*// vars for signature capture:
     CGPoint lastPoint;
     UIImageView *drawImage;
     BOOL mouseSwiped;
     int mouseMoved;*/
    
    bool writePDF;
    NSMutableArray *invoiceSubviews;
    
    IBOutlet UIScrollView *scrollViewer;
    IBOutlet UIImageView *signatureImageView;
    IBOutlet UIButton *backbtn;
    IBOutlet UIButton *signaturebtn;
    // second draw:
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    
    float carpetDiscount, upholsteryDiscount, mattressDiscount, miscellaneousDiscount, areaRugsDiscount, floodDiscount, ductFurnaceDiscount;
    float discountedCarpetPrice, discountedUpholsteryPrice, discountedMattressPrice, discountedMiscePrice, discountedAreaRugsPrice, discountedFloodPrice, discountedDuctFurnace;
    float subtotalCarpetPrice, subtotalUpholsteryPrice, subtotalMattressPrice, subtotalMiscePrice, subtotalAreaRugsPrice, subtotalFloodPrice, subtotalDuctFurnace;
    
    float autospaDiscount;
    float discountedAutospaPrice;
    float subtotalAutospaPrice;
    
    NSMutableData* pdfData;
}


//@property (assign, nonatomic) IBOutlet UIImageView *mainImage;
//@property (nonatomic, assign) IBOutlet UIImageView *tempDrawImage;

@property (assign, readwrite) NSMutableData* pdfData;

@property (assign, nonatomic) float autospaDiscount, discountedAutospaPrice, subtotalAutospaPrice;
@property (assign, nonatomic) float carpetDiscount, upholsteryDiscount, mattressDiscount, miscellaneousDiscount, areaRugsDiscount, floodDiscount, ductFurnaceDiscount;
@property (assign, nonatomic) float discountedCarpetPrice, discountedUpholsteryPrice, discountedMattressPrice, discountedMiscePrice, discountedAreaRugsPrice, discountedFloodPrice, discountedDuctFurnace;
@property (assign, nonatomic) float subtotalCarpetPrice, subtotalUpholsteryPrice, subtotalMattressPrice, subtotalMiscePrice, subtotalAreaRugsPrice, subtotalFloodPrice, subtotalDuctFurnace;

@property (assign, nonatomic) bool writePDF;
@property (assign, nonatomic) NSMutableArray *invoiceSubviews;
@property (assign, nonatomic) IBOutlet UIButton *signaturebtn;
@property (assign, nonatomic) IBOutlet UIButton *backbtn;
@property (assign, nonatomic) IBOutlet UIScrollView *scrollViewer;
@property (assign, nonatomic) IBOutlet UIImageView *signatureImageView;
@property (nonatomic, assign) UIPopoverController *popoverController;
@property (nonatomic, assign) IBOutlet UIImageView *drawImage;
@property (nonatomic, assign) IBOutlet UIScrollView *mainView;
@property (nonatomic, assign) IBOutlet UILabel *test;
@property (nonatomic, assign) IBOutlet UIView *signatureView;


-(IBAction) displaySigPopover: (id) sender;
-(IBAction) makeMeAPDF;
-(IBAction) sendMail;
-(IBAction) gotoLastView;
-(IBAction) createInvoice;
-(IBAction) displayDiscountPopover: (id) sender;
-(IBAction) saveInvoiceToDatabase;

@end
