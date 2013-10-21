//
//  NEMutableArray.h
//  InChengdu20
//
//  Created by aaron on 1/30/12.
//  Copyright (c) 2012 joyotime. All rights reserved.
//

@interface DataModelArray : NSMutableArray {
    NSMutableArray  *m_dataStore;
    Class           m_itemType;
}

@property(nonatomic,assign) Class   itemType;

+ (id)arrayWithItemType:(Class)itemType;

- (void)fillWithJSONObejct:(NSArray *)jsonObject;

@end
