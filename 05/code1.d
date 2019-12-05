import std.stdio;
import std.file : readText;
import std.conv;
import std.range;
import std.algorithm;
import std.string;
import std.exception;


function(int)[int] ops;

struct Program
{
  int ip = 0;
  int[] program;


  ref int opIndex(size_t i, int mode)
  {
    if (mode == 0)
      return program[i];
    else if (mode == 1)
      return program[program[i]];
    throw new Exception("Invalid mode");
  }

  ref int opIndex(size_t i) { return program[i];}

  @property int opDollar(size_t dim : 0)() { return program.length;}
}

Program operation(string op)(Program p)
{
    p[p.ip+3, 1] = mixin(`p[p.ip+2, 1]` ~ op ~ `p[p.ip+1, 1]`);
    return p;
}

Program compute(Program program, int ipIncr = 0)
{
  program.ip += ipIncr;
  int instruction = program[program.ip];
  if (instruction == 1)
  {
    return compute(operation!"+"(program), 4);
  }
  else if (instruction == 2)
  {
    return compute(operation!"*"(program), 4);
  }
  else if (instruction == 99)
  {
    return program;
  }
  else
  {
    throw new Exception("Invalid instruction");
  }
}

void main()
{
  int[] code = readText("input02.txt").strip.split(",").map!(a => to!int(a)).array;
  //code = "1,0,0,0,99".strip.split(",").map!(a=>to!int(a)).array;
  auto program = Program(0, code);
  program = compute(program);

  writeln(program);
}
