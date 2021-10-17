#ifndef KISKA_GUI_GRID

    #define KISKA_GUI_GRID 1

    #define UI_GRID_X (0.5)
    #define UI_GRID_Y (0.5)
    #define UI_GRID_W (2.5 * pixelW * pixelGrid)
    #define UI_GRID_H (2.5 * pixelH * pixelGrid)

    #define POS_X(N) N * UI_GRID_W + UI_GRID_X
    #define POS_Y(N) N * UI_GRID_H + UI_GRID_Y
    #define POS_W(N) N * UI_GRID_W
    #define POS_H(N) N * UI_GRID_H

    #define GUI_TEXT_SIZE(MULTIPLIER) 0.0208333 * safezoneH * MULTIPLIER

#endif
