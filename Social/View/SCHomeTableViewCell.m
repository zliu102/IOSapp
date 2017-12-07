//
//  SCHomeTableViewCell.m
//  Social
//
//  Created by 刘子誉 on 2017/11/19.
//  Copyright © 2017年 刘子誉. All rights reserved.
//

#import "SCHomeTableViewCell.h"
#import "SCPost.h"
#import "UIImageView+AFNetWorking.h"

@interface SCHomeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) SCPost *post;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;

@end

@implementation SCHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.postImage.layer.masksToBounds = YES;
    self.postImage.layer.cornerRadius = 5.0;
    
    self.messageLabel.numberOfLines = 0;
    
    [self.messageLabel sizeToFit];
}

- (void)loadCellWithPost:(SCPost *)post
{
    self.post = post;
    self.titleLabel.text = post.name;
    self.messageLabel.text = post.message;
    [self.postImage setImageWithURL:[NSURL URLWithString:self.post.imageURL] placeholderImage:[UIImage imageNamed:@"loading"]];
}

+ (CGFloat)cellHeight
{
    return 120.0;
}

@end
