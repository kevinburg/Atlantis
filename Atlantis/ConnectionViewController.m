//
//  ConnectionViewController.m
//  Atlantis
//
//  Created by Kevin Burg on 2/1/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "ViewController.h"
#import "ConnectionViewController.h"

@interface ConnectionViewController ()

@end

@implementation ConnectionViewController


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
    self.connectionLabel.text = self.connectionLabelText;
    
    NSMutableData *imageData;
    imageData = [[NSMutableData alloc] init]; // the image will be loaded in here
    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.connectionLabelText];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:2];
    
    // Run request asynchronously
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest
                                                                     delegate:self];
    if (!urlConnection)
        NSLog(@"Failed to download picture");
    
	// Do any additional setup after loading the view.
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.profilePicture.image = [UIImage imageWithData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

- (IBAction)buttonClicked:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
