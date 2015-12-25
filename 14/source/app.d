import std.stdio;
import std.format;
import std.string;
import std.regex;
import std.conv;

struct Reindeer
{
    string name;
    uint speed;
    uint flyTime;
    uint rest;

    public const pure string toString()
    {
        return format("%s can fly %s km/s for %s, but then must rest for %s seconds.", name, speed, flyTime, rest);
    }
}

void main()
{
    Reindeer[] deer;

    auto rxLine = ctRegex!`^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds\.$`;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLine);
        if (cap)
        {
            Reindeer r;
            r.name = cap[1];
            r.speed = to!uint(cap[2]);
            r.flyTime = to!uint(cap[3]);
            r.rest = to!uint(cap[4]);
            deer ~= r;
        }
        else
        {
            throw new Exception(format("unmatched line! %s", line));
        }
    }

    foreach (const ref reindeer; deer)
    {
        writefln("deer: %s", reindeer.toString());
    }
}
