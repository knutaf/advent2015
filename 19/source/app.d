import std.stdio;
import std.regex;
import std.algorithm;
import std.string;
import std.array;

struct Rule
{
    string left;
    string right;

    const pure string toString()
    {
        return format("%s => %s", left, right);
    }
}

void main()
{
    Rule[] rules = [];
    string medicine = null;

    auto rxTransition = ctRegex!`^(\w+) => (\w+)$`;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxTransition);
        if (cap)
        {
            Rule r;
            r.left = cap[1];
            r.right = cap[2];
            rules ~= r;
        }
        else if (line.length != 0)
        {
            assert(medicine is null);
            medicine = line;
        }
    }

    rules = rules.sort!"a.right.length > b.right.length || (a.right.length == b.right.length && a.left < b.left)"().array();

    foreach (const ref Rule r; rules)
    {
        writeln(r);
    }

    writeln(medicine);
    writeln("");

    ulong maxLeft = 0;
    foreach (ulong l; rules.map!(a => a.left.length))
    {
        if (l > maxLeft)
        {
            maxLeft = l;
        }
    }

    ulong maxRight = 0;
    foreach (ulong r; rules.map!(a => a.right.length))
    {
        if (r > maxRight)
        {
            maxRight = r;
        }
    }

    void translate(string molecule, bool leftToRight, ref bool[string] outputs)
    {
        ulong maxInSize;

        if (leftToRight)
        {
            maxInSize = maxLeft;
        }
        else
        {
            maxInSize = maxRight;
        }

        for (ulong inSize = min(maxInSize, molecule.length); inSize >= 1; inSize--)
        {
            //writefln("insize %s", inSize);
            foreach (ulong i; 0 .. molecule.length - inSize + 1)
            {
                //writefln("i: %s", i);
                if (i + inSize <= molecule.length)
                {
                    string molInput = molecule[i .. i+inSize];
                    foreach (const ref Rule r; rules)
                    {
                        if (leftToRight)
                        {
                            if (r.left == molInput)
                            {
                                string translation = molecule[0 .. i] ~ r.right ~ molecule[i + inSize .. molecule.length];
                                outputs[translation] = true;

                                //writefln("translated with rule %s", r);
                            }
                        }
                        else
                        {
                            //writefln("comparing rule %s with input %s", r.right, molInput);
                            if (r.right == molInput)
                            {
                                if (molInput.length == molecule.length || r.left != "e")
                                {
                                    string translation = molecule[0 .. i] ~ r.left ~ molecule[i + inSize .. molecule.length];
                                    outputs[translation] = true;

                                    //writefln("translated at i=%s with rule %s to %s", i, r, translation);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ulong reduce2(string molecule, ulong ruleNum, ulong pos)
    {
        writefln("mol: %s, rule %s, pos %s", molecule, ruleNum, pos);
        //writefln("rule %s, pos %s", ruleNum, pos);

        if (molecule == "e")
        {
            return 0;
        }
        else if (!molecule.find("e").empty)
        {
            writefln("pruning with e");
            return ulong.max;
        }
        else if (ruleNum < rules.length)
        {
            const(Rule*) rule = &rules[ruleNum];
            if (pos < molecule.length - rule.right.length + 1)
            {
                string molInput = molecule[pos .. pos+rule.right.length];
                if (rule.right == molInput)
                {
                    writefln("matched");
                    molecule = molecule[0 .. pos] ~ rule.left ~ molecule[pos + rule.right.length .. molecule.length];

                    ulong steps = reduce2(molecule, 0, pos + 1);
                    //writefln("translated at pos=%s with rule %s", pos, rule);

                    if (steps == ulong.max)
                    {
                        steps = reduce2(molecule, ruleNum + 1, pos);
                        if (steps == ulong.max)
                        {
                            return steps;
                        }
                        else
                        {
                            return steps + 1;
                        }
                    }
                    else
                    {
                        return steps + 1;
                    }
                }
                else
                {
                    ulong steps = reduce2(molecule, ruleNum, pos + 1);
                    if (steps == ulong.max)
                    {
                        steps = reduce2(molecule, ruleNum + 1, pos);
                    }

                    return steps;
                }
            }
            else
            {
                ulong steps = reduce2(molecule, ruleNum + 1, 0);
                if (steps == ulong.max)
                {
                    steps = reduce2(molecule, ruleNum + 1, pos);
                }

                return steps;
            }
        }
        else
        {
            assert(ruleNum == rules.length);
            return ulong.max;
        }
    }

    ulong reduce(string molecule, ulong acc)
    {
        writefln("mol: %s, acc: %s", molecule, acc);

        if (molecule == "e")
        {
            return acc;
        }
        else if (!molecule.find("e").empty)
        {
            writefln("pruning with e");
            return ulong.max;
        }
        else
        {
            bool[string] nextTranslations;
            translate(molecule, false, nextTranslations);

            foreach (const ref string mol; nextTranslations.keys().sort!"a > b"())
            {
                ulong steps = reduce(mol, acc+1);
                if (steps != ulong.max)
                {
                    return steps;
                }
            }

            return ulong.max;
        }
    }

    {
        bool[string] translations;
        translate(medicine, true, translations);
        writefln("distinct molecules: %s", translations.length);
    }

    /*
    foreach (string t; translations.keys().sort())
    {
        writeln(t);
    }
    */

    /*
    {
        bool[string] translations;
        translations[medicine] = true;
        uint step = 1;
        do
        {
            if ((step % 1) == 0)
            {
                writefln("step %s: %s translations", step, translations.keys().length);
                //writeln(translations.keys());
            }

            bool[string] nextTranslations;
            foreach (const ref left; translations.keys())
            {
                translate(left, false, nextTranslations);
            }

            step++;
            translations = nextTranslations;
        } while (!("e" in translations));

        writefln("found medicine molecule after %s steps", step-1);
    }
    */

    /*
    {
        ulong steps = reduce2(medicine, 0, 0);
        writefln("found medicine molecule after %s steps", steps);
    }
    */

    {
        ulong steps = reduce(medicine, 0);
        writefln("found medicine molecule after %s steps", steps);
    }
}
