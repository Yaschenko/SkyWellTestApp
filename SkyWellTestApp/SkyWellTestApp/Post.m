//
//  Post.m
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "Post.h"
#import "Photo.h"
@import Foundation;
@import MagicalRecord;
@implementation Post

// Insert code here to add functionality to your managed object subclass
-(void)setData:(NSDictionary *)item {
    if (!item) {
        return;
    }
    if ([item valueForKey:@"copy_history"]) {
        [self setData:[item valueForKey:@"copy_history"][0]];
        return;
    }
    self.postId = [item valueForKey:@"post_id"];
    if (!self.postId) {
        [self MR_deleteEntity];
        return;
    }
    self.date = [item valueForKey:@"date"];
    self.type = [item valueForKey:@"type"];
    self.text = [item valueForKey:@"text"];

    if (![item valueForKey:@"attachments"]) return;
    
    for (NSDictionary* attachment in [item valueForKey:@"attachments"]) {
        if (![(NSString *)[attachment valueForKey:@"type"] isEqualToString:@"photo"]) continue;
        NSString *imageUrl = [[attachment valueForKey:@"photo"] valueForKey:@"photo_604"];
        Photo *photo = [Photo MR_findFirstByAttribute:@"url" withValue:imageUrl inContext:self.managedObjectContext];
        if (!photo) {
            photo = [Photo MR_createEntityInContext:self.managedObjectContext];
            [photo setData:[attachment valueForKey:@"photo"]];
            [self addRelationshipObject:photo];
        }
    }
    return;
}
@end
