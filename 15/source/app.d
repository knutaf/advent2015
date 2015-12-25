import std.stdio;
import std.regex;
import std.string;
import std.format;
import std.conv;

struct Ingredient
{
    string name;
    int capacity;
    int durability;
    int flavor;
    int texture;
    int calories;

    const pure string toString()
    {
        return format("%s: capacity %s, durability %s, flavor %s, texture %s, calories %s", name, capacity, durability, flavor, texture, calories);
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
            ing.capacity = to!int(cap[2]);
            ing.durability = to!int(cap[3]);
            ing.flavor = to!int(cap[4]);
            ing.texture = to!int(cap[5]);
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
}
