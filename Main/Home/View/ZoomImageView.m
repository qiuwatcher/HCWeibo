//
//  ZoomImageView.m
//  HCWeibo
//
//  Created by gj on 15/12/16.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "ZoomImageView.h"

@implementation ZoomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化手势
        [self _initTap];
        [self _createGifView];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //初始化手势
        [self _initTap];
        [self _createGifView];
    }
    return self;
    

}


- (void)_createGifView{

    _gifIconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _gifIconView.hidden = YES;
    _gifIconView.image = [UIImage imageNamed:@"timeline_gif.png"];
    [self addSubview:_gifIconView];

}


//初始化手势
- (void)_initTap{
    //01 打开交互
    self.userInteractionEnabled = YES;
    //02 创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zoomIn)];
    
    [self addGestureRecognizer:tap];

}


//创建子视图
- (void)_createView{
    if (_scrollView == nil) {
        //01 创建scrollView 添加到window上
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        
        //设置放大倍数
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 2.0;
        
        [self.window addSubview:_scrollView];
        
        //02 创建fullImageView
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.image = self.image;
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_fullImageView];
        
        //04 添加缩小手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
    }
    
}



#pragma mark - 放大缩小
//放大
- (void)_zoomIn{
    
    //01 创建scrollView fullImageView
    [self _createView];
    //02 转换frame,把imageView相对于tableViewCell的位置装换成相对于window的
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    
    _fullImageView.frame = frame;
    
    //03 添加动画
    [UIView animateWithDuration:0.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
        
    } completion:^(BOOL finished) {
        //下载原始图片
        [self _loadFullImage];
        
    }];
    
}


- (void)_zoomOut{
    
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:1 animations:^{
        
        _scrollView.contentOffset = CGPointZero;
        //坐标转换
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;

        
    } completion:^(BOOL finished) {
        
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        
    }];
    

}
#pragma mark - 下载图片

- (void)_loadFullImage{
    
    if (_fullImageUrl != nil) {
        //00 进度条显示
        _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        
        
        //01 构建url
        NSURL *url = [NSURL URLWithString:_fullImageUrl];
        
        //02 构建request
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //03 创建链接
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }
    
}

#pragma mark - 网络代理
//服务器响应请求
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    //01 得到响应头
    NSDictionary *httpHeaderFields = [httpResponse allHeaderFields];
   // NSLog(@"%@",httpHeaderFields);
    
    //02 获取文件大小
    NSString *length = [httpHeaderFields objectForKey:@"Content-Length"];
    
    _dataLength = [length doubleValue];
    
    //03 创建NSMutableData 用来存放数据
    _data = [[NSMutableData alloc] init];
    

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
    CGFloat progress = _data.length/_dataLength;
   // NSLog(@"下载进度 = %lf",progress);
    _hud.progress = progress;

}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"下载完成");
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    
    //长图处理
    //图片在屏幕上显示宽/高 ==  图片的宽/图片的高
    CGFloat length = image.size.height/image.size.width* kScreenWidth;
    
    if (length > kScreenHeight) {

        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
        }];
    
    }
    //判断是否gif图片
    if (_gifIconView.hidden == NO) {
        //显示gif图片
        [self _showGif];
    }
    
    
    
}

//gif图片显示
- (void)_showGif{
    //方法一 : 用webView显示
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
//    
//    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//    [_scrollView addSubview:webView];
//    
    
    
    //方法二 :三方，注意看原理
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
    
    //方法三: 底层接口
   // #import <ImageIO/ImageIO.h>
    //01 创建图片源
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    
    //02 获取图片个数
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i<count; i++) {
        //从图片源中获取每一张图片
        CGImageRef imageCg = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        UIImage *imageUi = [UIImage imageWithCGImage:imageCg];
        [images addObject:imageUi];
        CGImageRelease(imageCg);
        
    }
    CFRelease(source);
    
    
    //03>>1 imageView 播放张图片方法一
//    _fullImageView.animationImages = images;
//    _fullImageView.animationDuration = images.count*0.1;
//    [_fullImageView startAnimating];
    
    //03>>2 imageView 播放多张图片方法二
    
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:images.count*0.1];
    _fullImageView.image = animatedImage;
    



}



#pragma mark - ScrollViewDelegate 
//返回要缩放的视图
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{

    return _fullImageView;
}







@end
