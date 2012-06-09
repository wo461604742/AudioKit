//  mySoundGenerator.m

#import "SoundGenerator.h"

typedef enum
{
    kPValuePitchTag=4,
}kPValueTag;

@implementation SoundGenerator

-(id) initWithOrchestra:(CSDOrchestra *)newOrchestra {
    self = [super initWithOrchestra:newOrchestra];
    if (self) {
        // CSDFunctionTable * iSine = [[CSDFunctionTable alloc] initWithType:kGenSine UsingSize:iFTableSize];
        
        //float partialStrengths[] = {1.0f, 0.5f, 1.0f};
        //CSDParamArray * partialStrengthParamArray = [CSDParamArray paramArrayFromFloats:partialStrengths count:3];

        CSDParamArray * partialStrengthParamArray = [CSDParamArray paramArrayFromParams:
                                                     [CSDParamConstant paramWithFloat:1.0f],
                                                     [CSDParamConstant paramWithFloat:0.5f],
                                                     [CSDParamConstant paramWithFloat:1.0f], nil];
        
        CSDSineTable * sineTable = [[CSDSineTable alloc] initWithTableSize:4096 PartialStrengths:partialStrengthParamArray];
        [self addFunctionTable:sineTable];
        
        //H4Y - ARB: This assumes that CSDFunctionTable is ftgentmp
        //  and will look for [CSDFunctionTable output] during csd conversion
        myOscillator = [[CSDOscillator alloc] initWithAmplitude:[CSDParamConstant paramWithFloat:0.4]
                                                          Pitch:[CSDParamConstant paramWithPValue:kPValuePitchTag]
                                                  FunctionTable:sineTable];
        [myOscillator setOutput:[CSDParam paramWithString:FINAL_OUTPUT]];
        [self addOpcode:myOscillator];
    }
    return self;
}

-(void) playNoteForDuration:(float)dur Pitch:(float)pitch {
    int instrumentNumber = [[orchestra instruments] indexOfObject:self] + 1;
    NSString * note = [NSString stringWithFormat:@"%0.2f %0.2f", dur, pitch];
    [[CSDManager sharedCSDManager] playNote:note OnInstrument:instrumentNumber];
}

@end
