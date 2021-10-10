#ifndef PROFILE_BACKGROUND_COLOR
	#define PROFILE_BACKGROUND_COLOR(ALPHA)\
	{\
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.13])",\
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.54])",\
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.21])",\
		ALPHA\
	}
#endif

#ifndef GREY_COLOR
    #define GREY_COLOR(PERCENT,ALPHA) {PERCENT,PERCENT,PERCENT,ALPHA}
#endif
