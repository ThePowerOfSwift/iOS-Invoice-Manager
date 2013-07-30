//
//  ServiceTypeTwoVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-30.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceTypeTwoVC : UIViewController {
    // variables
    NSString *VCServiceNameType;
}

@property (assign, readwrite) NSString *VCServiceNameType;

-(IBAction) gotoNextView;
-(IBAction) gotoLastView;

@end
