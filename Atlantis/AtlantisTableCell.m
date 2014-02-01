//
//  AtlantisTableCell.m
//  Atlantis
//
//  Created by Kevin Burg on 2/1/14.
//  Copyright (c) 2014 Tartanhacks2014. All rights reserved.
//

#import "AtlantisTableCell.h"

@implementation AtlantisTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
