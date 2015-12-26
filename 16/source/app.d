import std.stdio;
import std.regex;
import std.string;
import std.conv;
import std.algorithm;

void main()
{
    uint[string] sueGift;
    sueGift["children"] = 3;
    sueGift["cats"] = 7;
    sueGift["samoyeds"] = 2;
    sueGift["pomeranians"] = 3;
    sueGift["akitas"] = 0;
    sueGift["vizslas"] = 0;
    sueGift["goldfish"] = 5;
    sueGift["trees"] = 5;
    sueGift["cars"] = 2;
    sueGift["perfumes"] = 1;

    uint[string][] sues = [];

    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        uint[string] sue;

        foreach (const ref string key; sueGift.keys())
        {
            Regex!char rxMatchKey = regex(format(`%s: (\d+)`, key));
            Captures!string capKey = matchFirst(line, rxMatchKey);
            if (capKey)
            {
                sue[key] = to!uint(capKey[1]);
            }
        }

        sue["dq"] = false;
        sues ~= sue;
    }

    foreach (ulong i; 0 .. sues.length)
    {
        writefln("sue %s: %s", i+1, sues[i].keys().filter!(a => sues[i][a] != uint.max).map!(a => format("%s: %s", a, sues[i][a])));
    }

    foreach (ref uint[string] sue; sues)
    {
        foreach (const ref string key; sue.keys())
        {
            if (key != "dq")
            {
                uint* value = key in sue;
                if (value !is null)
                {
                    switch (key)
                    {
                    case "cats":
                    case "trees":
                        if (*value <= sueGift[key])
                        {
                            sue["dq"] = true;
                        }
                        break;

                    case "pomeranians":
                    case "goldfish":
                        if (*value >= sueGift[key])
                        {
                            sue["dq"] = true;
                        }
                        break;

                    default:
                        if (*value != sueGift[key])
                        {
                            sue["dq"] = true;
                        }
                        break;
                    }
                }
            }
        }
    }

    foreach (ulong i; 0 .. sues.length)
    {
        if (!sues[i]["dq"])
        {
            writefln("sue %s could be it", i+1);
        }
    }
}
