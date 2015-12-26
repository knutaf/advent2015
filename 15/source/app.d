import std.stdio;
import std.regex;
import std.string;
import std.format;
import std.conv;
import std.algorithm;

struct Property
{
    string name;
    int value;
}

struct Ingredient
{
    string name;
    Property[] props;
    int calories;

    const pure string toString()
    {
        return format("%s: %s, calories: %s", name, props, calories);
    }
}

void main()
{
    Ingredient[] ingredients;

    auto rxLine = ctRegex!`^(\w+): capacity (-?\d+), durability (-?\d+), flavor (-?\d+), texture (-?\d+), calories (-?\d+)$`;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLine);
        if (cap)
        {
            Ingredient ing;
            ing.name = cap[1];
            ing.props ~= Property("capacity", to!int(cap[2]));
            ing.props ~= Property("durability", to!int(cap[3]));
            ing.props ~= Property("flavor", to!int(cap[4]));
            ing.props ~= Property("texture", to!int(cap[5]));
            ing.calories = to!int(cap[6]);

            ingredients ~= ing;
        }
        else
        {
            throw new Exception(format("unmatched line! %s", line));
        }
    }

    foreach (const ref Ingredient ing; ingredients)
    {
        writefln("ing: %s", ing);
    }

    uint[] amounts;
    amounts.length = ingredients.length;
    foreach (ref uint amount; amounts)
    {
        amount = 0;
    }

    uint[] maxAmounts;
    int maxScore = -int.max;

    immutable uint maxTotal = 100;
    immutable uint targetCalorieScore = 500;

    while (amounts[0] <= maxTotal)
    {
        amounts[amounts.length - 1]++;
        for (ulong i = amounts.length - 1; i > 0; i--)
        {
            if (amounts[i] > maxTotal)
            {
                amounts[i] = 0;
                amounts[i-1]++;
            }
        }

        int score = 1;
        if (sum(amounts) == maxTotal)
        {
            int caloriesScore = 0;
            foreach (ulong j; 0 .. amounts.length)
            {
                caloriesScore += cast(int)amounts[j] * ingredients[j].calories;
            }

            if (caloriesScore == targetCalorieScore)
            {
                for (uint i = 0; score != 0 && i < ingredients[0].props.length; i++)
                {
                    int propScore = 0;

                    for (uint j = 0; score != 0 && j < amounts.length; j++)
                    {
                        propScore += cast(int)amounts[j] * ingredients[j].props[i].value;
                    }

                    if (propScore < 0)
                    {
                        propScore = 0;
                    }

                    score *= propScore;
                }
            }
        }

        if (score > maxScore)
        {
            maxScore = score;
            maxAmounts = amounts.dup;

            writefln("new max score %s: %s", maxScore, maxAmounts);
        }
    }
}
