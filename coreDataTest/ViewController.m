//
//  ViewController.m
//  coreDataTest
//
//  Created by lichao on 2017/3/9.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"
#import "LCCoreDataManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBtn];
}

/** 
 插入数据
 */
- (void)clickInsertBtn
{
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];
    
    personModel.name = @"kobe";
    personModel.age = 37;
    personModel.height = 198;

    [coreDataManager insertModel:personModel];
}

/** 
 删除数据 
 */
- (void)clickDeleteBtn
{
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];
    
    //predicateString--需要删除的数据的条件
    [coreDataManager removeModel:personModel predicateString:@"age = 40"];
}

/** 
 修改数据 
 */
- (void)clickChangeBtn
{
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];
    
    //要修改的数据
    personModel.name = @"jordon";
    personModel.height = 199;
    personModel.age = 40;
    
    //需要被修改的数据   (所有age = 37的进行修改)
    [coreDataManager changeModel:personModel predicateString:@"age = 37"];
    
}

/**
 查询数据
 */
- (void)clickSearchBtn
{
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];
    
    //要查询数据的条件
    NSMutableArray *PersonArr = [coreDataManager findByModel:personModel predicateString:@"age = 37"];

    NSLog(@"%ld", PersonArr.count);
    
    for (Person *personM in PersonArr) {
        NSLog(@"%@=%d=%d", personM.name,personM.age, personM.height);
    }
    
}


- (void)setUpBtn
{
    UIButton *insertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    insertBtn.backgroundColor = [UIColor redColor];
    insertBtn.frame = CGRectMake(100, 100, 150, 30);
    [insertBtn setTitle:@"插入数据" forState:UIControlStateNormal];
    [insertBtn addTarget:self action:@selector(clickInsertBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insertBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.backgroundColor = [UIColor redColor];
    deleteBtn.frame = CGRectMake(100, 200, 150, 30);
    [deleteBtn setTitle:@"删除数据" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(clickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.backgroundColor = [UIColor redColor];
    changeBtn.frame = CGRectMake(100, 300, 150, 30);
    [changeBtn setTitle:@"修改数据" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(clickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor redColor];
    searchBtn.frame = CGRectMake(100, 400, 150, 30);
    [searchBtn setTitle:@"查询数据" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(clickSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
}


@end
