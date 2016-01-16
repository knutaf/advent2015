import std.stdio;
import std.conv;
import std.string;
import std.regex;
import std.algorithm;
import std.array;
import std.math;

struct Item
{
    string name;
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

    Item[] weapons;
    weapons ~= Item("Dagger", 8, 4, 0);
    weapons ~= Item("Shortsword", 10, 5, 0);
    weapons ~= Item("Warhammer", 25, 6, 0);
    weapons ~= Item("Longsword", 40, 7, 0);
    weapons ~= Item("Greataxe", 74, 8, 0);

    Item[] armors;
    armors ~= Item("None", 0, 0, 0);
    armors ~= Item("Leather", 13, 0, 1);
    armors ~= Item("Chainmail", 31, 0, 2);
    armors ~= Item("Splintmail", 53, 0, 3);
    armors ~= Item("Bandedmail", 75, 0, 4);
    armors ~= Item("Platemail", 102, 0, 5);

    Item[] rings;
    rings ~= Item("None_1", 0, 0, 0);
    rings ~= Item("None_2", 0, 0, 0);
    rings ~= Item("Damage_1", 25, 1, 0);
    rings ~= Item("Damage_2", 50, 2, 0);
    rings ~= Item("Damage_3", 100, 3, 0);
    rings ~= Item("Defense_1", 20, 0, 1);
    rings ~= Item("Defense_2", 40, 0, 2);
    rings ~= Item("Defense_3", 80, 0, 3);

    uint playerHp = 100;

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
            assert(playerDamage >= 1);
        }

        if (bossDamageStat <= playerArmor)
        {
            bossDamage = 1;
        }
        else
        {
            bossDamage = bossDamageStat - playerArmor;
            assert(bossDamage >= 1);
        }

        float roundsToKillBoss = cast(float)bossHitPoints / playerDamage;
        float roundsToKillPlayer = cast(float)playerHp / bossDamage;

        writefln("%s: %s/%s/%s. boss: %s/%s/%s. %.1f vs %.1f -> %s [%s]",
            getCost(items),
            playerHp,
            playerDamage,
            playerArmor,
            bossHitPoints,
            bossDamage,
            bossArmorStat,
            roundsToKillBoss,
            roundsToKillPlayer,
            (ceil(roundsToKillBoss) <= ceil(roundsToKillPlayer)) ? "win" : "lose",
            items.map!(a => a.name).join(", "));

        return (ceil(roundsToKillBoss) <= ceil(roundsToKillPlayer));
    }

    uint outfitToWin(in Item* weapon, in Item* armor, in Item* ring1, in Item* ring2)
    {
        uint cost = uint.max;

        if (weapon !is null)
        {
            if (armor !is null)
            {
                if (ring1 !is null)
                {
                    if (ring2 !is null)
                    {
                        assert(ring1.name != ring2.name);

                        if (simulate(weapon, armor, ring1, ring2))
                        {
                            cost = getCost(weapon, armor, ring1, ring2);
                        }
                    }
                    else
                    {
                        foreach (ref Item r2; rings)
                        {
                            if (r2.name != ring1.name)
                            {
                                uint newCost = outfitToWin(weapon, armor, ring1, &r2);
                                if (newCost < cost)
                                {
                                    cost = newCost;
                                }
                            }
                        }
                    }
                }
                else
                {
                    foreach (ref Item r1; rings)
                    {
                        uint newCost = outfitToWin(weapon, armor, &r1, ring2);
                        if (newCost < cost)
                        {
                            cost = newCost;
                        }
                    }
                }
            }
            else
            {
                foreach (ref Item arm; armors)
                {
                    uint newCost = outfitToWin(weapon, &arm, ring1, ring2);
                    if (newCost < cost)
                    {
                        cost = newCost;
                    }
                }
            }
        }
        else
        {
            foreach (ref Item weap; weapons)
            {
                uint newCost = outfitToWin(&weap, armor, ring1, ring2);
                if (newCost < cost)
                {
                    cost = newCost;
                }
            }
        }

        return cost;
    }

    uint outfitToLose(in Item* weapon, in Item* armor, in Item* ring1, in Item* ring2)
    {
        uint cost = 0;

        if (weapon !is null)
        {
            if (armor !is null)
            {
                if (ring1 !is null)
                {
                    if (ring2 !is null)
                    {
                        assert(ring1.name != ring2.name);

                        if (!simulate(weapon, armor, ring1, ring2))
                        {
                            cost = getCost(weapon, armor, ring1, ring2);
                        }
                    }
                    else
                    {
                        foreach (ref Item r2; rings)
                        {
                            if (r2.name != ring1.name)
                            {
                                uint newCost = outfitToLose(weapon, armor, ring1, &r2);
                                if (newCost > cost)
                                {
                                    cost = newCost;
                                }
                            }
                        }
                    }
                }
                else
                {
                    foreach (ref Item r1; rings)
                    {
                        uint newCost = outfitToLose(weapon, armor, &r1, ring2);
                        if (newCost > cost)
                        {
                            cost = newCost;
                        }
                    }
                }
            }
            else
            {
                foreach (ref Item arm; armors)
                {
                    uint newCost = outfitToLose(weapon, &arm, ring1, ring2);
                    if (newCost > cost)
                    {
                        cost = newCost;
                    }
                }
            }
        }
        else
        {
            foreach (ref Item weap; weapons)
            {
                uint newCost = outfitToLose(&weap, armor, ring1, ring2);
                if (newCost > cost)
                {
                    cost = newCost;
                }
            }
        }

        return cost;
    }

    writeln(outfitToWin(null, null, null, null));
    writeln(outfitToLose(null, null, null, null));
}
