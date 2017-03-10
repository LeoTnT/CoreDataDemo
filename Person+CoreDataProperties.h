//
//  Person+CoreDataProperties.h
//  coreDataTest
//
//  Created by lichao on 2017/3/9.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nonatomic) int16_t height;

@end

NS_ASSUME_NONNULL_END
