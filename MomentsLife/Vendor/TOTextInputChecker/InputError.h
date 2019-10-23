//
//  InputError.h
//  mbank
//
//  Created by Ted on 13-11-18.
//
//

#ifndef mbank_InputError_h
#define mbank_InputError_h

enum InputCheckError {
    InputCheckErrorNone = 0,
    InputCheckErrorNull = 1,
    InputCheckErrorShot = 2,
    InputCheckErrorSmall = 3,
    InputCheckErrorOnlyLength = 4,
    InputCheckErrorRegex = 5,
};

#endif
