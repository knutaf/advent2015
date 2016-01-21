import std.stdio;
import std.conv;
import std.string;

void main()
{
    uint[] weights;
    foreach (char[] l; stdin.byLine())
    {
        weights ~= to!uint(l);
    }

    writefln("weights: %s", weights);
}
