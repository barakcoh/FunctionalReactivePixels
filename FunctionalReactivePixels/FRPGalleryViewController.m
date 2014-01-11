//
//  FRPGalleryViewController.m
//  FunctionalReactivePixels
//
//  Created by Barak Cohen on 1/4/14.
//  Copyright (c) 2014 Barak Cohen. All rights reserved.
//

#import "FRPGalleryViewController.h"
#import "FRPGalleryFlowLayout.h"
#import "FRPPhotoImporter.h"
#import "FRPCell.h"

static NSString *CellIdentifier = @"Cell";

@interface FRPGalleryViewController ()

@property(nonatomic,strong)NSArray*photosArray;

@end

@implementation FRPGalleryViewController

-(id)init
{
     FRPGalleryFlowLayout *flowLayout = [[FRPGalleryFlowLayout alloc] init];
     self = [self initWithCollectionViewLayout:flowLayout];
     if (!self) return nil;
    
     return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Popular on 500px";
    
    [self.collectionView registerClass:[FRPCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    @weakify(self);
    [RACObserve(self, photosArray) subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [self loadPopularPhotos];
}

-(void)loadPopularPhotos {
    [[FRPPhotoImporter importPhotos] subscribeNext:^(id x) {
        self.photosArray = x;
    } error:^(NSError *error) {
        NSLog(@"Couldn't fetch photos from 500px");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FRPCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell setPhotoModel:self.photosArray[indexPath.row]];
     
     return cell;
}

@end
