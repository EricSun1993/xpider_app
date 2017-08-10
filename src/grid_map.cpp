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

#include "grid_map.h"

namespace GMap {
  GridMap::GridMap(uint16_t width, uint16_t height) {
    width_ = width;
    height_ = height;
  }

  Point GridMap::GetCenter() {
    Point temp;
    temp.x = width_ / 2;
    temp.y = height_ / 2;

    return temp;
  }

  bool GridMap::AddLayer(const char* layer_name, float resolution) {

    if(data_.count(layer_name) == 0) {
      data_.insert( std::make_pair(layer_name, new GridMapLayer(width_, height_, resolution)));
    } else {
      return false;
    }

    return true;
  }

  GridMapLayer& GridMap::operator [](const char *layer_name) {
    return *data_[layer_name];
  }
}
