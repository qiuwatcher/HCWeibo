//
//  HomeViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "ThemeImageView.h"
#import "ThemeManager.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "WXRefresh.h"
#import "ThemeLabel.h"

#import <AudioToolbox/AudioToolbox.h>



@interface HomeViewController ()

@end

@implementation HomeViewController{

    WeiboTableView *tableView;
    
    NSMutableArray *dataArray;
    
    ThemeImageView *_barImageView;
    ThemeLabel *_barLabel;
    
    
}


- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    return delegate.sinaweibo;
}



- (void)_loadNewData{
    //[self showLoading:YES];
    
     [self showHUD:@"正在加载。。。"];
    SinaWeibo *weibo = [self sinaweibo];
    if ([weibo isAuthValid]) {
        NSLog(@"已经登录");
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        //since_id :  dataArray[0]-->id
    
        //得到最新的微博 Id，dataArray[0]微博的id
        if (dataArray.count != 0) {
            
            WeiboViewLayoutFrame *layoutFrame = dataArray[0];
            WeiboModel *model = layoutFrame.weiboModel;
            NSString *idStr = model.weiboIdStr;
            
            [params setObject:idStr forKey:@"since_id"];

        }
        
        [params setObject:@"10" forKey:@"count"];
        

        SinaWeibo *sinaweibo = [self sinaweibo];
        SinaWeiboRequest *request =  [sinaweibo requestWithURL:home_timeline
                           params:params
                       httpMethod:@"GET"
                         delegate:self];
        request.tag = 100;
        
        
    
    }else{
        [weibo logIn];
    }
    
}
//上拉加载更多（旧数据）
- (void)_loadOldData{
    

    
    SinaWeibo *weibo = [self sinaweibo];
    if ([weibo isAuthValid]) {
        NSLog(@"已经登录");
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        //since_id :  dataArray[0]-->id
        
        //得到最新的微博 Id，dataArray[0]微博的id
        if (dataArray.count != 0) {
            
            WeiboViewLayoutFrame *layoutFrame = dataArray.lastObject;
            
            WeiboModel *model = layoutFrame.weiboModel;
            NSString *idStr = model.weiboIdStr;
            
            [params setObject:idStr forKey:@"max_id"];
            
        }
        
        [params setObject:@"10" forKey:@"count"];
        
        
        SinaWeibo *sinaweibo = [self sinaweibo];
        SinaWeiboRequest *request =   [sinaweibo requestWithURL:home_timeline
                           params:params
                       httpMethod:@"GET"
                         delegate:self];
        request.tag = 101;
        
        
    }else{
        [weibo logIn];
    }


}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    
    //下拉刷新
    __weak HomeViewController *weakSelf = self;
    //下拉刷新控件
    [tableView addPullDownRefreshBlock:^{
        NSLog(@"下拉刷新");
        [weakSelf _loadNewData];
    }];
    
    //上拉刷新
    [tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"上拉刷新");
        [weakSelf _loadOldData];
        
    }];
    
    
    //加载微博数据
   
    [self _loadNewData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result{
   // NSLog(@"已经获得数据 %@",result);
//    [self showLoading:NO];
    
    [self completeHUD:@"加载完成!"];
   // [self hideHUD];
    //停止刷新控件动画
    [tableView.pullToRefreshView stopAnimating];
    [tableView.infiniteScrollingView stopAnimating];
   
    //model类
    NSArray *dicArray = result[@"statuses"];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:dicArray.count];
    
    for (NSDictionary *weiboDic in dicArray) {
        
        WeiboModel *model = [[WeiboModel alloc] initWithDataDic:weiboDic];
        
        WeiboViewLayoutFrame *layoutFrame = [[WeiboViewLayoutFrame alloc] init];
        layoutFrame.weiboModel = model;
        [tempArray addObject:layoutFrame];
        
    }
    
    if (tempArray.count == 0) {
        return;
    }
    
    if (dataArray == nil) {
        dataArray = tempArray;
    }else{
        
        
        if (request.tag == 100) {
            
            
            [self showNewWeiboCount:tempArray.count];
            
            
            //下拉刷新
            NSRange range = NSMakeRange(0, tempArray.count);
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:range];
            
            [dataArray insertObjects:tempArray atIndexes:indexSet];
            
        }else{
            //上拉
            if (tempArray.count > 1) {
                [tempArray removeObjectAtIndex:0];
                [dataArray addObjectsFromArray:tempArray];
            }else{
                return;
            }
            
        }
    }
    
    //传递给tableView
    tableView.dataArray = dataArray;
    [tableView reloadData];
    
}



//Timeline_Notice_color
//timeline_notify.png
//msgcome.wav
//显示提示声音
- (void)showNewWeiboCount:(NSInteger)count{

    //imageView
    //labelView
    if (_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc] initWithFrame:CGRectMake(10, -40, kScreenWidth-20, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        
        _barLabel = [[ThemeLabel alloc] initWithFrame:_barImageView.bounds];
        _barLabel.colorName = @"Timeline_Notice_color";
        _barLabel.textAlignment = NSTextAlignmentCenter;
        _barLabel.backgroundColor = [UIColor clearColor];
        [_barImageView addSubview:_barLabel];
        

    }
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:0.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 40);
            
            
        } completion:^(BOOL finished) {
        
            
            [UIView animateWithDuration:0.6 animations:^{
                //停留1秒
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];

            
        }];
    }
    
    //播放声音 播放系统声音
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];

    
    //import <AudioToolbox/AudioToolbox.h>
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
    


}




@end
