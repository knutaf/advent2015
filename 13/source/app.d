import std.stdio;
import std.regex;
import std.conv;
import std.format;
import std.string;
import std.algorithm;

void main()
{
    auto rxLine = ctRegex!(`^(\w+) would ((?:gain)|(?:lose)) (\d+) happiness units by sitting next to (\w+).$`);

    int[string][string] relationships;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLine);
        if (cap)
        {
            int happiness = to!int(cap[3]);
            if (cap[2] == "lose")
            {
                happiness *= -1;
            }

            relationships[cap[1]][cap[4]] = happiness;

            writefln("%s, sitting next to %s: %s", cap[1], cap[4], relationships[cap[1]][cap[4]]);
        }
        else
        {
            throw new Exception(format("unmatched line! %s", line));
        }
    }

    relationships["Me"] = null;
    foreach (ref string sitter; relationships.keys())
    {
        relationships["Me"][sitter] = 0;
        relationships[sitter]["Me"] = 0;
    }

    string[] people = relationships.keys();

    bool getHappiness(in uint[] arrangement, out int happiness)
    {
        bool validArrangement = true;
        for (uint i = 0; validArrangement && i < arrangement.length - 1; i++)
        {
            for (uint j = i + 1; validArrangement && j < arrangement.length; j++)
            {
                if (arrangement[i] == arrangement[j])
                {
                    validArrangement = false;
                }
            }
        }

        if (validArrangement)
        {
            //writefln("summing arrangement %s", arrangement.map!(a => people[a])());
            happiness = 0;
            for (uint i = 0; i < arrangement.length; i++)
            {
                //writefln("adding happiness between %s and %s = %s", people[arrangement[i]], people[arrangement[(i+1) % arrangement.length]], relationships[people[arrangement[i]]][people[arrangement[(i+1) % arrangement.length]]]);
                happiness += relationships[people[arrangement[i]]][people[arrangement[(i+1) % arrangement.length]]];

                //writefln("adding happiness between %s and %s = %s", people[arrangement[(i+1) % arrangement.length]], people[arrangement[i]], relationships[people[arrangement[(i+1) % arrangement.length]]][people[arrangement[i]]]);
                happiness += relationships[people[arrangement[(i+1) % arrangement.length]]][people[arrangement[i]]];
            }
        }

        return validArrangement;
    }

    int maxHappiness = -int.max;
    uint[] maxArrangement;

    uint[] arrangement;
    arrangement.length = people.length;
    for (uint i = 0; i < arrangement.length; i++)
    {
        arrangement[i] = i;
    }

    while (arrangement[0] < arrangement.length)
    {
        int happiness;
        if (getHappiness(arrangement, happiness))
        {
            //writefln("arrangement: %s = %s", arrangement, dist);
            /*
            if (dist < minDist)
            {
                minDist = dist;
                minTraversal = arrangement.dup();

                writefln("found new min dist %s: %s", minDist, minTraversal.map!(a => people[a])());
            }
            */

            if (happiness > maxHappiness)
            {
                maxHappiness = happiness;
                maxArrangement = arrangement.dup();

                writefln("found new max arrangement %s: %s", maxHappiness, maxArrangement.map!(a => people[a])());
            }
        }

        arrangement[arrangement.length - 1]++;
        for (ulong i = arrangement.length - 1; i > 0; i--)
        {
            if (arrangement[i] > arrangement.length - 1)
            {
                arrangement[i] = 0;
                arrangement[i-1]++;
            }
        }
    }
}
