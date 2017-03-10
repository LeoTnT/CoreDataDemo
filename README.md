# CoreDataDemo
Making use of this code demo to use Core Data be convenient.


#####这样我们对Core Data的封装就完成了,具体的使用方法如下:
我们要在自己的控制器里面调用上述的几个接口, 对数据进行增删改查,

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
    LCCoreDataManager *coreDataManager = [LCCoreDataManager shareInstanceWithStoreName:@"Person"];

    Person *personModel = [[Person alloc] initWithEntity:[NSEntityDescription entityForName:@"Person" inManagedObjectContext:coreDataManager.context] insertIntoManagedObjectContext:nil];

    personModel.name = @"kobe";
    personModel.age = 37;
    personModel.height = 198;

    [coreDataManager insertModel:personModel];
}
