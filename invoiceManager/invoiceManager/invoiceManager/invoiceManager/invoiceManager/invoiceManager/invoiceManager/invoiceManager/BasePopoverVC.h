//
//  BasePopoverVC.h
//  invoiceManager
//
//  Created by Mihai on 2013-07-27.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePopoverVC : UIViewController {
    bool editMode;
}

@property (assign, readwrite) bool editMode;

@end
