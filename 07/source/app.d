import std.stdio;
import std.regex;
import std.conv;
import std.format;
import std.string;
import std.algorithm;

enum Operator
{
    LITERAL,
    PASSTHROUGH,
    NOT,
    AND,
    OR,
    LSHIFT,
    RSHIFT,
}

struct WireConnection
{
    Operator op;

    bool value1Available;
    string input1;
    uint value1;

    bool value2Available;
    string input2;
    uint value2;
}

uint getWireValue(in WireConnection w)
{
    uint value = 0xffffffff;

    final switch (w.op)
    {
    case Operator.LITERAL:
        assert(w.value1Available);
        value = (w.value1) & 0xffff;
        break;

    case Operator.PASSTHROUGH:
        if (w.value1Available)
        {
            value = (w.value1) & 0xffff;
        }
        break;

    case Operator.NOT:
        if (w.value1Available)
        {
            value = (~w.value1) & 0xffff;
        }
        break;

    case Operator.AND:
        if (w.value1Available && w.value2Available)
        {
            value = (w.value1 & w.value2) & 0xffff;
        }
        break;

    case Operator.OR:
        if (w.value1Available && w.value2Available)
        {
            value = (w.value1 | w.value2) & 0xffff;
        }
        break;

    case Operator.LSHIFT:
        if (w.value1Available && w.value2Available)
        {
            value = (w.value1 << w.value2) & 0xffff;
        }
        break;

    case Operator.RSHIFT:
        if (w.value1Available && w.value2Available)
        {
            value = (w.value1 >> w.value2) & 0xffff;
        }
        break;
    }

    return value;
}

void main()
{
    auto rxLiteral = ctRegex!("^(\\d+)\\s*->\\s*([a-z]+)$");
    auto rxPassthrough = ctRegex!("^([a-z]+)\\s*->\\s*([a-z]+)$");
    auto rxNotOperator = ctRegex!("^NOT\\s*([a-z]+)\\s*->\\s*([a-z]+)$");
    auto rxAndOrLiteral = ctRegex!("^(\\d+)\\s*((?:AND)|(?:OR))\\s*([a-z]+)\\s*->\\s*([a-z]+)$");
    auto rxAndOr = ctRegex!("^([a-z]+)\\s*((?:AND)|(?:OR))\\s*([a-z]+)\\s*->\\s*([a-z]+)$");
    auto rxShift = ctRegex!("^([a-z]+)\\s*(L|R)SHIFT\\s*(\\d+)\\s*->\\s*([a-z]+)$");

    WireConnection[string] wires;

    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLiteral);

        if (cap)
        {
            WireConnection w;
            w.op = Operator.LITERAL;
            w.value1Available = true;
            w.value1 = to!uint(cap[1]);
            w.value2Available = false;

            wires[cap[2]] = w;
        }
        else
        {
            cap = matchFirst(line, rxPassthrough);
            if (cap)
            {
                WireConnection w;
                w.op = Operator.PASSTHROUGH;
                w.value1Available = false;
                w.input1 = cap[1];
                w.value2Available = false;

                wires[cap[2]] = w;
            }
            else
            {
                cap = matchFirst(line, rxNotOperator);
                if (cap)
                {
                    WireConnection w;
                    w.op = Operator.NOT;
                    w.value1Available = false;
                    w.input1 = cap[1];
                    w.value2Available = false;

                    wires[cap[2]] = w;
                }
                else
                {
                    cap = matchFirst(line, rxAndOrLiteral);
                    if (cap)
                    {
                        WireConnection w;
                        switch (cap[2])
                        {
                        case "AND":
                            w.op = Operator.AND;
                            break;

                        case "OR":
                            w.op = Operator.OR;
                            break;
                        default:
                            throw new Exception(format("unknown operator %s", cap[2]));
                        }

                        w.value1Available = true;
                        w.value1 = to!uint(cap[1]);

                        w.value2Available = false;
                        w.input2 = cap[3];

                        wires[cap[4]] = w;
                    }
                    else
                    {
                        cap = matchFirst(line, rxAndOr);
                        if (cap)
                        {
                            WireConnection w;
                            switch (cap[2])
                            {
                            case "AND":
                                w.op = Operator.AND;
                                break;

                            case "OR":
                                w.op = Operator.OR;
                                break;
                            default:
                                throw new Exception(format("unknown operator %s", cap[2]));
                            }

                            w.value1Available = false;
                            w.input1 = cap[1];

                            w.value2Available = false;
                            w.input2 = cap[3];

                            wires[cap[4]] = w;
                        }
                        else
                        {
                            cap = matchFirst(line, rxShift);
                            if (cap)
                            {
                                WireConnection w;
                                switch (cap[2])
                                {
                                case "L":
                                    w.op = Operator.LSHIFT;
                                    break;

                                case "R":
                                    w.op = Operator.RSHIFT;
                                    break;
                                default:
                                    throw new Exception(format("unknown shift operator %s", cap[2]));
                                }

                                w.value1Available = false;
                                w.input1 = cap[1];

                                w.value2Available = true;
                                w.value2 = to!uint(cap[3]);

                                wires[cap[4]] = w;
                            }
                            else
                            {
                                writefln("unmatched line! %s", line);
                            }
                        }
                    }
                }
            }
        }
    }

    foreach (const string wireName; wires.keys.sort())
    {
        const WireConnection* w = &wires[wireName];

        final switch (w.op)
        {
        case Operator.LITERAL:
            writefln("%s -> %s", w.value1, wireName);
            break;

        case Operator.PASSTHROUGH:
            writefln("%s -> %s", w.input1, wireName);
            break;

        case Operator.NOT:
            writefln("NOT %s -> %s", w.input1, wireName);
            break;
        case Operator.AND:
        case Operator.OR:
            writefln("%s %s %s -> %s",
                w.value1Available ? to!string(w.value1) : w.input1,
                w.op,
                w.value2Available ? to!string(w.value2) : w.input2,
                wireName);
            break;
        case Operator.LSHIFT:
        case Operator.RSHIFT:
            writefln("%s %s %s -> %s",
                w.input1,
                w.op,
                w.value2,
                wireName);
            break;
        }
    }

    bool madeProgress = true;
    while (madeProgress)
    {
        madeProgress = false;
        foreach (const string wireName, ref WireConnection w; wires)
        {
            //writefln("checking wire %s", wireName);

            bool needValue1 = false;
            bool needValue2 = false;

            final switch (w.op)
            {
            case Operator.LITERAL:
                needValue1 = true;
                assert(w.value1Available);
                assert(!w.value2Available);
                break;

            case Operator.PASSTHROUGH:
                needValue1 = true;
                assert(!w.value2Available);
                break;

            case Operator.NOT:
                needValue1 = true;
                assert(!w.value2Available);
                break;

            case Operator.AND:
            case Operator.OR:
            case Operator.LSHIFT:
            case Operator.RSHIFT:
                needValue1 = true;
                needValue2 = true;
                break;
            }

            if (needValue1 && !w.value1Available)
            {
                uint inputValue = getWireValue(wires[w.input1]);
                if (inputValue != 0xffffffff)
                {
                    w.value1Available = true;
                    w.value1 = inputValue;
                    madeProgress = true;
                    writefln("made progress with value1 of %s", wireName);
                    assert(wires[wireName].value1Available);
                }
            }

            if (needValue2 && !w.value2Available)
            {
                uint inputValue = getWireValue(wires[w.input2]);
                if (inputValue != 0xffffffff)
                {
                    w.value2Available = true;
                    w.value2 = inputValue;
                    madeProgress = true;
                    writefln("made progress with value2 of %s", wireName);
                    assert(wires[wireName].value1Available);
                }
            }
        }
    }

    foreach (const string wireName; wires.keys.sort())
    {
        const WireConnection* w = &wires[wireName];
        uint value = getWireValue(*w);
        writefln("%s: %d (%04X)", wireName, value, value);
    }

    uint valueA = getWireValue(wires["a"]);
    writefln("a: %d (%04X)", valueA, valueA);
}
