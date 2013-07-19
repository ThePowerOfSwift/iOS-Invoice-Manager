//
//  ServiceItem.h
//  invoiceManager
//
//  Created by Mihai on 2013-05-20.
//  Copyright (c) 2013 Mihai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceItem : NSObject {
    NSString *name;
    NSMutableArray *cellList;
    UIViewController *serviceVC;
    NSInteger order;
}

@property (assign, readwrite) NSInteger order;
@property (assign, readwrite) UIViewController *serviceVC;
@property (assign, readwrite) NSString *name;
@property (assign, readwrite) NSMutableArray *cellList;

@end
