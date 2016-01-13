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

    /*
    ulong rangeHigh = 0;
    foreach (ulong num; 1 .. (input / 2))
    {
        if (((num * (num + 1)) / 2) * presentMultiplier >= input)
        {
            rangeHigh = num;
            break;
        }
    }
    */

    ulong rangeLow = 1;
    ulong rangeHigh = input / 20;
    /*
    foreach (ulong attempt; 1 .. input)
    {
        for (ulong num = 1; num < input / presentMultiplier; num *= attempt)
        {
            ulong sumOfFactors = 0;
            for (ulong elfNum = 1; elfNum <= num; elfNum *= attempt)
            {
                sumOfFactors += elfNum * presentMultiplier;
                if (attempt == 1)
                {
                    elfNum++;
                }
            }

            writefln("sum for power of %s %s is %s", attempt, num, sumOfFactors);

            if (sumOfFactors <= input && num > rangeLow)
            {
                rangeLow = num;
            }

            if (attempt == 1)
            {
                num++;
            }
        }
    }
    */

    writefln("range: %s - %s", rangeLow, rangeHigh);

    TaskPool tp = new TaskPool();
    //ulong[] sums;
    //sums.length = input / 20;
    foreach (ulong houseNum; tp.parallel(takeExactly(sequence!("a[0] + n")(799000), input / 20), 1000))
    {
        //ulong[] elves = [];

        uint numFactors = 0;
        ulong sumOfFactors = 0;
        for (ulong elfNum = houseNum; (elfNum * visitLimit) >= houseNum && elfNum >= 1; elfNum--)
        {
            if ((houseNum % elfNum) == 0)
            {
                sumOfFactors += elfNum;
                numFactors++;
                //elves ~= elfNum;
            }
            else if ((((elfNum * (elfNum + 1)) / 2) + sumOfFactors) * presentMultiplier < input)
            {
                break;
            }
        }

        /*
        foreach (ulong elfNum; 1 .. houseNum+1)
        {
            if ((houseNum % elfNum) == 0)
            {
                sumOfFactors += elfNum;
                //elves ~= elfNum;
            }
        }
        */

        sumOfFactors *= presentMultiplier;

        //writefln("house %s got %s presents", houseNum, sumOfFactors);

        if (sumOfFactors >= input || (houseNum % 1000) == 0)
        {
            auto th = Thread.getThis();
            if (th.name == "")
            {
                th.name = format("%s", houseNum);
            }

            //writefln("house %s got %s presents (%s)", houseNum, sumOfFactors, elves);
            writefln("%s%s: house %s got %s presents (%s factors)", (sumOfFactors >= input ? "YAY " : ""), th.name, houseNum, sumOfFactors, numFactors);
            //break;
        }
    }
}
