//
//  LoginScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "LoginScreen.h"
#import <Firebase/Firebase.h>
#import "PlayScreen.h"

static NSString * const kFirebaseURL = @"https://chess-techmaster.firebaseio.com/";


@interface LoginScreen ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;

@property(nonatomic, strong) Firebase *ref;
@property(nonatomic, strong) Firebase *currentUser;


@end

@implementation LoginScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self firebaseIsSetup]) {
        self.ref = [[Firebase alloc] initWithUrl:kFirebaseURL];
    }
    
//    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
//    self.currentUser = [[[[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@", self.ref]] childByAppendingPath:@"users"] childByAppendingPath:userID];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (IBAction)doSignInButton:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    [self loginWithEmail:email andPassword:password];

}

- (IBAction)doSignUpButton:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    if (![email  isEqual: @""] && ![password  isEqual: @""]) {
        [self.ref createUser:email password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
            if (error == nil) {
                [self loginWithEmail:email andPassword:password];
            } else {
                NSLog(@"Sign Up Error %@", error);
                //https://www.firebase.com/docs/web/guide/user-auth.html#section-full-error
            }
        }];
    } else {
        NSLog(@"Sign Up Error 2");
    }
}

- (IBAction)doPlayButton:(id)sender {
    PlayScreen *playScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayScreen"];
    playScreen.currentPlayer = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    [self.navigationController pushViewController:playScreen animated:YES];
}

- (IBAction)doSignOutButton:(id)sender {
}

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)pass {
    if (![email  isEqual: @""] && ![pass  isEqual: @""]) {
        [self.ref authUser:email password:pass withCompletionBlock:^(NSError *error, FAuthData *authData) {
            if (error == nil) {
                [[NSUserDefaults standardUserDefaults] setValue:authData.uid forKey:@"uid"];
                [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"username"];
                NSLog(@"OK");
                
            } else {
                NSLog(@"Errorxx");
            }
        }];
    } else {
        NSLog(@"Errorxxx2");
    }
}


- (BOOL)firebaseIsSetup {
    if ([@"https://chess-techmaster.firebaseIO.com" isEqualToString:kFirebaseURL]) {
        return YES;
    } else {
        return YES;
    }
}


@end





















