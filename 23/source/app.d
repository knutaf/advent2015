import std.stdio;
import std.regex;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

enum Opcode
{
    hlf,
    tpl,
    inc,
    jmp,
    jie,
    jio
}

struct Instruction
{
    Opcode opcode;
    string reg;
    int num;

    pure string toString()
    {
        final switch (opcode)
        {
        case Opcode.hlf:
        case Opcode.tpl:
        case Opcode.inc:
            return format("%s %s", opcode, reg);

        case Opcode.jmp:
            return format("jmp %s%s", num >= 0 ? "+" : "", num);

        case Opcode.jie:
        case Opcode.jio:
            return format("%s %s, %s%s", opcode, reg, num >= 0 ? "+" : "", num);
        }
    }
}

void main()
{
    auto rxSimple = ctRegex!`^(\w+) (\w+)$`;
    auto rxJmp = ctRegex!`^jmp \+?(-?\d+)$`;
    auto rxConditionalJump = ctRegex!`^((?:jie)|(?:jio)) (\w+),\s*\+?(-?\d+)$`;
    Instruction[] prog;

    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();

        Instruction inst;
        Captures!string cap = matchFirst(line, rxSimple);
        if (cap)
        {
            switch (cap[1])
            {
            case "hlf":
                inst.opcode = Opcode.hlf;
                break;

            case "tpl":
                inst.opcode = Opcode.tpl;
                break;

            case "inc":
                inst.opcode = Opcode.inc;
                break;

            default:
                throw new Exception(format("unknown opcode %s!", cap[1]));
            }

            inst.reg = cap[2];
        }
        else
        {
            cap = matchFirst(line, rxJmp);
            if (cap)
            {
                inst.opcode = Opcode.jmp;
                inst.num = to!int(cap[1]);
            }
            else
            {
                cap = matchFirst(line, rxConditionalJump);
                if (cap)
                {
                    switch (cap[1])
                    {
                    case "jio":
                        inst.opcode = Opcode.jio;
                        break;

                    case "jie":
                        inst.opcode = Opcode.jie;
                        break;

                    default:
                        throw new Exception(format("unknown opcode %s!", cap[1]));
                    }

                    inst.reg = cap[2];
                    inst.num = to!int(cap[3]);
                }
                else
                {
                    throw new Exception("unmatched line! " ~ line);
                }
            }
        }

        prog ~= inst;
    }

    writeln(prog.map!(a => a.toString()).join("\n"));

    uint[string] reg;
    reg["a"] = 1;
    reg["b"] = 0;

    int ip = 0;
    while (ip >= 0 && ip < prog.length)
    {
        int nextIP;
        const(Instruction*) inst = &prog[ip];
        final switch (inst.opcode)
        {
        case Opcode.hlf:
            reg[inst.reg] /= 2;
            nextIP = ip + 1;
            break;

        case Opcode.tpl:
            reg[inst.reg] *= 3;
            nextIP = ip + 1;
            break;

        case Opcode.inc:
            reg[inst.reg]++;
            nextIP = ip + 1;
            break;

        case Opcode.jmp:
            nextIP = ip + inst.num;
            break;

        case Opcode.jie:
            if ((reg[inst.reg] % 2) == 0)
            {
                nextIP = ip + inst.num;
            }
            else
            {
                nextIP = ip + 1;
            }
            break;

        case Opcode.jio:
            if (reg[inst.reg] == 1)
            {
                nextIP = ip + inst.num;
            }
            else
            {
                nextIP = ip + 1;
            }
            break;
        }

        ip = nextIP;
    }

    writefln("exited because ip is %s", ip);
    writeln(reg);
}
