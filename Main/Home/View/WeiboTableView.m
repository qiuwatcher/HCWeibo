//
//  WeiboTableView.m
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "WeiboTableView.h"
#import "UIView+UIViewController.h"
#import "DetailViewController.h"


static NSString *weiboCellId = @"weiboCellId";


@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        //注册单元格
        
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];

        [self registerNib:nib forCellReuseIdentifier:weiboCellId];
    }
    return self;


}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        
        [self registerNib:nib forCellReuseIdentifier:weiboCellId];

        
    }
    return self;
}


#pragma mark - TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return  1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    WeiboViewLayoutFrame *layoutFrame = self.dataArray[indexPath.row];
    
    
    return  layoutFrame.frame.size.height+80;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //01 方法一
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        
//    }
//    return cell;
    
    
    //02 方法二
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
//    
//    return cell;
    
    
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:weiboCellId forIndexPath:indexPath];
    
    //cell.model = self.dataArray[indexPath.row];
    cell.layoutFrame = self.dataArray[indexPath.row];
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"被点击了");
    
    //拿到视图控制器 
    UIViewController *vc = self.viewController;
  //  vc.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
    

    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.title = @"微博详情";
    detail.layoutFrame = _dataArray[indexPath.row];
    [vc.navigationController pushViewController:detail animated:YES];
    
    
    
    


}






@end
