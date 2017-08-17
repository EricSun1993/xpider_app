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

#include "grid_map_layer.h"

namespace GMap {
  GridMapLayer::GridMapLayer(int map_width, int map_height, float resolution) {
    resolution_ = resolution;
    map_width_ = map_width;
    map_height_ = map_height;
    layer_width_ = static_cast<int>(map_width_ / resolution_);
    layer_height_ = static_cast<int>(map_height_ / resolution_);

    data_ = new char*[map_width];
    for(int i=0; i<layer_width_; i++) {
      data_[i] = new char[layer_height_];
    }
  }

  char GridMapLayer::at(Point point) {
    Cell cell;

    cell = GetCell(point);

    return at(cell);
  }

  char GridMapLayer::at(Cell cell) {
    return data_[cell.x][cell.y];
  }

  bool GridMapLayer::set(Point point, char value) {
    Cell cell;

    cell = GetCell(point);

    return set(cell, value);
  }

  bool GridMapLayer::set(Cell cell, char value) {
    data_[cell.x][cell.y] = value;
    return true;
  }

  Cell GridMapLayer::GetCell(Point point) {
    Cell cell;

    cell.x = static_cast<int>(point.x / resolution_);
    cell.y = static_cast<int>(point.y / resolution_);

    return cell;
  }

  Point GridMapLayer::GetCellCenter(Cell cell) {
    Point point;

    point.x = cell.x * resolution_ + resolution_ / 2;
    point.y = cell.y * resolution_ + resolution_ / 2;

    return point;
  }

  bool GridMapLayer::CheckAreaEmpty(Cell cell, int radius) {
    Cell temp_cell;

    for(int i=cell.x-radius; i<= cell.x+radius; i++) {
      for(int j=cell.y-radius; j<=cell.y+radius; j++) {
        if(i<layer_width_ && i>0 && j<layer_height_ && j>0) {
          temp_cell.x = i;
          temp_cell.y = j;
          if(at(temp_cell) != 0) {
            return false;
          }
        }
      }
    }

    return true;
  }
}
