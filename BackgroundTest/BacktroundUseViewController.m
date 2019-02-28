//
//  BacktroundUseViewController.m
//  BackgroundTest
//
//  Created by cjyang on 27/02/2019.
//  Copyright © 2019 NHNENT. All rights reserved.
//

#import "BacktroundUseViewController.h"
#import "AppDelegate.h"


@interface BacktroundUseViewController() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic) NSURLSession *session;
@property (nonatomic) NSURLSessionDownloadTask *downloadTask;

@end


@implementation BacktroundUseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.session = [self backgroundSession];
    self.progressView.progress = 0;
}


- (void)dealloc
{
    NSLog(@"call dealloc");
}


#pragma mark - Action


- (IBAction)tappedDownloadButton:(id)sender
{
    if(self.downloadTask == nil)
    {
        NSURL *downloadURL = [NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/d/da/Internet2.jpg"];
        NSURLRequest *request = [NSURLRequest requestWithURL:downloadURL];

        self.downloadTask = [self.session downloadTaskWithRequest:request];
        [self.downloadTask resume];
    }
}


- (IBAction)tappedCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark NSURLSessionDownloadDelegate


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = progress;
    });
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
    NSURL *destinationURL = [self downloadedFilePathWithDownloadTask:downloadTask didFinishDownloadingToURL:downloadURL];
    
    if(destinationURL != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            
            self.imageView.image = image;
        });
    }
}


#pragma mark - NSURLSessionTaskDelegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error == nil)
    {
        NSLog(@"Task: %@ completed successfully", task);
    }
    else
    {
        NSLog(@"Task: %@ completed with error: %@", task, [error localizedDescription]);
    }
    
    double progress = (double)task.countOfBytesReceived / (double)task.countOfBytesExpectedToReceive;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.progressView.progress = progress;
        }];
    });
    
    self.downloadTask = nil;
}


#pragma mark - NSURLSessionDelegate


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session API_AVAILABLE(ios(7.0), watchos(2.0), tvos(9.0)) API_UNAVAILABLE(macos)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *sAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(sAppDelegate.backgroundURLSessionCompletionHandler != nil)
        {
            sAppDelegate.backgroundURLSessionCompletionHandler();
        }
    });
}


#pragma mark - Helper


- (NSString *)sessionIdentifier
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);

    return (__bridge_transfer NSString *)uuidStringRef;
}


- (NSURLSession *)backgroundSession
{
    NSURLSessionConfiguration *sConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[self sessionIdentifier]];
    sConfig.discretionary = YES;
    sConfig.sessionSendsLaunchEvents = YES;
    
    return [NSURLSession sessionWithConfiguration:sConfig delegate:self delegateQueue:nil];
}


- (NSURL *)downloadedFilePathWithDownloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)downloadURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *URLs = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [URLs objectAtIndex:0];
    
    NSURL *originalURL = [[downloadTask originalRequest] URL];
    NSURL *destinationURL = [documentsDirectory URLByAppendingPathComponent:[originalURL lastPathComponent]];
    NSError *errorCopy;
    
    [fileManager removeItemAtURL:destinationURL error:NULL];
    
    BOOL success = [fileManager copyItemAtURL:downloadURL toURL:destinationURL error:&errorCopy];
    
    if (success)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithContentsOfFile:[destinationURL path]];
            self.imageView.image = image;
            self.imageView.hidden = NO;
        });
    }
    else
    {
        NSLog(@"Error during the copy: %@", [errorCopy localizedDescription]);
        
        destinationURL = nil;
    }
    
    return destinationURL;
}


@end
