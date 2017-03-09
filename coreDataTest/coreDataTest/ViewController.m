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

/** 
 管理对象上下文 
 */
@property (nonatomic, strong)  NSManagedObjectContext *managedObjectContext;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBtn];
}

/** 
 插入数据
 */
- (void)clickBtn1
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
- (void)clickBtn2
{
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];
    
    //predicateString--需要删除的数据的条件
    [coreDataManager removeModel:personModel predicateString:@"age = 40"];
}

/** 
 修改数据 
 */
- (void)clickBtn3
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
- (void)clickBtn4
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
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [UIColor redColor];
    btn1.frame = CGRectMake(100, 100, 150, 30);
    [btn1 setTitle:@"插入数据" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [UIColor redColor];
    btn2.frame = CGRectMake(100, 200, 150, 30);
    [btn2 setTitle:@"删除数据" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.backgroundColor = [UIColor redColor];
    btn3.frame = CGRectMake(100, 300, 150, 30);
    [btn3 setTitle:@"修改数据" forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(clickBtn3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.backgroundColor = [UIColor redColor];
    btn4.frame = CGRectMake(100, 400, 150, 30);
    [btn4 setTitle:@"查询数据" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(clickBtn4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn4];
}


@end
