import std.stdio;
import std.conv;
import std.algorithm;
import std.array;

struct Container
{
   uint size;
   uint on;
}

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need target size");
    }

    uint targetSize = to!uint(args[1]);

    Container[] containers;

    foreach (char[] l; stdin.byLine())
    {
        Container c;
        c.size = to!uint(l);
        c.on = 0;
        containers ~= c;
    }

    writefln("containers: %s", containers);

    uint numCombos = 0;
    ulong minContainers = ulong.max;
    uint numMinCombos = 0;

    immutable uint maxValue = 1;
    while (containers[0].on <= maxValue)
    {
        containers[containers.length - 1].on++;
        for (ulong i = containers.length - 1; i > 0; i--)
        {
            if (containers[i].on > maxValue)
            {
                containers[i].on = 0;
                containers[i-1].on++;
            }
        }

        uint volume = containers.map!(a => a.size * a.on).sum();
        //writefln("volume %s for %s", volume, containers);
        if (volume == targetSize)
        {
            writefln("combo %s", containers.filter!(a => a.on == 1).map!(a => a.size));
            numCombos++;

            ulong numContainersUsed = containers.filter!(a => a.on == 1).array().length;
            if (numContainersUsed < minContainers)
            {
                minContainers = numContainersUsed;
                numMinCombos = 1;
                writefln("new min containers: %s", minContainers);
            }
            else if (numContainersUsed == minContainers)
            {
                numMinCombos++;
                writefln("meets min conainers", minContainers);
            }
        }
    }

    writefln("%s combos work", numCombos);
    writefln("%s using min %s", numMinCombos, minContainers);
}
