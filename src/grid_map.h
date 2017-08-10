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

#ifndef GRID_MAP_H_
#define GRID_MAP_H_

#include <map>

#include "grid_map_common.h"
#include "grid_map_layer.h"

namespace GMap {
  class GridMap {
  public:

    GridMap(uint16_t width, uint16_t height);

    int width() { return width_; }
    int height() { return height_; }
    int layer_number() { return data_.size(); }
    std::map<const char*, GridMapLayer*> data() { return data_; }

    Point GetCenter();

    bool AddLayer(const char* layer_name, float resolution);

    GridMapLayer& operator [](const char *layer_name);

  private:
    int width_;
    int height_;

    std::map<const char*, GridMapLayer*> data_;
  };
}

#endif // GRIDMAP_H_
