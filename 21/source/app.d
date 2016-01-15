import std.stdio;
import std.conv;
import std.string;
import std.regex;
import std.algorithm;
import std.array;

struct Item
{
    uint cost;
    uint damage;
    uint armor;
}

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
    uint bossDamageStat = 0;
    uint bossArmorStat = 0;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        trySetUintFromRx(line, rxHitPoints, bossHitPoints);
        trySetUintFromRx(line, rxDamage, bossDamageStat);
        trySetUintFromRx(line, rxArmor, bossArmorStat);
    }

    writefln("boss hp: %s, damage: %s, armor %s", bossHitPoints, bossDamageStat, bossArmorStat);

    if (bossHitPoints == 0 ||
        bossDamageStat == 0 ||
        bossArmorStat == 0)
    {
        throw new Exception("missing required boss params!");
    }

    Item[string] weapons;
    weapons["Dagger"] = Item(8, 4, 0);
    weapons["Shortsword"] = Item(10, 5, 0);
    weapons["Warhammer"] = Item(25, 6, 0);
    weapons["Longsword"] = Item(40, 7, 0);
    weapons["Greataxe"] = Item(74, 8, 0);

    Item[string] armor;
    armor["None"] = Item(0, 0, 0);
    armor["Leather"] = Item(13, 0, 1);
    armor["Chainmail"] = Item(31, 0, 2);
    armor["Splintmail"] = Item(53, 0, 3);
    armor["Bandedmail"] = Item(75, 0, 4);
    armor["Platemail"] = Item(102, 0, 5);

    Item[string] rings;
    rings["None"] = Item(0, 0, 0);
    rings["Damage_1"] = Item(25, 1, 0);
    rings["Damage_2"] = Item(50, 2, 0);
    rings["Damage_3"] = Item(100, 3, 0);
    rings["Defense_1"] = Item(20, 0, 1);
    rings["Defense_2"] = Item(40, 0, 2);
    rings["Defense_3"] = Item(80, 0, 3);

    uint playerHp = 100;

    string[] weaponNames = weapons.keys.sort!((string a, string b) { return weapons[a].cost < weapons[b].cost;})().array();
    string[] armorNames = armor.keys.sort!((string a, string b) { return armor[a].cost < armor[b].cost;})().array();
    string[] ringNames = rings.keys.sort!((string a, string b) { return rings[a].cost < rings[b].cost;})().array();

    writefln("weapons: %s", weaponNames);
    writefln("armor: %s", armorNames);
    writefln("rings: %s", ringNames);

    uint getCost(in Item*[] items ...)
    {
        return items.map!(a => a !is null ? a.cost : 0).sum();
    }

    bool simulate(in Item*[] items ...)
    {
        uint playerDamage = items.map!(a => a !is null ? a.damage : 0).sum();
        uint playerArmor = items.map!(a => a !is null ? a.armor : 0).sum();

        uint bossDamage;
        if (playerDamage <= bossArmorStat)
        {
            playerDamage = 1;
        }
        else
        {
            playerDamage -= bossArmorStat;
        }

        if (bossDamageStat <= playerArmor)
        {
            bossDamage = 1;
        }
        else
        {
            bossDamage = bossDamageStat - playerArmor;
        }

        float roundsToKillBoss = cast(float)bossHitPoints / playerDamage;
        float roundsToKillPlayer = cast(float)playerHp / bossDamage;

        writefln("player: %s/%s/%s. boss: %s/%s/%s. %.1f vs %.1f", playerHp, playerDamage, playerArmor, bossHitPoints, bossDamage, bossArmorStat, roundsToKillBoss, roundsToKillPlayer);

        return (roundsToKillBoss <= roundsToKillPlayer);
    }

    /*
    uint outfitItems(in Item* weapon, in Item* armor, in Item* ring1, in Item* ring2)
    {
        uint cost = getCost(weapon, armor, ring1, ring2);
        bool outcome = simulate(weapon, armor, ring1, ring2);

        if (outcome)
        {
            return outcome;
        }
        else
        {
            if (weapon !is null)
            {
                foreach (const ref Item weap; weapons)
                {
                    outfitItems(&weap, armor, ring1, ring2);
                }
            }
            else
            {
                if (simulate(weapon, armor, ring1, ring2))
                {
                }
            }
        }
    }
    */

    writeln(simulate(&weapons["Greataxe"], null, null, null));
}
