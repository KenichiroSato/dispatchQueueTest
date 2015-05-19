//
//  ViewController.h
//  globalQueueTest
//
//  Created by 佐藤健一朗 on 2015/05/20.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController< NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (nonatomic) NSString *srcURL;
@property (nonatomic) NSURLConnection *conn;
@property (nonatomic) long total;
@property (nonatomic) NSMutableData *downloadData;

@end


