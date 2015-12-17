//
//  WeiboModel.m
//  HCWeibo
//
//  Created by gj on 15/12/10.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import "WeiboModel.h"



@implementation WeiboModel
//01 源生代码
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    NSLog(@"%@",key);
//    if ([key isEqualToString:@"text"]) {
//        self.myText = value;
//    }
//
//}


//02 BaseModel处理

- (NSDictionary*)attributeMapDictionary{

    
    
    //   @"属性名": @"数据字典的key"
    NSDictionary *mapAtt = @{
                             @"createDate":@"created_at",
                             @"weiboId":@"id",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnailImage":@"thumbnail_pic",
                             @"bmiddlelImage":@"bmiddle_pic",
                             @"originalImage":@"original_pic",
                             @"geo":@"geo",
                             @"repostsCount":@"reposts_count",
                             @"commentsCount":@"comments_count",
                             @"weiboIdStr":@"idstr"
                             };
    
    return mapAtt;
    
  

}


- (void)setAttributes:(NSDictionary*)dataDic{
    
    //01 调用父类的方法
    [super setAttributes:dataDic];
    
    //02 解析userModel
    NSDictionary *userDic = dataDic[@"user"];
    self.userModel = [[UserModel alloc] initWithDataDic:userDic];
    
    
    //03 被转发的微博
    NSDictionary *rWeiboDic = dataDic[@"retweeted_status"];
    if (rWeiboDic != nil) {
        self.repostWeiboModel = [[WeiboModel alloc] initWithDataDic:rWeiboDic];
        
        //处理被转发微博的用户名字
        NSString *rName = self.repostWeiboModel.userModel.screen_name;
        self.repostWeiboModel.text = [NSString stringWithFormat:@"@%@:%@",rName,self.repostWeiboModel.text];
        
        //self.repostWeiboModel.text
        
    }
    
    
    //04 微博来源处理
//    NSLog(@"%@",self.source);
    //<a href="http://app.weibo.com/t/feed/2OxDpx" rel="nofollow">未通过审核应用</a>
    //>.+<
    
    if (self.source != nil) {
        NSString *regex = @">.+<";
        NSArray *array = [self.source componentsMatchedByRegex:regex];
        if (array.count != 0) {
            NSString *source = array[0];
            NSString *subSource = [source substringWithRange:NSMakeRange(1, source.length-2)];
    
            
            self.source = [NSString stringWithFormat:@"来源:%@",subSource];
            
        }
        
    }
    
    //05 微博表情处理
 
    // <image url = '1.png'>
    //需要添加图片正则表达，默认为@"<image url = '[a-zA-Z0-9_\\.@%&\\S]*'>"
    //[哈哈] --> <image url = '1.png'>
    //>>01 找到所有的表情文字  [兔子]
    NSString *regex = @"\\[\\w+\\]";
    NSArray *faceItems = [self.text componentsMatchedByRegex:regex];
    //>>02 通过表情文字 在 emoticons.plist找到对应的图片名字 001.png
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    //配置信息
    NSArray *faceConfigArray = [NSArray arrayWithContentsOfFile:path];
    
    //>>03 文本替换 方法一:基本循环
    
//    for (NSString *faceName in faceItems) {
//        //faceName-->表情名字 [兔子]
//        for (NSDictionary *configDic in faceConfigArray) {
//            if ([configDic[@"chs"] isEqualToString:faceName]) {
//                //表情名字找到了
//                NSString *imageName = configDic[@"png"];
//                //生成<image url = '1.png'>文本
//                NSString *replaceString = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
//                //替换文本
//                self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceString];
//                
//            }
//            
//        }
//    }
//
    //>>03 文本替换 方法二：谓词过滤
    //faceConfigArray--> DIC
    for (NSString *faceName in faceItems) {
        
        //在faceConfigArray数组中查找 faceName对应的元素项
        //faceName = "兔子"   chs-->"兔子"
        
        NSString *predicateStr = [NSString stringWithFormat:@"self.chs='%@'",faceName];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateStr];
        
        NSArray *items = [faceConfigArray filteredArrayUsingPredicate:predicate];
        
        
        if (items.count > 0) {
            NSDictionary *configDic = items[0];
         
            NSString *imageName = configDic[@"png"];
            //生成<image url = '1.png'>文本
            NSString *replaceString = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            //替换文本
            self.text = [self.text stringByReplacingOccurrencesOfString:faceName withString:replaceString];
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
    

    
    
    
    
}





@end
