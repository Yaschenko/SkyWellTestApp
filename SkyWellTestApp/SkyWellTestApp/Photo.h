//
//  Photo.h
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSManagedObject
typedef void(^PhotoDownloadCallback)(NSURL *file);
// Insert code here to declare functionality of your managed object subclass
-(void)setData:(NSDictionary *)item;
@end

NS_ASSUME_NONNULL_END

#import "Photo+CoreDataProperties.h"
