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
