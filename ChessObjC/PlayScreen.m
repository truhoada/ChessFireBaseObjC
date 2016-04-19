//
//  PlayScreen.m
//  ChessObjC
//
//  Created by hoangdangtrung on 4/18/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import "PlayScreen.h"

@interface PlayScreen ()
@property (weak, nonatomic) IBOutlet UILabel *labelPlayer;
@property (weak, nonatomic) IBOutlet UIImageView *imgNextTurnPlayer;

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
    [self setupValue];
    [self setupTableChess];

}

- (void)setupValue {
    margin = 10.0;
    h0 = 160.0;
    
    kCellWidth = 0.0;
    currentPosition = @[@0, @0];
    arrayNames = @[@"Rook", @"Knight", @"Bishop", @"Queen", @"King", @"Pawn"];
    //    baseArray = [NSArray ]
    //    Array(count: 8, repeatedValue: Array(count: 8, repeatedValue: 0))
    currentPlayer = @"Computer";
    currentRival = @"NoName";
    subNamePlayer = @"white";
    subNameRival = @"";
    lock = false;
}

- (void)setupTableChess {
    self.labelPlayer.text = currentPlayer;
    containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - margin*2.0, self.view.bounds.size.width - margin*2.0)];
    
    containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:containerView];
    containerView.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    
    kCellWidth = (self.view.bounds.size.width - margin*2.0)/8.0;
    for (int rowIndex=0; rowIndex<8; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            UIView *cell = [[UIView alloc] initWithFrame:rect];
            
            if (rowIndex%2 == 0) {
                cell.backgroundColor = (colIndex%2 == 0) ? [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1] : [UIColor colorWithRed:255.0/255.0 green:178.0/255.0 blue:102.0/255.0 alpha:1];
            } else {
                cell.backgroundColor = (colIndex%2 == 0) ? [UIColor colorWithRed:255.0/255.0 green:178.0/255.0 blue:102.0/255.0 alpha:1] : [UIColor colorWithRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1];
            }
            [containerView addSubview:cell];
        }
    }
}


- (void)addChessPlayerWithTag: (int)tag andSubName: (NSString*)subName {
    for (int rowIndex=6; rowIndex<8; rowIndex++) {
        for (int colIndex=0; colIndex<8; colIndex++) {
            CGRect rect = CGRectMake((CGFloat)colIndex*kCellWidth, (CGFloat)rowIndex*kCellWidth, kCellWidth, kCellWidth);
            int tempCol = colIndex;
            if (tempCol > 4) {
                tempCol = (int)arrayNames.count - tempCol + 1;
            }
            NSString *name = @"";
            if (rowIndex == 7) {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames[tempCol]];
            } else {
                name = [NSString stringWithFormat:@"%@%@", subName, arrayNames.lastObject];
            }
            UIImage *img = [UIImage imageNamed:name];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
            imgView.image = img;
            
        }
    }
}

@end























