//
//  Post+CoreDataProperties.h
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *postId;
@property (nullable, nonatomic, retain) NSNumber *date;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *type;
@property (nullable, nonatomic, retain) NSSet<Photo *> *relationship;

@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addRelationshipObject:(Photo *)value;
- (void)removeRelationshipObject:(Photo *)value;
- (void)addRelationship:(NSSet<Photo *> *)values;
- (void)removeRelationship:(NSSet<Photo *> *)values;

@end

NS_ASSUME_NONNULL_END
