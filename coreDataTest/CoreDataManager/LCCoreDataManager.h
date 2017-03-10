//
//  LCCoreDataManager.h
//  coreDataTest
//
//  Created by lichao on 2017/3/8.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface LCCoreDataManager : NSObject

/** 
 管理对象上下文 
 */
@property (nonatomic, strong)  NSManagedObjectContext *context;

+ (instancetype)shareInstanceWithStoreName:(NSString *)storeName;


/** 
 插入数据 
 */
- (BOOL)insertModel:(id)model;
/** 
 删除数据
 */
- (BOOL)removeModel:(id)model predicateString:(NSString *)predicateString;
/** 
 修改数据 
 */
- (BOOL)changeModel:(id)model predicateString:(NSString *)predicateString;
/** 
 查找数据
 */
- (NSMutableArray *)findByModel:(id)model predicateString:(NSString *)predicateString;

@end
