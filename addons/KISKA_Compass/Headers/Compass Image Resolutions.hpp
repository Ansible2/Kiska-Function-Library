// since we are just sliding the compass image to simulate rotation, the image can't be slid any father on the images width then 158 pixels
#define MIN_COMPASS_WIDTH 158
// same as above, except in reverse for the max the image can slide
#define MAX_COMPASS_WIDTH 2678
// The difference between MIN_COMPASS_WIDTH & MAX_COMPASS_WIDTH. This is the pixel width of the "useable part of the comapss image"
#define COMPASS_USEABLE_WIDTH 2520

// the actual dimensions of the compass image 4096 x 64
#define COMPASS_IMAGE_RES_W 4096
#define COMPASS_IMAGE_RES_H 64

#define COMPASS_CENTER_MARKER_RES_W 16
