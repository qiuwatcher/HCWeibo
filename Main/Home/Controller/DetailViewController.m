//
//  DetailViewController.m
//  HCWeibo
//
//  Created by gj on 15/12/14.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "DetailViewController.h"
#import "WXRefresh.h"
#import "AppDelegate.h"
#import "CommentModel.h"
#import "SinaWeibo.h"
#import "CommentTableView.h"

@interface DetailViewController ()<SinaWeiboRequestDelegate>

@end

@implementation DetailViewController{

    SinaWeiboRequest *_request; //网络请求对象
    CommentTableView *_tableView; //评论列表
    NSMutableArray *_dataArray;//评论存放的数组
}

//#define comments  @"comments/show.json"   //评论列表
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建列表
    [self _createTableView];
    //加载数据
    [self _loadData];
    
}



- (void)viewDidAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    //当界面弹出的时候，断开网络链接
    [_request disconnect];
    
}




- (void)_createTableView{
    
    //01 创建tableView
    _tableView = [[CommentTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    //02 传递数据
    _tableView.weiboModel = self.layoutFrame.weiboModel;
    
    
    //03 上拉加载
    __weak DetailViewController *weakSelf = self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf _loadMoreData];
    }];
    
}

//加载数据
- (void)_loadData{
    
    // 注意bug: 在 http://open.weibo.com/wiki/2/place/nearby_timeline 接口中返回的微博id 类型为string ,以前是NSNumber，会导致在 跳转微博详情的时候数据解析错误
    // 以下用self.weiboModel.weiboIdStr

    
    NSString *weiboId = self.layoutFrame.weiboModel.weiboIdStr;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    //第一次加载
    _request.tag = 100;
    
}

//加载更多数据
- (void)_loadMoreData{
    NSString *weiboId = [self.layoutFrame.weiboModel.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:weiboId forKey:@"id"];
    
    
    //设置max_id 分页加载
    CommentModel *cm = [_dataArray lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastID = cm.idstr;
    [params setObject:lastID forKey:@"max_id"];
    
    
    SinaWeibo *sinaWeibo = [self sinaweibo];
    _request =  [sinaWeibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _request.tag = 102;
    
    
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"网络接口 请求成功");
    
    //停止动画
    [_tableView.infiniteScrollingView stopAnimating];
    
    
    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comentModelArray = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (NSDictionary *dataDic in array) {
        CommentModel *commentModel = [[CommentModel alloc]initWithDataDic:dataDic];
        [comentModelArray addObject:commentModel];
    }
    
    
    if (request.tag == 100) {
        _dataArray = comentModelArray;
        
    }else if(request.tag ==102){//更多数据
  
        if (comentModelArray.count > 1) {
            [comentModelArray removeObjectAtIndex:0];
            [_dataArray addObjectsFromArray:comentModelArray];
        }else{
            return;
        }
    }
    
    _tableView.commentDataArray = _dataArray;
    //评论个数获取
    NSNumber *total = [result objectForKey:@"total_number"];
    NSInteger count = [total integerValue];
    _tableView.commentCount = count;
    [_tableView reloadData];
    
}



@end
