//
//  signaturePopoverViewController.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignaturePopoverVC;

@protocol SignaturePopoverVCDelegate <NSObject>
/*- (void)updateDataTable:(OptionsPopoverVC *)optionsVS editType:(NSString*) editType withLength: (float) length_arg withWidth: (float) width_arg
 andRoom: (NSString*) roomName withPriceRate: (float) priceRate_arg andNotes: (NSString*) notesAboutRoom;*/
- (void)updateSignature:(SignaturePopoverVC *)optionsVS callType: (NSString *) call_type image: (UIImage*) image_arg;
@end

@interface SignaturePopoverVC : UIViewController {
    // delegate variables
    id <SignaturePopoverVCDelegate> signatureDelegate;  // options view controller delegate
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIImageView *tempDrawImage;
}

@property (assign, nonatomic) IBOutlet UIImageView *mainImage;
@property (assign, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (nonatomic, assign) id <SignaturePopoverVCDelegate> signatureDelegate;

-(IBAction) saveOrCancel:(id) sender;

@end
