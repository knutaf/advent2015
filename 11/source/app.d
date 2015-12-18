import std.stdio;

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need input");
    }

    char[] input = args[1].dup();

    input[input.length - 1]++;
    for (ulong i = input.length - 1; i > 0; i--)
    {
        if (input[i] > 'z')
        {
            input[i] = 'a';
            input[i-1]++;
        }
    }

    writefln("pw: %s", input);
}
