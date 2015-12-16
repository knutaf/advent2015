import std.stdio;
import std.digest.md;
import std.format;
import std.string;

void main()
{
    immutable string secretKey = "yzbqklnj";
    //immutable string secretKey = "abcdef";
    //immutable string secretKey = "pqrstuv";

    uint num = 0;
    while (true)
    {
        string hashInput = format("%s%s", secretKey, num);
        ubyte[16] hash = md5Of(hashInput);
        //writefln("hash of %s is %s", hashInput, toHexString(hash));

        if (hash[0] == 0 &&
            hash[1] == 0 &&
            hash[2] == 0)
            //hash[2] < 0x10)
        {
            writefln("found it!");
            break;
        }
        else
        {
            num++;
        }
    }

    writefln("num = %s", num);
}
