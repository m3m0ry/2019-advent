import std.stdio;
import std.conv;
import std.format;
import std.algorithm;
import std.array;
import std.range;
import std.math : abs, sgn;
import std.format;
import std.numeric;

int lcm(int a, int b)
{
  return abs((a*b)/gcd(a,b));
}

struct Moon
{
  int[3] pos;
  int[3] vel;
  int[3] periods;

  bool allPeriods()
  {
    return all!"a != 0"(periods.dup);
  }

  bool isPeriod(Moon o, int i)
  {
    return o.pos[i] == pos[i] && vel[i] == o.vel[i];
  }

  int potential()
  {
    return pos.fold!((a, b) => abs(a) + abs(b));
  }

  int kinetic()
  {
    return vel.fold!((a, b) => abs(a) + abs(b));
  }

  int total()
  {
    return potential * kinetic;
  }

  void applyVelocity()
  {
    pos[] += vel[];
  }

  void gravity(Moon o)
  {
    foreach (i; 0 .. pos.length)
    {
      vel[i] -= o.pos[i] < pos[i];
      vel[i] += o.pos[i] > pos[i];
    }
  }

  string toString()
  {
    return format!"pos=<x=%d, y=%d, z=%d>, vel=<x=%d, y=%d, z=%d>"(pos[0],
        pos[1], pos[2], vel[0], vel[1], vel[2]);
  }
}

void main()
{
  auto f = File("input01.txt");
  Moon[] moons;
  foreach (line; f.byLine)
  {
    int x, y, z;
    line.formattedRead!"<x=%d, y=%d, z=%d>"(x, y, z);
    moons ~= Moon([x, y, z]);
  }

  Moon[] init = moons.dup;
  int step = 0;
  while(true)
  {
    step++;
    foreach (ref moon; moons)
    {
      foreach (o; moons)
      {
        moon.gravity(o);
      }
    }
    foreach (i, ref moon; moons)
    {
      moon.applyVelocity;
      foreach(j; 0..3)
      {
        if(!moon.periods[j] && moon.isPeriod(init[i], j.to!int))
        {
          moon.periods[j] = step;
        }
      }
    }
    if (all!(a => a.allPeriods)(moons))
    {
      break;
    }
  }
  int[] moonPerios;
  foreach (moon; moons)
  {
    writeln(moon.periods);
    moonPerios ~= moon.periods.fold!((a,b) => lcm(a,b));
  }
  writeln(moonPerios);
  writeln(moonPerios.fold!((a,b) => lcm(a,b)));
}