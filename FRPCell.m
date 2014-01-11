//
//  FRPCell.m
//  FunctionalReactivePixels
//
//  Created by Barak Cohen on 1/4/14.
//  Copyright (c) 2014 Barak Cohen. All rights reserved.
//

#import "FRPCell.h"
#import "FRPPhotoModel.h"
#import <UIKit/UIKit.h>

@interface FRPCell()

@property(nonatomic,weak)UIImageView *imageView;
@property(nonatomic,strong)RACDisposable *subscription;

@end

@implementation FRPCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.backgroundColor = [UIColor darkGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    return self;
}

-(void)setPhotoModel:(FRPPhotoModel *)photoModel {
    self.subscription = [[[RACObserve(photoModel, thumbnailData)
                         filter:^BOOL(id value) {
                            return value != nil;
                         }]
                         map:^id(id value) {
                              return [UIImage imageWithData:value];
                         }]
                         setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.subscription dispose], self.subscription = nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
