//
//  WeiboViewLayoutFrame.m
//  HCWeibo
//
//  Created by gj on 15/12/11.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "WeiboViewLayoutFrame.h"
#import "Common.h"
#import "WXLabel.h"

@implementation WeiboViewLayoutFrame

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        //计算各控件frame
        [self _caculateFrame];
    }
}

//- (void)_caculateFrame{
//
//    _frame = CGRectMake(50, 50, 310, 320);
//    
//    _textFrame = CGRectMake(0, 0, 300, 100);
//    _rTextFrame = CGRectMake(10, 110, 280, 100);
//    _imageFrame = CGRectMake(10, 220, 80, 80);
//    _bgImageFrame = CGRectMake(10, 110, 280, 200);
//    
//
//}

- (void)_caculateFrame{
    //1\ 整个weiboView 的 坐标以及宽度
    CGFloat weiboViewWidth = 0;

    
    CGFloat weiboFontSize = FontSize_Weibo(self.isDetail);
    CGFloat reWeiboFontSize = FontSize_ReWeibo(self.isDetail);
    
    if (self.isDetail) {
       //详情页面
       weiboViewWidth = kScreenWidth;
       self.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
    }else{
       weiboViewWidth = kScreenWidth-60;
       self.frame = CGRectMake(50, 35, weiboViewWidth, 0);
    }
    

    //2\ 原创微博内容宽度
    CGFloat textWidth = weiboViewWidth-20;
    NSString *text = self.weiboModel.text;
    
    CGFloat textHeight = [WXLabel getTextHeight:weiboFontSize width:textWidth text:text linespace:5.0];
    
    self.textFrame = CGRectMake(10, 10, textWidth, textHeight);
    
    
    //3 转发微博判断
    if (self.weiboModel.repostWeiboModel == nil) {//无转发
        //判断是否有图片
        NSString *thumbNailImage = self.weiboModel.thumbnailImage;
        if (thumbNailImage != nil) {
            
            //80*80
            CGFloat imgX = CGRectGetMinX(self.textFrame);//self.textFrame.origin.x;
            CGFloat imgY = CGRectGetMaxY(self.textFrame)+10;
            
            self.imageFrame = CGRectMake(imgX, imgY, 80, 80);
            
        }
    
    }else{//有转发
        //>> 01 转发微博的Frame
        //转发的微博文字
        NSString *rText = self.weiboModel.repostWeiboModel.text;
        //转发微博宽度
        CGFloat rTextWidth = textWidth-20;
        //转发微博高度
        CGFloat rTextHeight = [WXLabel getTextHeight:reWeiboFontSize width:rTextWidth text:rText linespace:5.0];
        
        //转发微博X坐标，Y坐标
        CGFloat rTextX = CGRectGetMinX(self.textFrame)+10;
        CGFloat rTextY = CGRectGetMaxY(self.textFrame)+10;
        
        self.rTextFrame = CGRectMake(rTextX, rTextY, rTextWidth, rTextHeight);
        
        //>>02 转发微博图片处理
        NSString *rThumbnailImage = self.weiboModel.repostWeiboModel.thumbnailImage;
        if (rThumbnailImage != nil) {
            
            CGFloat imgX = CGRectGetMinX(self.rTextFrame);//self.textFrame.origin.x;
            CGFloat imgY = CGRectGetMaxY(self.rTextFrame)+10;
            
            self.imageFrame = CGRectMake(imgX, imgY, 80, 80);
        }
        
        //>>03 转发微博背景图片处理
        CGFloat bgX = CGRectGetMinX(self.textFrame);
        CGFloat bgY = CGRectGetMaxY(self.textFrame);
        CGFloat bgWidth = textWidth;
        CGFloat bgHeight = 0.0;
        
        if (rThumbnailImage != nil) {
            
            bgHeight = CGRectGetMaxY(self.imageFrame)-bgY+10;
            
        }else{
        
            bgHeight = CGRectGetMaxY(self.rTextFrame)-bgY+10;
        }
        self.bgImageFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);
    
    
    }
    
    //计算整个weiboView的高度
    CGRect f = self.frame;
    
    if (self.weiboModel.repostWeiboModel != nil) {
        
        f.size.height = CGRectGetMaxY(self.bgImageFrame);
        
    }else if(self.weiboModel.thumbnailImage != nil ){
    
        f.size.height = CGRectGetMaxY(self.imageFrame);
    }else{
    
        f.size.height = CGRectGetMaxY(self.textFrame);
    
    }
    self.frame = f;
    
    

}






@end
