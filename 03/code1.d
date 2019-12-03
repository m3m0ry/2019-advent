import std.stdio;
import std.range;
import std.string;
import std.conv;


void main()
{
  auto f = File("input01.txt");
  string[] line1;
  string[] line2;
  auto lines = f.byLine;

  line1 = lines.front.to!string.strip.split(",");
  line2 = lines.front.to!string.strip.split(",");

  writeln(line1);
  writeln(line2);
}
