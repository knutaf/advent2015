import std.stdio;
import std.regex;
import std.format;
import std.string;

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need input");
    }

    char[] input = args[1].dup();

    auto rxIOL = ctRegex!(`[iol]`);
    auto rxPair = ctRegex!(`([a-z])\1`);

    bool valid = false;
    while (!valid)
    {
        //writefln("trying %s", input);

        input[input.length - 1]++;
        for (ulong i = input.length - 1; i > 0; i--)
        {
            if (input[i] > 'z')
            {
                input[i] = 'a';
                input[i-1]++;
            }
        }

        bool hasIOL = !!matchFirst(input, rxIOL);

        bool hasSequence = false;
        foreach (ulong i; 0 .. input.length - 2)
        {
            if (input[i+1] == input[i] + 1 &&
                input[i+2] == input[i] + 2)
            {
                //writefln("matched %s %s %s", input[i], input[i+1], input[i+2]);
                hasSequence = true;
            }
        }

        bool hasPairs = false;
        Captures!(char[]) cap = matchFirst(input, rxPair);
        if (cap)
        {
            Regex!char rxOtherPair = regex(format("([^%s])\\1", cap[1]));
            if (matchFirst(input, rxOtherPair))
            {
                hasPairs = true;
            }
        }

        /*
        if (hasIOL)
        {
            writeln("failed - has IOL");
        }

        if (!hasSequence)
        {
            writeln("failed - no sequence");
        }

        if (!hasPairs)
        {
            writeln("failed - doesn't have pairs");
        }
        */

        valid = !hasIOL && hasSequence && hasPairs;
    }

    writefln("pw: %s", input);
}
