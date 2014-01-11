//
//  FRPPhotoImporter.h
//  FunctionalReactivePixels
//
//  Created by Barak Cohen on 1/4/14.
//  Copyright (c) 2014 Barak Cohen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPPhotoImporter : NSObject

+(RACSignal*)importPhotos;

@end
