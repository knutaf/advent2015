import std.stdio;
import std.string;
import std.format;
import std.conv;
import std.array;

void main(string[] args)
{
    if (args.length < 3)
    {
        throw new Exception("need input and num iterations");
    }

    string input = args[1];
    uint iterations = to!uint(args[2]);

    immutable double conwayConstant = 1.30357726903429639125709911215255189073070250465940487575486139062855088785246155712681576686442522555;

    foreach (uint iter; 0 .. iterations)
    {
        Appender!string expanded = appender!string();
        //writefln("expanding %s", input);

        char currentChar = 0;
        uint runLength = 0;

        writefln("prediction length: %f", conwayConstant * input.length);

        foreach (ulong i; 0 .. input.length)
        {
            char c = input[i];
            //writefln("processing %s", c);

            if (currentChar == 0)
            {
                currentChar = c;
            }

            if (currentChar != c)
            {
                expanded.put(format("%d", runLength));
                expanded.put(currentChar);

                runLength = 1;
                currentChar = c;
            }
            else
            {
                runLength++;
            }
        }

        expanded.put(format("%d", runLength));
        expanded.put(currentChar);

        writefln("expanded len=%s", expanded.data.length);
        //writefln("expanded (len=%s): %s", expanded.data.length, expanded.data);

        input = expanded.data;
    }

    //writefln("expanded: %s", input);
}
