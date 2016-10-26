//
//  SWYNetworkFile.m
//  FineChat
//
//  Created by shi on 2016/10/22.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import "SWYNetworkFile.h"

@interface SWYNetworkFile ()

@property (strong, nonatomic) NSData *fileData;

@property (strong, nonatomic) NSString *fileURL;

@property (strong, nonatomic) NSString *fileName;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *mimeType;

@end

@implementation SWYNetworkFile

- (instancetype)initWithFileURL:(NSString *)fileURL fileName:(NSString *)fileName name:(NSString *)name mimeType:(NSString *)mimeType
{
    if (self = [super init]) {
        _fileURL = fileURL;
        _fileName = fileName;
        _name = name;
        _mimeType = mimeType;
    }
    
    return self;
}

- (instancetype)initWithFileData:(NSData *)fileData fileName:(NSString *)fileName name:(NSString *)name mimeType:(NSString *)mimeType
{
    if (self = [super init]) {
        _fileData = fileData;
        _fileName = fileName;
        _name = name;
        _mimeType = mimeType;
    }
    
    return self;
}

@end




