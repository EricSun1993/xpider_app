/**
 * Author: Ye Tian <flymaxty@foxmail.com>
 * Copyright (c) 2016 Maker Collider Corporation.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 */

#ifndef GRID_MAP_LAYER_H_
#define GRID_MAP_LAYER_H_

#include "grid_map_common.h"

#include <vector>

namespace GMap {
  class GridMapLayer {
  public:

    GridMapLayer(int map_width, int map_height, float resolution);

    char** data() { return data_; }
    int resolution() { return resolution_; }

    int map_width() { return map_width_; }
    int map_height() { return map_height_; }
    int layer_width() { return layer_width_; }
    int layer_height() { return layer_height_; }

    char at(Cell cell);
    char at(Point point);

    bool set(Cell cell, char value);
    bool set(Point point, char value);

    Cell GetCell(Point point);
    Point GetCellCenter(Cell cell);
    bool CheckAreaEmpty(Cell cell, int radius);

  private:
    char** data_;
    float resolution_;

    int map_width_;
    int map_height_;
    int layer_width_;
    int layer_height_;
  };
}

#endif // GRID_MAP_LAYER_H_
