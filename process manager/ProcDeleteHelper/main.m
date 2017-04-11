//
//  main.m
//  ProcDeleteHelper
//
//  Created by sheen vempeny on 2/27/17.
//  Copyright © 2017 sheen vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        // Look at arguments.
        if (argc == 3)
        {
            OSStatus myStatus;
            AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
            AuthorizationRef myAuthorizationRef;
            
            myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
            if (myStatus != errAuthorizationSuccess)
                return myStatus;
            
            AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
            AuthorizationRights myRights = {1, &myItems};
            myFlags = kAuthorizationFlagDefaults |
            kAuthorizationFlagInteractionAllowed |
            kAuthorizationFlagPreAuthorize |
            kAuthorizationFlagExtendRights;
            
            myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, NULL, myFlags, NULL );
            if (myStatus != errAuthorizationSuccess)
                return myStatus;
            
            const char *myToolPath = argv[1];
            const char *myArguments[] = {argv[1], "--self-repair", argv[2], NULL};
            FILE *myCommunicationsPipe = NULL;
            
            myFlags = kAuthorizationFlagDefaults;
            myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, myToolPath, myFlags, myArguments, &myCommunicationsPipe);
            
        }
        else
        {
            if (argc == 4)
            {
                NSString *pidVal = [NSString stringWithUTF8String:argv[3]];
                
                kill( (pid_t)pidVal.integerValue, SIGKILL );
            }
        }

    }
    return 0;
}
