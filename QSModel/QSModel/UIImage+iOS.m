//
//  UIImage+iOS.m
//  QSModel
//
//  Created by apple on 2019/8/28.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "UIImage+iOS.h"
#import "objc/runtime.h"

@implementation UIImage (iOS)

- (void)setUrl:(NSString *)url {
    objc_setAssociatedObject(self, @selector(url), url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)url {
    return objc_getAssociatedObject(self, @selector(url));
}

- (void)clearAssociated {
    objc_removeAssociatedObjects(self);
}




@end
