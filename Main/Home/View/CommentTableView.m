//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "CommentTableView.h"
#import "WeiboViewLayoutFrame.h"
#import "Common.h"


@implementation CommentTableView

static NSString *cellId = @"cellId";

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self =  [super initWithFrame:frame style:style];
    if (self) {
        //头视图
        [self _creatHeaderView];
        self.delegate = self;
        self.dataSource = self;
        //注册 单元格
        UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:[NSBundle mainBundle]];
        [self registerNib:nib forCellReuseIdentifier:cellId];
    
    }
    return  self;
}

- (void)_creatHeaderView{
    //1.创建父视图
    _theTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    _theTableHeaderView.backgroundColor = [UIColor clearColor];
    
    //2.加载xib创建用户视图
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] lastObject];
    
    
    _userView.width = kScreenWidth;
    _userView.backgroundColor =  [UIColor colorWithWhite:0.5 alpha:0.1];
    [_theTableHeaderView addSubview:_userView];
    
    
    //3.创建微博视图
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    _weiboView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_theTableHeaderView addSubview:_weiboView];
    

    
    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        
        //1.创建微博视图的布局对象，在详情页面重新计算layoutFrame
        WeiboViewLayoutFrame *layoutframe = [[WeiboViewLayoutFrame alloc] init];
        //isDetail 需要先赋值
        layoutframe.isDetail = YES;
        layoutframe.weiboModel = weiboModel;
        
        _weiboView.layoutFrame = layoutframe;
        _weiboView.frame = layoutframe.frame;
    
        _weiboView.top = _userView.bottom + 5;

        //2.用户视图
        _userView.weiboModel = weiboModel;

        //3.设置头视图
        _theTableHeaderView.height = _weiboView.bottom;
        
        self.tableHeaderView = _theTableHeaderView;
        
     
    }
    
}


#pragma mark -  TabelView 代理


//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
 
    //2.评论Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blackColor];

    
    //3.评论数量
  
    countLabel.text = [NSString stringWithFormat:@"评论:%li",self.commentCount];
    [sectionHeaderView addSubview:countLabel];
    
    sectionHeaderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    return sectionHeaderView;
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//设置单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentModel *model = self.commentDataArray[indexPath.row];
    //计算单元格的高度
    CGFloat height = [CommentCell getCommentHeight:model];
    
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.commentModel = self.commentDataArray[indexPath.row];

    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentDataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}








@end
