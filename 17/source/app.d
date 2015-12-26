import std.stdio;
import std.conv;

void main()
{
    uint[] containers = [];

    foreach (char[] l; stdin.byLine())
    {
        containers ~= to!uint(l);
    }

    writefln("containers: %s", containers);
}
