//
//  SWYNetworkFile.h
//  FineChat
//
//  Created by shi on 2016/10/22.
//  Copyright © 2016年 shiweiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWYNetworkFile : NSObject

/**上传文件,NSData格式*/
@property (strong, nonatomic, readonly) NSData *fileData;
/**上传文件在本地的路径,如果fileData有值,则会忽略fileURL. fileURL为这类型的格式@"file://path/to/image.jpg"*/
@property (strong, nonatomic, readonly) NSString *fileURL;
/**上传文件的文件名,如    @"a.jpg",@"a.mp3"...     */
@property (strong, nonatomic, readonly) NSString *fileName;
/**与服务器对应,按服务器需求传,如   @"file"...  */
@property (strong, nonatomic, readonly) NSString *name;
/**文件的类型,如   @"image/jpeg"...   */
@property (strong, nonatomic, readonly) NSString *mimeType;

- (instancetype)initWithFileData:(NSData *)fileData
                        fileName:(NSString *)fileName
                            name:(NSString *)name
                        mimeType:(NSString *)mimeType;

- (instancetype)initWithFileURL:(NSString *)fileURL
                       fileName:(NSString *)fileName
                           name:(NSString *)name
                       mimeType:(NSString *)mimeType;

@end

