import std.stdio;
import std.json;
import std.regex;
import std.conv;

void deleteAllMatchingProperty(ref JSONValue jv, string ignoreProperty)
{
    JSONValue jvNull = JSONValue(null);

    switch (jv.type)
    {
    case JSON_TYPE.ARRAY:
        foreach (ref JSONValue elem; jv.array())
        {
            deleteAllMatchingProperty(elem, ignoreProperty);
        }
        break;

    case JSON_TYPE.OBJECT:
        bool foundProperty = false;
        foreach (const ref string name; jv.object().keys())
        {
            JSONValue val = jv.object()[name];
            if (val.type == JSON_TYPE.STRING && val.str() == ignoreProperty)
            {
                foundProperty = true;
            }
        }

        foreach (const ref string name; jv.object().keys())
        {
            if (foundProperty)
            {
                jv.object()[name] = jvNull;
            }
            else
            {
                deleteAllMatchingProperty(jv.object()[name], ignoreProperty);
            }
        }
        break;

    default:
        break;
    }
}

int sumNumbersInString(string input)
{
    int total = 0;
    auto rxNumber = ctRegex!(`-?\d+`);
    auto matches = matchAll(input, rxNumber);
    foreach (Captures!string cap; matches)
    {
        total += to!int(cap[0]);
    }

    return total;
}

void main(string[] args)
{
    string input;
    foreach (char[] l; stdin.byLine())
    {
        input = l.idup();
        break;
    }

    writefln("total part 1: %s", sumNumbersInString(input));

    JSONValue doc = parseJSON(input);

    deleteAllMatchingProperty(doc, "red");
    string processed = toJSON(&doc, false);
    writefln("total part 2 after delete: %s", sumNumbersInString(processed));
}
