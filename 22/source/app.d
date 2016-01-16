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
    uint bossHitPoints = 0;
    uint bossDamageStat = 0;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        trySetUintFromRx(line, rxHitPoints, bossHitPoints);
        trySetUintFromRx(line, rxDamage, bossDamageStat);
    }

    writefln("boss hp: %s, damage: %s", bossHitPoints, bossDamageStat);

    if (bossHitPoints == 0 ||
        bossDamageStat == 0)
    {
        throw new Exception("missing required boss params!");
    }

    immutable uint magicMissileCost = 53;
    immutable uint magicMissileDamage = 4;

    immutable uint drainCost = 73;
    immutable uint drainDamage = 2;
    immutable uint drainHeal = 2;

    immutable uint shieldCost = 113;
    immutable uint shieldArmorBoost = 7;
    immutable uint shieldTurns = 6;

    immutable uint poisonCost = 173;
    immutable uint poisonDamage = 3;
    immutable uint poisonTurns = 6;

    immutable uint rechargeCost = 229;
    immutable uint rechargeGain = 101;
    immutable uint rechargeTurns = 5;

    immutable uint playerInitialHp = 50;
    immutable uint playerInitialMana = 500;

    struct GameState
    {
        uint playerHp;
        uint playerMana;
        uint playerArmor;

        uint bossHp;

        uint drainTurnsLeft;
        uint shieldTurnsLeft;
        uint poisonTurnsLeft;
        uint rechargeTurnsLeft;

        pure bool drainActive()
        {
            return drainTurnsLeft > 0;
        }

        pure bool shieldActive()
        {
            return shieldTurnsLeft > 0;
        }

        pure bool poisonActive()
        {
            return poisonTurnsLeft > 0;
        }

        pure bool rechargeActive()
        {
            return rechargeTurnsLeft > 0;
        }

        pure string toString()
        {
            return format("player: %s hp, %s mana, %s armor. boss: %s hp. drain: %s, shield: %s, poison: %s, recharge: %s", playerHp, playerMana, playerArmor, bossHp, drainTurnsLeft, shieldTurnsLeft, poisonTurnsLeft, rechargeTurnsLeft);
        }
    }

    GameState gs;
    gs.playerHp = playerInitialHp;
    gs.playerMana = playerInitialMana;
    gs.bossHp = bossHitPoints;

    writeln(gs);
}
