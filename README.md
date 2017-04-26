# CoreDataDemo
CoreData的封装管理类,以及使用方法


### Core Data的封装类,具体的使用方法如下:
我们要在自己的控制器里面调用具体的几个接口, 对数据进行增删改查,

首先要引入模型类和管理类
    
    #import "Person+CoreDataClass.h"
    #import "LCCoreDataManager.h"


然后把我们刚才写好的管理类以及模型文件进行初始化

    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];
    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];

接下来就可以进行相应的增删改查操作了, 这些方法需要放在对应的调用方法里面:

    /** 
    插入数据
    */
    - (void)clickInsertBtn
    { 
        LCCorewDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];

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

