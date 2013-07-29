//
//  customUIButton.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-21.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUIButton : UIButton {
    NSInteger activeBtn;
    NSInteger cellIndex;
}

@property (assign, readwrite) NSInteger activeBtn;
@property (assign, readwrite) NSInteger cellIndex;

@end
