/*
 * Xpider APP software, running on both ios and android
 * Copyright (C) 2015-2017  Roboeve, MakerCollider
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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
