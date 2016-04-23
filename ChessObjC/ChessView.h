//
//  ChessView.h
//  ChessObjC
//
//  Created by hoangdangtrung on 4/19/16.
//  Copyright © 2016 hoangdangtrung. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChessObj;

typedef enum {
    King, 
    Queen, 
    Bishop,
    Knight,
    Rook,
    Pawn
}ChessPieces;

@interface ChessView : UIView

@property(nonatomic, strong) NSArray *baseArray;
@property(nonatomic, strong) NSDictionary *chessPosition;
@property(nonatomic, strong) NSString *playerMove;
@property(nonatomic, strong) NSString *nameChess;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) ChessObj *chessObj;


- (BOOL)calculatePositionWithCurrentPosition:(NSArray*)curPos andDestinationPosition:(NSArray*)desPos;

- (NSString*) convertToString:(ChessPieces) chessPieces;

@end
