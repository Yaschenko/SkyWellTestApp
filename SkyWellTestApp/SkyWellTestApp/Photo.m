//
//  Photo.m
//  SkyWellTestApp
//
//  Created by Yurii on 2/19/16.
//  Copyright © 2016 Nostris. All rights reserved.
//

#import "Photo.h"
@import AFNetworking;
@import MagicalRecord;
@implementation Photo
// Insert code here to add functionality to your managed object subclass
-(void)setData:(NSDictionary *)item {
    self.url = [item valueForKey:@"photo_604"];
    self.width = [item valueForKey:@"width"];
    self.height = [item valueForKey:@"height"];
    if (!self.url) {
        [self MR_deleteEntity];
    }
}
@end
