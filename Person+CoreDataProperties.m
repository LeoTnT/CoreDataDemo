//
//  Person+CoreDataProperties.m
//  coreDataTest
//
//  Created by lichao on 2017/3/9.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;
@dynamic age;
@dynamic height;

@end
