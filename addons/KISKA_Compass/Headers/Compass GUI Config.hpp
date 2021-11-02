#include "Compass IDCs.hpp"
#include "Compass Image Resolutions.hpp"
#include "Compass Globals.hpp"


class KISKA_compass_rsc
{
	idd = COMPASS_IDD;

	duration = 10e6;
	fadeIn = 0;
	fadeOut = 0;
	onLoad = "_this spawn KISKA_fnc_compass_mainLoop";

	class controls
	{

		class compassGroup : ctrlControlsGroupNoScrollbars
		{
			idc = COMPASS_GRP_IDC;

			y = 0;
			w = 0;
			h = COMPASS_IMAGE_RES_H * pixelH;


			class controls
			{
				class compassBackground : ctrlStaticPicture
				{
					idc = COMPASS_BACK_IDC;

					x = 0;
					y = 0;
					w = 0;
					h = COMPASS_IMAGE_RES_H * pixelH;
				};

				class compassPicture : ctrlStaticPictureKeepAspect
				{
					idc = COMPASS_IMG_IDC;

					x = -( MAX_COMPASS_WIDTH * pixelW );
					y = 0;
					w = COMPASS_IMAGE_RES_W * pixelW;
					h = COMPASS_IMAGE_RES_H * pixelH;
				};

				class center : ctrlStaticPictureKeepAspect
				{
					idc = COMPASS_CENTER_IDC;

					y = 0;
					w = COMPASS_CENTER_MARKER_RES_W * pixelW;
					h = COMPASS_IMAGE_RES_H * pixelH;
				};
			};
		};

	};
};
