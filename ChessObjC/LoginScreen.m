//
//  LoginScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "LoginScreen.h"

@interface LoginScreen ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;



@end

@implementation LoginScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)doSignInButton:(id)sender {
    NSString *email = self.textFieldEmail.text;
    NSString *password = self.textFieldPassword.text;
    
    [self loginWithEmail:email andPassword:password];

}

- (IBAction)doSignUpButton:(id)sender {
}

- (IBAction)doPlayButton:(id)sender {
}

- (IBAction)doSignOutButton:(id)sender {
}

- (void)loginWithEmail:(NSString*)email andPassword:(NSString*)pass {
}




@end





















