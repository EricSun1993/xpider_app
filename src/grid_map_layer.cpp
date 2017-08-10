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
