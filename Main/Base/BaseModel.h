//
//  BaseModel.h
//  BaseModalTest
//
//  Created by gj on 15/8/22.
// Copyright © 2015年 www.iphonetrain.com 无限互联. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 
    在字典中找到Key对应的值。
 
    把值赋给model相应的属性。
 
 
    //子类里提供 mapDic(映射字典)
    // 属性名字：数据字典key
       stuAge:age
 
    student
    stuAge
 
 
    dataDic
    key:age   value:12
 

 
 */

// @property (nonamic,copy)NSString *userName
// 数据字典   key ：user_name



@interface BaseModel : NSObject

/**
    建立映射字典
  { key =  propertyName：value = 字段name(数据字典的key)}
    userName ： user_name
 
 */


//初始化方法
-(id)initWithDataDic:(NSDictionary*)dataDic;

//属性映射字典
- (NSDictionary*)attributeMapDictionary;

//设置属性
- (void)setAttributes:(NSDictionary*)dataDic;

@end
