//
//  ViewController.m
//  globalQueueTest
//
//  Created by 佐藤健一朗 on 2015/05/20.
//  Copyright (c) 2015年 Kenichiro Sato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.srcURL = @"https://gdata.youtube.com/feeds/api/standardfeeds/top_rated?v=2&alt=json";
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self start];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^
                   {
                       dispatch_async(dispatch_get_main_queue(), ^{

                       });
                       [self start];
                       //[[NSRunLoop currentRunLoop] runUntilDate:
                       // [NSDate dateWithTimeIntervalSinceNow:1]];
                       NSLog(@"thread finish");

                   });
}

- (void) sendyouTubeRequest {
    NSURL *url = [NSURL URLWithString:@"https://gdata.youtube.com/feeds/api/standardfeeds/top_rated?v=2&alt=json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error);
        }
        
        NSError *jsonError;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        
        if (jsonError) {
            NSLog(@"%@", jsonError);
        }
        NSLog(@"%@", [json description]);
        
    }];
}


-(void)clear {
    self.total = 0;
    self.downloadData = [[NSMutableData alloc] init];
}

-(void)start {
    NSURL *url = [NSURL URLWithString:self.srcURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    self.conn = [NSURLConnection connectionWithRequest:req delegate:self];
    // Start the connection
    [self.conn start];
}

-(void)startWithRunLoop {
    NSURL *url = [NSURL URLWithString:self.srcURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    self.conn = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    // Main roop
    [self.conn scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.conn start];
}


#pragma mark -
#pragma mark - Delegate
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    
    // Redirect?
    // You can add additional things for request
    return request;
}

#pragma mark - Complete Response
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Get complete response
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if ( httpResponse.statusCode != 200 ) {
        // Something wrong.
        NSLog(@"Something wrong");
        [connection cancel];
        return;
    }
}

#pragma mark - Receive Data
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError *jsonError;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if (jsonError) {
        NSLog(@"%@", jsonError);
    }
    NSLog(@"%@", [json description]);

    // How many bytes in this chunk
    self.total += [data length];  // Add total
    [self.downloadData appendData:data];
}

#pragma mark - Failed
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Load failed with error %@", [error localizedDescription]);
    // Error handling
    // Close file delete tmp file or something
}

#pragma mark - Entire request has benn loaded, data was finished
-(void) connectionDidFinishLoading:(NSURLConnection *)connection {
    // File operation or complete operations
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
