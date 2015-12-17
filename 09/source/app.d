import std.stdio;
import std.conv;
import std.regex;
import std.format;
import std.string;
import std.algorithm;

void main()
{
    auto rxLine = ctRegex!(`^(\w+) to (\w+) = (\d+)$`);

    uint[string][string] paths;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLine);
        if (cap)
        {
            uint dist = to!uint(cap[3]);

            paths[cap[1]][cap[2]] = dist;
            paths[cap[2]][cap[1]] = dist;

            writefln("adding path: %s -> %s = %s", cap[1], cap[2], paths[cap[1]][cap[2]]);
            writefln("adding path: %s -> %s = %s", cap[2], cap[1], paths[cap[2]][cap[1]]);
        }
        else
        {
            throw new Exception(format("unmatched line! %s", line));
        }
    }

    string[] stops = paths.keys();

    uint getTraversalDistance(in uint[] traversal)
    {
        uint dist = 0xffffffff;
        bool validTraversal = true;
        for (uint i = 0; validTraversal && i < traversal.length - 1; i++)
        {
            for (uint j = i + 1; validTraversal && j < traversal.length; j++)
            {
                if (traversal[i] == traversal[j])
                {
                    validTraversal = false;
                }
            }
        }

        if (validTraversal)
        {
            dist = 0;
            for (uint i = 0; i < traversal.length - 1; i++)
            {
                //writefln("adding dist from %s to %s = %s", stops[traversal[i]], stops[traversal[i+1]], paths[stops[traversal[i]]][stops[traversal[i+1]]]);
                dist += paths[stops[traversal[i]]][stops[traversal[i+1]]];
            }
        }

        return dist;
    }

    uint minDist = 0xffffffff;
    uint[] minTraversal;

    uint maxDist = 0;
    uint[] maxTraversal;

    uint[] traversal;
    traversal.length = stops.length;
    for (uint i = 0; i < traversal.length; i++)
    {
        traversal[i] = i;
    }

    while (traversal[0] < traversal.length)
    {
        uint dist = getTraversalDistance(traversal);
        if (dist != 0xffffffff)
        {
            //writefln("traversal: %s = %s", traversal, dist);
            if (dist < minDist)
            {
                minDist = dist;
                minTraversal = traversal.dup();

                writefln("found new min dist %s: %s", minDist, minTraversal.map!(a => stops[a])());
            }

            if (dist > maxDist)
            {
                maxDist = dist;
                maxTraversal = traversal.dup();

                writefln("found new max dist %s: %s", maxDist, maxTraversal.map!(a => stops[a])());
            }
        }

        traversal[traversal.length - 1]++;
        for (ulong i = traversal.length - 1; i > 0; i--)
        {
            if (traversal[i] > traversal.length - 1)
            {
                traversal[i] = 0;
                traversal[i-1]++;
            }
        }
    }
}
