//
//  PlayScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "PlayScreen.h"

@interface PlayScreen ()

@end

@implementation PlayScreen {
    CGFloat margin;
    CGFloat h0;
    UIView *containerView;
    CGFloat kCellWidth;
    NSArray *currentPosition;
    NSArray *arrayNames;
    NSArray *baseArray;
    NSString *currentPlayer;
    NSString *currentRival;
    NSString *subNamePlayer;
    NSString *subNameRival;
    UIView *previousChess;
    bool lock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    margin = 10.0;
    h0 = 160.0;
   
    kCellWidth = 0.0;
    currentPosition = @[@0, @0];
    arrayNames = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    baseArray = [NSArray ]
    Array(count: 8, repeatedValue: Array(count: 8, repeatedValue: 0))
    var currentPlayer = "Computer"
    var currentRival = "NoName"
    var subNamePlayer = "white"
    let subNameRival = ""
    var previousChess: UIView!
    var lock = false

}





@end
