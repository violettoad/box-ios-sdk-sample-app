//
//  ViewController.m
//  FolderPicker-SampleApp
//
//  Created on 5/27/13.
//  Copyright (c) 2013 Box, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, readwrite, strong) BoxFolderPickerViewController *folderPicker;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)browseAction:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *thumbnailPath = [basePath stringByAppendingPathComponent:@"BOX"];
    
#error Set your client ID and client secret in the BoxSDK
    [BoxSDK sharedSDK].OAuth2Session.clientID = @"YOUR_CLIENT_ID";
    [BoxSDK sharedSDK].OAuth2Session.clientSecret = @"YOUR_CLIENT_SECRET";
    
    self.folderPicker = [[BoxSDK sharedSDK] folderPickerWithRootFolderID:BoxAPIFolderIDRoot
                                                       thumbnailsEnabled:YES
                                                    cachedThumbnailsPath:thumbnailPath
                                                    fileSelectionEnabled:YES];
    self.folderPicker.delegate = self;
    
    UINavigationController *controller = [[BoxFolderPickerNavigationController alloc] initWithRootViewController:self.folderPicker];
    controller.modalPresentationStyle = UIModalPresentationFormSheet;

    [self presentViewController:controller animated:YES completion:nil];
}   

- (IBAction)purgeAction:(id)sender 
{
    [self.folderPicker purgeCache];
}


- (void)folderPickerController:(BoxFolderPickerViewController *)controller didSelectBoxItem:(BoxItem *)item
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.nameLabel.text = [NSString stringWithFormat:@"%@ picked : %@", item.type, item.name];
        self.idLabel.text = item.modelID;
    }];
    
}

- (void)folderPickerControllerDidCancel:(BoxFolderPickerViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
