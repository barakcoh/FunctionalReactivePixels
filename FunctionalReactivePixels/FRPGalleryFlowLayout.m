//
//  FRPGalleryFlowLayout.m
//  FunctionalReactivePixels
//
//  Created by Barak Cohen on 1/4/14.
//  Copyright (c) 2014 Barak Cohen. All rights reserved.
//

#import "FRPGalleryFlowLayout.h"

@implementation FRPGalleryFlowLayout

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(145, 145);
    self.minimumInteritemSpacing = 10;
    self.minimumLineSpacing = 10;
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return self;
}

@end