import std.stdio;
import std.regex;
import std.algorithm;
import std.string;

struct Translation
{
    string left;
    string right;

    const pure string toString()
    {
        return format("%s => %s", left, right);
    }
}

void main()
{
    Translation[] translations = [];
    string medicine = null;

    auto rxTransition = ctRegex!`^(\w+) => (\w+)$`;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxTransition);
        if (cap)
        {
            Translation t;
            t.left = cap[1];
            t.right = cap[2];
            translations ~= t;
        }
        else if (line.length != 0)
        {
            assert(medicine is null);
            medicine = line;
        }
    }

    foreach (const ref Translation t; translations.sort!"a.left < b.left"())
    {
        writeln(t);
    }

    writeln(medicine);
}
