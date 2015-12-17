//
//  Common.h
//  HCWeibo
//
//  Created by gj on 15/12/7.
//  Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#ifndef Common_h
#define Common_h


// SDK
#define kAppKey             @"1748016323"
#define kAppSecret          @"c03ff8eec2575a3e01c854794f1cfd3a"
#define kAppRedirectURI     @"http://www.bjwxhl.com"

//#define kAppKey             @"2641230003"
//#define kAppSecret          @"848056b065e48d377af9484d4ea402b5"
//#define kAppRedirectURI     @"http://www.baidu.com"


#define kScreenWidth      [UIScreen mainScreen].bounds.size.width
#define kScreenHeight     [UIScreen mainScreen].bounds.size.height


#define ios7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)


//微博接口
#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json"  //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态



//微博字体
#define FontSize_Weibo(isDetail) isDetail?17:16  //微博字体
#define FontSize_ReWeibo(isDetail) isDetail?15:14 //转发微博字体




#endif /* Common_h */
