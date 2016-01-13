import std.stdio;
import std.conv;
import std.math;
import std.parallelism;
import core.thread;
import std.range;
import std.string;

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need puzzle input");
    }

    immutable uint input = to!uint(args[1]);
    immutable uint presentMultiplier = 11;
    immutable uint visitLimit = 50;

    writefln("input: %s", input);

    ulong[] houses;
    houses.length = input / presentMultiplier;

    foreach (ulong elfNum; 1 .. houses.length)
    {
        for (ulong houseNumber = elfNum; houseNumber < houses.length && elfNum * visitLimit >= houseNumber; houseNumber += elfNum)
        {
            houses[houseNumber] += presentMultiplier * elfNum;
        }
    }

    ulong minPresentsOverInput = ulong.max;
    ulong minHouseNum = houses.length;
    foreach (ulong houseNum, const ref ulong presents; houses)
    {
        if (presents >= input && houseNum < minHouseNum)
        {
            minPresentsOverInput = presents;
            minHouseNum = houseNum;
        }
    }

    writefln("min house: %s with %s presents", minHouseNum, minPresentsOverInput);
}
