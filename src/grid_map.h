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
