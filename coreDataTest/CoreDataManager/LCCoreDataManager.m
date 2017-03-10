//
//  LCCoreDataManager.m
//  coreDataTest
//
//  Created by lichao on 2017/3/8.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "LCCoreDataManager.h"
#import <objc/runtime.h>

#define Class_Name(CName) NSStringFromClass([CName class])

@interface LCCoreDataManager ()

/**
 管理对象模型
 */
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;

/**
 持久化存储调度器
 */
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 数据库名
 */
@property(nonatomic, strong) NSString *storeName;

@end

static LCCoreDataManager *coreData;


@implementation LCCoreDataManager

+ (instancetype)shareInstanceWithStoreName:(NSString *)storeName
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreData = [[self alloc] init];
        coreData.storeName = storeName;
    });
    return coreData;
}

#pragma mark --数据的增删改查
/**
 插入数据
 */
- (BOOL)insertModel:(id)model
{
    NSManagedObject *manager = [NSEntityDescription insertNewObjectForEntityForName:Class_Name(model) inManagedObjectContext:_context];
    for (NSString *propertyName in [self ClassAttributes:model]) {
        [manager setValue:[model valueForKey:propertyName] forKey:propertyName];
    }
    BOOL result = [self saveContext];

    if (result) {
        NSLog(@"插入数据成功__%@", model);
    }else{
        NSLog(@"插入数据失败");
    }

    return result;
}
/**
 删除数据
 */
- (BOOL)removeModel:(id)model predicateString:(NSString *)predicateString
{
    NSError *error = nil;
    NSArray *listArray = [_context executeFetchRequest:[self fetchRequest:Class_Name(model) predicate:predicateString] error:&error];
    
    if (listArray.count > 0) {
        for (NSManagedObject *manager in listArray) {
            [_context deleteObject:manager];
        }
        NSLog(@"删除成功");
    }else{
        NSLog(@"数据为空,无法继续删除");
    }
    return [self saveContext];
}

/**
 修改数据
 */
- (BOOL)changeModel:(id)model predicateString:(NSString *)predicateString
{
    NSError *error = nil;
    NSArray *listArray = [_context executeFetchRequest:[self fetchRequest:Class_Name(model) predicate:predicateString] error:&error];
    
    if (listArray.count > 0) {
        for (NSManagedObject *manager in listArray) {
            for (NSString *propertyName in [self ClassAttributes:model]) {
                [manager setValue:[model valueForKey:propertyName] forKey:propertyName];
            }
            NSLog(@"修改成功__%@", manager);
        }
    }
    return [self saveContext];
}

/**
 查询数据
 */
- (NSMutableArray *)findByModel:(id)model predicateString:(NSString *)predicateString
{
    NSError *error = nil;
    NSArray *listArray = [_context executeFetchRequest:[self fetchRequest:Class_Name(model) predicate:predicateString] error:&error];
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:listArray];
    
    return resultArray;
}


#pragma mark --懒加载需要初始化的对象
/** 
 NSManagedObjectModel
 */
- (NSManagedObjectModel *)managedObjectModel{
    if (!_managedObjectModel) {
        
        //URL为coreDataTest.xcdatamodeld(你本地的xcdatamodeld名)的
        //注意:拓展名应该是momd,而不是xcdatamodeld
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"coreDataTest" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

/**
 NSPersistentStoreCoordinator
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator) {
        //创建coodinator需要传入的managedObjectModel
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        //指定本地的SQLite数据库文件
        NSURL *sqliteURL = [[self documentDirectoryURL] URLByAppendingPathComponent:@"coreDataTest.sqlite"];
        
        NSLog(@"本地SQLite数据库文件路径=%@", sqliteURL);
        
        NSError *error;
        //为 persistentStoreCoordinator 制定本地存储的类型, 这里制定的是SQLite
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:nil error:&error];
        
        if (error) {
            NSLog(@"failed to create persistentStoreCoordinator__%@", error.localizedDescription);
        }
    }
    return _persistentStoreCoordinator;
}

/**
 NSManagedObjectContext
 */
- (NSManagedObjectContext *)context{
    
    if (!_context) {
        // 指定context的并发类型:NSMainQueueConcurrencyType 或 NSPrivateQueueConcurrencyType
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _context;
}

#pragma mark --allAttributes
- (NSMutableArray *)ClassAttributes:(id)classModel
{
    NSMutableArray *array = [NSMutableArray array];
    NSString *className = Class_Name(classModel);
    const char *cClassName = [className UTF8String];
    
    id classM = objc_getClass(cClassName);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(classM, &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *attributeName = [NSString stringWithUTF8String:property_getName(property)];
        
        [array addObject:attributeName];
    }
    return array;
}

#pragma mark --save
- (BOOL)saveContext
{
    NSManagedObjectContext *context = [self context];
    if (context) {
        NSError *error = nil;
        if ([context hasChanges] && ![context save:&error]) {
            abort();
            return NO;
        }
    }
    return YES;
}

#pragma mark --读取数据请求
- (NSFetchRequest *)fetchRequest:(NSString *)entityName predicate:(NSString *)predicateString
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:_context]];
    
    if (predicateString != nil) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
    }
    return request;
}
    

#pragma mark --创建document目录
- (nullable NSURL *)documentDirectoryURL
    {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}


@end
