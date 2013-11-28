//
//  UITableView+ObjectTag.m
//  BLNestedTableViewDemo
//
//  Created by Black.Lee on 13-11-28.
//  Copyright (c) 2013年 Black.Lee. All rights reserved.
//

#import "UIView+ObjectTag.h"
#import <objc/message.h>

static char const *OBJECT_TAG_IDENTIFIER;

@implementation UIView (ObjectTag)
-(void)setObjectTag:(id)objectTag {
    objc_setAssociatedObject(self, &OBJECT_TAG_IDENTIFIER, objectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)objectTag{
    return objc_getAssociatedObject(self, &OBJECT_TAG_IDENTIFIER);
}

@end
