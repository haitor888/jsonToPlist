//
//  main.m
//  jsonToPlist
//
//  
//  转换本地文件 新增的
/// 使用例如   ./jsonToPlist 1.json "/Users/test/Desktop/2.plist"
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
         
        NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        
        // There should be three arguments: jsonToPlist jsonURL plistPath
        if ([arguments count] != 3) {
            NSLog(@"Usage: jsonToPlist jsonURL plistPath");
            return 0;
        }
        
        NSString *jsonURLArgument = [arguments objectAtIndex:1];
        NSString *plistPathArgument = [arguments objectAtIndex:2];
        
        /*
        NSString *jsonURLArgument = @"/Users/test/Desktop/1.json";
        NSString *plistPathArgument=@"/Users/test/Desktop/o.plist";
        */
        // Validate the json URL
        /*
        NSURL *jsonURL = [NSURL URLWithString:jsonURLArgument];
        if (jsonURL == nil) {
            NSLog(@"Could not parse jsonURL");
        }
         */
        
        NSError *error = nil;//NSString stringWithContentsOfURL:jsonURL
        NSString *jsonContent = [NSString stringWithContentsOfFile:jsonURLArgument
                                                         encoding:NSASCIIStringEncoding
                                                            error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return 0;
        }
        
        if (jsonContent == nil) {
            NSLog(@"Could not retrieve %@" , jsonURLArgument);
            return 0;
        }
        
        if ([jsonContent length] == 0) {
            NSLog(@"File at %@ contained no JSON" , jsonURLArgument);
            return 0;
        }
        
        // We've got something.  Is it JSON?
        //NSData * tmpData = [jsonContent dataUsingEncoding:(NSUTF8StringEncoding)];
        id nativeObject = [NSJSONSerialization JSONObjectWithData:[jsonContent dataUsingEncoding:NSUTF8StringEncoding]
                                                          options:0
                                                            error:&error];
    
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return 0;
        }
        
        if (nativeObject == nil) {
            NSLog(@"Could not decode JSON from %@" , jsonURLArgument);
            return 0;
        }
        
        // We have JSON.  Make sure the path exists, then save it to the specified path.
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[plistPathArgument stringByDeletingLastPathComponent]
                                  withIntermediateDirectories:YES
                                                   attributes:[NSDictionary dictionary]
                                                        error:&error];
        
        if (error) {
            NSLog(@"Error NSFileManager: %@", [error localizedDescription]);
            return 0;
        }

        BOOL written = [nativeObject writeToFile:plistPathArgument
                       atomically:YES];
        
        if (!written) {
            NSLog(@"Could not write file to %@", plistPathArgument);
            return 0;
        }

    }
    return 0;
}

