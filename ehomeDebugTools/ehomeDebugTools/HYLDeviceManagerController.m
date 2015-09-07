//
//  HYLDeviceManagerController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDeviceManagerController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "HYLRoutes.h"
#import <ELNetworkService/ELNetworkService.h>
#import "HYLClassUtils.h"
#import <JSONKit/JSONKit.h>
@interface HYLDeviceManagerController (){
    MBProgressHUD *hud;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)switchPage:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation HYLDeviceManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    self.webView.scrollView.delegate=self;
    self.webView.delegate=self;
    
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webView.bounds.size.height,self.webView.bounds.size.width,self.webView.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webView.scrollView addSubview:_refreshHeaderView];
        
        
        
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    [self.segmentedControl setEnabled:NO forSegmentAtIndex:0];
    
    
    
    NSString *filePath=[[HYLRoutes uiResourcePath] stringByAppendingPathComponent:@"manager.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mobile_deleteDevice"]=^(){
      
        NSArray *arguments=[JSContext currentArguments];
        
        int objectId=[arguments[0] toInt32];
        
        [self deleteDeviceById:objectId];
        
    };
    

    
}

-(void)deleteDeviceById:(int)objectId{
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
       
       BOOL isDeleteSuccess=[[ElApiService shareElApiService] deleteObject:objectId];
        
       [[NSOperationQueue mainQueue] addOperationWithBlock:^{
          
           if(isDeleteSuccess){
               [self loadHtmlData];
           }
           
       }];
        
        
    }];
}


-(void)loadHtmlData{
    NSOperationQueue *queue=[[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation=[NSBlockOperation blockOperationWithBlock:^{
          NSDictionary *devsDic=[[ElApiService shareElApiService] getObjectListAndFieldsByUser];
         NSMutableArray *allDeviceObj=[NSMutableArray new];
         [devsDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
            
            NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
            
            [allDeviceObj addObject:objectMap];
            
         }];
        
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadAsynData(%@,%@)",[@[] JSONString],[allDeviceObj JSONString]]];
             
             _reloading=NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
             
         }];
    }];
    [queue addOperation:operation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)switchPage:(id)sender {
    UISegmentedControl *segmentControl=(UISegmentedControl *)sender;
    
    NSLog(@"%ld",[segmentControl selectedSegmentIndex]);
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_switchPage(%d)",1]];
    
    
}


#pragma mark delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_switchPage(%d)",1]];
    [self loadHtmlData];

    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [hud hide:YES];
}
#pragma mark scrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}

#pragma mark EGORefreshTableHeaderDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _reloading=YES;
    [self loadHtmlData];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}

@end
