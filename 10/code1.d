import std.stdio;
import std.conv;

import std.range;
import std.string;
import std.algorithm;
import std.string;
import std.file;
import std.array;


bool inside(Range)(Range r, size_t i, size_t j)
{
  if(i >= 0 && i < r.length)
  {
    auto row = r[i];
    if (j >= 0 && j < row.length)
      return true;
  }
  return false;
}

void main()
{
  string[][] code = File("input01.txt").byLine.map!(a => a.to!string.strip.split("")).array;
  int[][] result = code.map!(a => a.map!(b => 0).array).array;
  writeln(code);
}
