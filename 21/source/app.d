import std.stdio;
import std.conv;
import std.string;
import std.regex;

void trySetUintFromRx(R)(string str, R rx, ref uint output)
{
    Captures!string cap = matchFirst(str, rx);
    if (cap)
    {
        output = to!uint(cap[1]);
    }
}

void main()
{
    auto rxHitPoints = ctRegex!`^Hit Points: (\d+)$`;
    auto rxDamage = ctRegex!`^Damage: (\d+)$`;
    auto rxArmor = ctRegex!`^Armor: (\d+)$`;
    uint bossHitPoints = 0;
    uint bossDamage = 0;
    uint bossArmor = 0;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        trySetUintFromRx(line, rxHitPoints, bossHitPoints);
        trySetUintFromRx(line, rxDamage, bossDamage);
        trySetUintFromRx(line, rxArmor, bossArmor);
    }

    writefln("boss hp: %s, damage: %s, armor %s", bossHitPoints, bossDamage, bossArmor);

    if (bossHitPoints == 0 ||
        bossDamage == 0 ||
        bossArmor == 0)
    {
        throw new Exception("missing required boss params!");
    }
}
