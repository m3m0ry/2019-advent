import std.stdio;
import std.conv;
import std.regex;
import std.typecons;
import std.string;
import std.format;
import std.algorithm;
import std.exception;
import std.array;
import std.math;

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

Reaction findReaction(string target, Reaction[] reactions)
{
  foreach(reaction; reactions)
  {
    if (reaction.output[0] == target)
    {
      return reaction;
    }
  }
  throw new Exception("No such reaction");
}

Chemical build(Chemical target, Chemical source, Reaction[] reactions)
{
  Chemical[] want = [target];
  Chemical[] newWant;
  int[string] rest;
  while(!want.all!(a => a[0] == "ORE"))
  {
    writeln(want);
    foreach(w; want)
    {
      if(w[0] == source[0])
      {
        newWant ~= w;
      }
      else
      {
        Reaction targetRule = findReaction(w[0], reactions);
        //get rest if any
        int todo;
        //TODO rest thing doesnt seem to work
        if(w[0] in rest && rest[w[0]] > 0)
        {
          todo = w[1] - rest[w[0]];
          if(todo < 0)
          {
            todo = 0;
            rest[w[0]] -= w[1];
          }
        }
        else
          todo = w[1];
        int reacts = ceil(todo.to!real / targetRule.output[1].to!real).to!int;
        int remainder = targetRule.output[1] - reacts;
        rest[w[0]] += remainder;
        foreach(chem; targetRule.input)
        {
          chem[1] *= reacts;
          newWant ~= chem; 
        }
      }
    }
    want = newWant;
    newWant.length = 0;
  }
  writeln(want);
  return source;
}

void main()
{
  auto f = File("input02.txt");
  Reaction[] reactions;
  foreach(line; f.byLine)
  {
    reactions ~= Reaction(line.to!string.split(" => ")[1].chemical,
                          line.to!string.split(" => ")[0].split(", ").map!( a => chemical(a)).array);
  }
  //reactions.each!(a => a.writeln);
  build(Chemical("FUEL", 1), Chemical("ORE", 0), reactions);
}
