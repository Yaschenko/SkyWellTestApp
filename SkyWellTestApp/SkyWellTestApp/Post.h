//
//  Post.h
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
-(void)setData:(NSDictionary *)item;
@end

NS_ASSUME_NONNULL_END

#import "Post+CoreDataProperties.h"
