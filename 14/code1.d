import std.stdio;
import std.conv;
import std.regex;
import std.typecons;
import std.string;
import std.format;
import std.algorithm;
import std.array;

alias Chemical = Tuple!(string, int);
Chemical chemical(T)(T react)
{
  string s;
  int i;
  react.formattedRead!"%d %s"(i, s);
  return Chemical(s,i);
}

struct Reaction
{
  Chemical output;
  Chemical[] input;

}

void main()
{
  auto f = File("input01.txt");
  Reaction[] reactions;
  foreach(line; f.byLine)
  {
    reactions ~= Reaction(line.to!string.split(" => ")[1].chemical, line.to!string.split(" => ")[0].split(", ").map!( a => chemical(a)).array);
  }
  reactions.each!(a => a.writeln);
}
