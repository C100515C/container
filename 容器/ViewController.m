//
//  ViewController.m
//  容器
//
//  Created by chen chen on 2021/7/17.
//  Copyright © 2021 chen chen. All rights reserved.
//

#import "ViewController.h"

@interface Item : NSObject
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) NSInteger price;

@end
@implementation Item

@end
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self container];
    [self cacheTest];
}

-(void)cacheTest{
    //NSCache 
    NSCache *cache = [[NSCache alloc] init];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        Item *item1 = [[Item alloc]init];
        item1.name = @"item1";
        item1.price = 1;
        [cache setObject:@"1" forKey:item1];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        Item *item1 = [[Item alloc]init];
        item1.name = @"item3";
        item1.price = 3;
        [cache setObject:@"3" forKey:item1];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        Item *item1 = [[Item alloc]init];
        item1.name = @"item2";
        item1.price = 2;
        [cache setObject:@"2" forKey:item1];
    });
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        [cache removeObjectForKey:@"1"];
    });
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"%@",[[cache objectForKey:@"1"] name]);
    });
}

-(void)container{
    Item *item1 = [[Item alloc]init];
    item1.name = @"item1";
    item1.price = 1;
    Item *item2 = [[Item alloc]init];
    item2.name = @"item2";
    item2.price = 2;
    Item *item3 = [[Item alloc]init];
    item3.name = @"item3";
    item3.price = 3;
    
    //NSCountedSet
    NSCountedSet *countSet = [[NSCountedSet alloc] init];
    [countSet addObject:item1];//数量+1
    [countSet addObject:item1];//数量+1
    [countSet addObject:item2];//数量+1
    [countSet addObject:item3];//数量+1
    [countSet removeObject:item1];//数量-1
    NSInteger count = [countSet countForObject:item1];//获取数量  =1
    
    //NSIndexSet && NSMutableIndexSet
    NSMutableIndexSet *indexs1 = [[NSMutableIndexSet alloc]init];
    [indexs1 addIndex:1];
    [indexs1 addIndex:3];
    NSArray *arr1 = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    NSLog(@"items=%@",[arr1 objectsAtIndexes:indexs1]);
    
    NSMutableIndexSet *indexs2 = [[NSMutableIndexSet alloc]init];
    [indexs2 addIndexesInRange:NSMakeRange(0, 2)];
    [indexs2 addIndexesInRange:NSMakeRange(4, 1)];
    NSArray *arr2 = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    NSLog(@"items=%@",[arr2 objectsAtIndexes:indexs2]);
    
    //NSOrderedSet && NSMutableOrderedSet
    NSString *str1 = @"str1";
    NSString *str2 = @"str2";
    NSString *str3 = @"str3";
    NSString *str4 = @"str4";
    NSOrderedSet *set = [[NSOrderedSet alloc] initWithObjects:str1,str2,str3,str4, nil];
    NSString *res1 = [set objectAtIndex:1];//
    NSInteger index = [set indexOfObject:str4];//
    NSString *res2 = set[2];//支持下标取值
    NSLog(@"res1=%@  index=%ld   res2=%@",res1,(long)index,res2);
    
    //NSPointerArray
    NSObject *obj = [[NSObject alloc] init];
    NSPointerArray *pointer1 = [NSPointerArray weakObjectsPointerArray];
    [pointer1 addPointer:(__bridge void *)(obj)];//obj 引用计数不会变化 添加时是weak引用
    
    NSPointerArray *pointer2 = [NSPointerArray strongObjectsPointerArray];
    [pointer2 addPointer:(__bridge void *)obj];//obj 引用计数+1 添加时是strong引用
    //注：obj 被释放后，pointerArray.count 依然是1，这是因为 NULL 也会参与占位。调用 compact 方法将清空所有的 NULL 占位。
    NSPointerArray *pointer = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsStrongMemory];
    /*
     我们可以通过函数 + pointerArrayWithOptions:指定更多有趣的存储方式。上面的NSPointerArray.weakObjectsPointerArray 实际上是 [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory] 的简化版。
     
     NSPointerFunctionsOptions 是一个选项，不同于枚举，选项类型是可以叠加的。这些选项可以分为内存管理、个性判定、拷贝偏好三大类
     */
    
    //NSMapTable
    NSMapTable *map = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsStrongMemory];
    /*
     使用类似 NSPointerArray
     不同是需要分别指定 key  和 value 的options
     */
    
    //NSHashTable
    NSHashTable *hastable = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
    /*
     使用类似 NSPointerArray
     */
}

@end
