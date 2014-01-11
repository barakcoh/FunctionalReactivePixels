//
//  FRPPhotoImporter.m
//  FunctionalReactivePixels
//
//  Created by Barak Cohen on 1/4/14.
//  Copyright (c) 2014 Barak Cohen. All rights reserved.
//

#import "FRPPhotoImporter.h"
#import "FRPPhotoModel.h"

@implementation FRPPhotoImporter

+(NSURLRequest *)popularURLRequest {
    return [[PXRequest apiHelper] urlRequestForPhotoFeature:PXAPIHelperPhotoFeaturePopular resultsPerPage:100 page:0 photoSizes:PXPhotoModelSizeThumbnail sortOrder:PXAPIHelperSortOrderRating except:PXPhotoModelCategoryNude];
}


+(RACReplaySubject *)importPhotos {
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self popularURLRequest];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            [subject sendNext:[[[results[@"photos"] rac_sequence]
                                map:^id(NSDictionary *photoDictionary) {
                                    FRPPhotoModel *model = [FRPPhotoModel new];
                                    [self configurePhotoModel:model withDictionary:photoDictionary];
                                    [self downloadThumbnailForPhotoModel:model];
                                    
                                    return model;
                                }] array]];

            [subject sendCompleted];
        } else {
            [subject sendError:connectionError];
        }
    }];
    
    return subject;
}

#pragma mark - Private Methods

+(void)configurePhotoModel:(FRPPhotoModel *)photoModel withDictionary:(NSDictionary *)dictionary {
    // Basics details fetched with the first, basic request
    photoModel.photoName = dictionary[@"name"];
    photoModel.identifier = dictionary[@"id"];
    photoModel.photographerName = dictionary[@"user"][@"username"];
    photoModel.rating = dictionary[@"rating"];
    
    photoModel.thumbnailURL = [self urlForImageSize:3 inDictionary:dictionary[@"images"]];
    
    if (dictionary[@"voted"]) {
        photoModel.votedFor = [dictionary[@"voted"] boolValue];
    }
    
    // Extended attributes fetched with subsequent request
    if (dictionary[@"comments_count"]) {
        photoModel.fullsizedURL = [self urlForImageSize:4 inDictionary:dictionary[@"images"]];
    }
}

+(NSString *)urlForImageSize:(NSInteger)size inDictionary:(NSArray *)array {
    /*
     (
     {
     size = 3;
     url = "http://ppcdn.500px.org/49204370/b125a49d0863e0ba05d8196072b055876159f33e/3.jpg";
     }
     );
     */
    
    return [[[[[array rac_sequence] filter:^BOOL(NSDictionary *value) {
        return [value[@"size"] integerValue] == size;
    }] map:^id(id value) {
        return value[@"url"];
    }] array] firstObject];
}

+(void)downloadThumbnailForPhotoModel:(FRPPhotoModel *)photoModel {
    NSAssert(photoModel.thumbnailURL, @"Thumbnail URL must not be nil");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:photoModel.thumbnailURL]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        photoModel.thumbnailData = data;
                           }];
}

@end
