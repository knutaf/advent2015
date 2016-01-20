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
        string sequence;
        bool playerTurn;

        uint playerHp;
        uint playerMana;
        uint playerArmor;
        uint manaSpent;

        uint bossHp;

        uint shieldTurnsLeft;
        uint poisonTurnsLeft;
        uint rechargeTurnsLeft;

        void flipTurn()
        {
            playerTurn = !playerTurn;
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
            return format("%s - player: %s hp, %s mana, %s armor, %s spent. boss: %s hp. shield: %s, poison: %s, recharge: %s. [%s]", playerTurn ? "p" : "b", playerHp, playerMana, playerArmor, manaSpent, bossHp, shieldTurnsLeft, poisonTurnsLeft, rechargeTurnsLeft, sequence);
        }
    }

    bool applyDamage(uint attackerDamage, uint defenderArmor, ref uint defenderHp)
    {
        uint damage;
        if (attackerDamage > defenderArmor)
        {
            damage = (attackerDamage - defenderArmor);
        }
        else
        {
            damage = 1;
        }

        if (damage > defenderHp)
        {
            damage = defenderHp;
        }

        defenderHp -= damage;
        return (defenderHp > 0);
    }

    uint minManaCost = uint.max;

    uint simulate(GameState gs)
    {
        writeln(gs);
        gs.playerArmor = 0;

        if (gs.playerTurn)
        {
            if (!applyDamage(1, 0, gs.playerHp))
            {
                writeln("hard mode died");
                return uint.max;
            }
        }

        assert(gs.poisonActive || gs.poisonTurnsLeft == 0);
        if (gs.poisonActive)
        {
            gs.sequence ~= "poison_dmg ";
            gs.poisonTurnsLeft--;

            if (!applyDamage(poisonDamage, 0, gs.bossHp))
            {
                writefln("killed boss with poison: %s mana", gs.manaSpent);
                return gs.manaSpent;
            }
        }
        assert(gs.poisonActive || gs.poisonTurnsLeft == 0);

        assert(gs.shieldActive || gs.shieldTurnsLeft == 0);
        if (gs.shieldActive)
        {
            gs.playerArmor = shieldArmorBoost;
            gs.shieldTurnsLeft--;
        }
        assert(gs.shieldActive || gs.shieldTurnsLeft == 0);

        assert(gs.rechargeActive || gs.rechargeTurnsLeft == 0);
        if (gs.rechargeActive)
        {
            gs.playerMana += rechargeGain;
            gs.rechargeTurnsLeft--;
        }
        assert(gs.rechargeActive || gs.rechargeTurnsLeft == 0);

        assert(gs.bossHp > 0);
        assert(gs.playerHp > 0);

        if (gs.manaSpent < minManaCost)
        {
            if (gs.playerTurn)
            {
                uint origMinManaCost = minManaCost;
                bool canCast = false;

                if (gs.playerMana >= magicMissileCost)
                {
                    canCast = true;

                    GameState gs2 = gs;
                    gs2.playerMana -= magicMissileCost;
                    gs2.manaSpent += magicMissileCost;
                    gs2.sequence ~= "mm ";
                    uint cost;
                    if (applyDamage(magicMissileDamage, 0, gs2.bossHp))
                    {
                        gs2.flipTurn();
                        writeln("cast magic missile (survived)");
                        cost = simulate(gs2);
                    }
                    else
                    {
                        writefln("cast magic missile (won): %s", gs2.manaSpent);
                        cost = gs2.manaSpent;
                    }

                    if (cost < minManaCost)
                    {
                        minManaCost = cost;
                    }
                }

                if (gs.playerMana >= drainCost)
                {
                    canCast = true;

                    GameState gs2 = gs;
                    gs2.playerMana -= drainCost;
                    gs2.manaSpent += drainCost;
                    gs2.sequence ~= "drain ";

                    uint cost;
                    if (applyDamage(drainDamage, 0, gs2.bossHp))
                    {
                        gs2.playerHp += drainHeal;

                        gs2.flipTurn();
                        writeln("cast drain (survived)");
                        cost = simulate(gs2);
                    }
                    else
                    {
                        cost = gs2.manaSpent;
                        writeln("cast drain (won): %s", gs2.manaSpent);
                    }

                    if (cost < minManaCost)
                    {
                        minManaCost = cost;
                    }
                }

                if (gs.playerMana >= poisonCost && !gs.poisonActive)
                {
                    canCast = true;

                    GameState gs2 = gs;
                    gs2.playerMana -= poisonCost;
                    gs2.manaSpent += poisonCost;
                    gs2.sequence ~= "poison ";
                    gs2.poisonTurnsLeft = poisonTurns;

                    gs2.flipTurn();
                    writeln("cast poison");
                    uint cost = simulate(gs2);
                    if (cost < minManaCost)
                    {
                        minManaCost = cost;
                    }
                }

                if (gs.playerMana >= shieldCost && !gs.shieldActive)
                {
                    canCast = true;

                    GameState gs2 = gs;
                    gs2.playerMana -= shieldCost;
                    gs2.manaSpent += shieldCost;
                    gs2.sequence ~= "shield ";
                    gs2.shieldTurnsLeft = shieldTurns;

                    gs2.flipTurn();
                    writeln("cast shield");
                    uint cost = simulate(gs2);
                    if (cost < minManaCost)
                    {
                        minManaCost = cost;
                    }
                }

                if (gs.playerMana >= rechargeCost && !gs.rechargeActive)
                {
                    canCast = true;

                    GameState gs2 = gs;
                    gs2.playerMana -= rechargeCost;
                    gs2.manaSpent += rechargeCost;
                    gs2.sequence ~= "recharge ";
                    gs2.rechargeTurnsLeft = rechargeTurns;

                    gs2.flipTurn();
                    writeln("cast recharge");
                    uint cost = simulate(gs2);
                    if (cost < minManaCost)
                    {
                        minManaCost = cost;
                    }
                }

                if (!canCast)
                {
                    writeln("can't cast (lost)");
                    assert(origMinManaCost == minManaCost);
                }

                return minManaCost;
            }
            else
            {
                if (applyDamage(bossDamageStat, gs.playerArmor, gs.playerHp))
                {
                    writeln("boss attacked (survived)");
                    gs.flipTurn();
                    return simulate(gs);
                }
                else
                {
                    writeln("we died");
                    return uint.max;
                }
            }
        }
        else
        {
            return uint.max;
        }
    }

    GameState gs;
    gs.sequence = "";
    gs.playerTurn = true;
    gs.playerHp = playerInitialHp;
    gs.playerMana = playerInitialMana;
    gs.bossHp = bossHitPoints;

    writefln("min cost: %s", simulate(gs));
}
