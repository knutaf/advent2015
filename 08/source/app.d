import std.stdio;
import std.format;
import std.string;

enum STATE
{
    START,
    NORMAL,
    BACKSLASH,
    HEX,
    HEX1,
    END,
}

void main()
{
    uint totalLength = 0;
    uint totalProcessedLength = 0;

    uint totalEncodedLength = 0;

    foreach (char[] l; stdin.byLine())
    {
        uint len = 0;
        uint processedLen = 0;

        len += l.length;

        if (l[0] != '"')
        {
            throw new Exception("didn't start with quote");
        }

        if (l[l.length-1] != '"')
        {
            throw new Exception("didn't end with quote");
        }

        uint i;
        for (i = 1; i < l.length-1; i++)
        {
            if (l[i] == '\\')
            {
                switch (l[i+1])
                {
                case '\\':
                case '"':
                    assert(i < l.length-2);
                    processedLen += 1;
                    i += 1;
                    break;

                case 'x':
                    assert(i < l.length-4);
                    processedLen += 1;
                    i += 3;
                    break;

                default:
                    throw new Exception(format("unknown escape sequence: [%s]", l[i+1]));
                }
            }
            else
            {
                processedLen += 1;
            }
        }

        assert(i == l.length-1);

        totalLength += len;
        totalProcessedLength += processedLen;

        // now for encoding
        uint encodedLength = 6; // opening and closing quotes and encoded quotes

        for (i = 1; i < l.length-1; i++)
        {
            switch (l[i])
            {
            case '\\':
                encodedLength += 2;
                break;

            case '"':
                encodedLength += 2;
                break;

            default:
                encodedLength++;
                break;
            }
        }

        totalEncodedLength += encodedLength;

        writefln("%s -> %s, %s, %s", l, len, processedLen, encodedLength);
    }

    writefln("total length: %s", totalLength);
    writefln("total processed length: %s", totalProcessedLength);
    assert(totalLength > totalProcessedLength);
    writefln("diff: %s", totalLength - totalProcessedLength);

    writefln("total encoded length: %s", totalEncodedLength);
    assert(totalEncodedLength > totalLength);
    writefln("diff: %s", totalEncodedLength - totalLength);
}
