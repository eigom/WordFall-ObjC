//
//  GameViewController.m
//  WordFall
//
//  Created by eigo on 26/01/15.
//  Copyright (c) 2015 eigo. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "MWDefinition.h"
#import "MWDefinitions.h"
#import "MWWord.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

#pragma ads

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Ad loaded");
    [self presentAdBannerAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Ad failed");
    [self dismissAdBannerAnimated:YES];
}

- (void)presentAdBannerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?1.0:0.0 animations:^{
        bannerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAdBannerAnimated:(BOOL)animated
{
    [UIView animateWithDuration:animated?1.0:0.0 animations:^{
        bannerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
    }];
}

- (CGRect)bannerFrame
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return CGRectMake(0.0, 0.0, self.view.frame.size.width, 32.0);
    } else {
        return CGRectMake(0.0, 0.0, self.view.frame.size.width, 66.0);
    }
}

#pragma Definition

- (void)presentWordDefinition:(MWWord *)word withDuration:(CFTimeInterval)duration
{
    MWDefinition *d = [word.definitions firstItem];
    _definitionTextView.text = d.definition;
}

- (void)dismissWordDefinitionWithDuration:(CFTimeInterval)duration
{
    
}

#pragma view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // ad banner
    //
    bannerView = [[ADBannerView alloc] initWithFrame:[self bannerFrame]];
    bannerView.delegate = self;
    [self.view addSubview:bannerView];
    [self dismissAdBannerAnimated:NO];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    SKView *skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        //GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        GameScene *scene = [[GameScene alloc] initWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [scene setShouldPresentWordDefinition:^(MWWord *word, CFTimeInterval duration) {
            [self presentWordDefinition:word withDuration:duration];
        }];
        
        [scene setShouldDismissWordDefinition:^(CFTimeInterval duration) {
            [self dismissWordDefinitionWithDuration:duration];
        }];
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

- (GameScene *)gameScene
{
    SKView *skView = (SKView *)self.view;
    
    return (GameScene *)skView.scene;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
