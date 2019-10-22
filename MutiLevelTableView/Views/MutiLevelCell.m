//
//  MutiLevelCell.m
//  MutiLevelTableView
//
//  Created by wdyzmx on 2019/10/18.
//  Copyright © 2019 wdyzmx. All rights reserved.
//

#import "MutiLevelCell.h"

@interface MutiLevelCell ()
/// 标题title
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MutiLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        _arrowImgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_arrowImgView];
        [self setSubviews];
    }
    return self;
}

- (void)setSubviews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLabel.frame = CGRectMake(10, 0, CGRectGetWidth(self.contentView.frame) - 30, 50);
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor grayColor];
    
    _arrowImgView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 25, 50 / 2 - 25 / 2, 25, 25);
    _arrowImgView.image = [UIImage imageNamed:@"right_arrow"];
}

- (void)fillCellWithViewModel:(MutiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    MutiLevelModel *model = viewModel.placesArray[indexPath.row];
    if (model.level == 1) {
        _titleLabel.textColor = [UIColor redColor];
        _arrowImgView.hidden = NO;
    }
    if (model.level == 2) {
        _titleLabel.textColor = [UIColor blueColor];
        _arrowImgView.hidden = NO;
    }
    if (model.level == 3) {
        _titleLabel.textColor = [UIColor  orangeColor];
        _arrowImgView.hidden = YES;
    }
    if (model.isExpand) {
        _arrowImgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else {
        _arrowImgView.transform = CGAffineTransformIdentity;
    }
    _titleLabel.text = model.name;
    _titleLabel.frame = CGRectMake(model.level * 10, 0, CGRectGetWidth(self.contentView.frame) - 20 - model.level * 10, 50);
}

- (void)setCellWithViewModel:(MutiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath {
    MutiLevelCraftModel *model = viewModel.craftsArray[indexPath.row];
    NSMutableArray *allCraftsArrayCopy = [viewModel.allCraftsArray mutableCopy];
    [allCraftsArrayCopy removeObject:model];
    viewModel.otherCraftsArray = allCraftsArrayCopy;
    BOOL isMatched = NO;
    for (MutiLevelCraftModel *craftModel in viewModel.otherCraftsArray) {
        if ([craftModel.pid isEqualToString:model.craft_id]) {
            isMatched = YES;
        }
    }
    if (isMatched) {
        _arrowImgView.hidden = NO;
    } else {
        _arrowImgView.hidden = YES;
    }
    if (model.isExpand) {
        _arrowImgView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else {
        _arrowImgView.transform = CGAffineTransformIdentity;
    }
    _titleLabel.text = model.name;
    NSArray *array = [model.level_code componentsSeparatedByString:@"."];
    _titleLabel.frame = CGRectMake(array.count * 10, 0, CGRectGetWidth(self.contentView.frame) - 20 - array.count * 10, 50);
}

- (void)makeArrowImgViewRotation:(CGFloat)rotation {
    //执行箭头旋转动画
    [UIView animateWithDuration:0.3 animations:^{
        self->_arrowImgView.transform = CGAffineTransformMakeRotation(rotation);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
