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


#ifndef GRID_MAP_COMMON_H_
#define GRID_MAP_COMMON_H_

namespace GMap {
  struct Point {
    float x;
    float y;
  };

  struct Cell {
    int x;
    int y;
  };
}

#endif // GRIDMAPCOMMON_H
