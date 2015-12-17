//
//  ViewController.m
//  LinkdinLoginDemoApp
//
//  Created by SitesSimply PTY. LTD on 17/12/2015.
//  Copyright © 2015 SitesSimply PTY. LTD. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
//#import "LIALinkedInClientExampleCredentials.h"
#import "LIALinkedInApplication.h"

@interface ViewController ()

@end

@implementation ViewController {
    LIALinkedInHttpClient *_client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _client = [self client];
    
}

- (IBAction)didTapConnectWithLinkedIn:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}


- (void)requestMeWithToken:(NSString *)accessToken {
    
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.visassimply.com/"
                                                                                    clientId:@"759m9uwhsda6h6"
                                                                                clientSecret:@"QkGYAtDkNMyX8X78"
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile", @"r_emailaddress"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
