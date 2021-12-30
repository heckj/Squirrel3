//
//  squirrel.c
//  
//
//  Squirrel Eiserloh's hash function
//

#include "squirrel.h"
#include <stdio.h>

uint64_t Squirrel3( uint64_t position ) {
    const uint64_t BIT_NOISE1 = 0xB5297A4DB5297A4D;
    const uint64_t BIT_NOISE2 = 0x68E31DA468E31DA4;
    const uint64_t BIT_NOISE3 = 0x1B56C4E91B56C4E9;
    
    uint64_t mangled = position;
    mangled *= BIT_NOISE1;
    mangled ^= (mangled >> 8);
    mangled += BIT_NOISE2;
    mangled ^= (mangled << 8);
    mangled *= BIT_NOISE3;
    mangled ^= (mangled >> 8);
    return mangled;
}
