import std.stdio;
import std.regex;
import std.string;

enum Opcode
{
    hlf,
    tpl,
    inc,
    jmp,
    jie,
    jio
}

struct Instruction
{
    Opcode opcode;
    string reg;
    int num;
}

void main()
{
    auto rxSimple = ctRegex!`^(\w+) (\w+)$`;
    auto rxJmp = ctRegex

    auto rxDamage = ctRegex!`^Damage: (\d+)$`;
    uint bossHitPoints = 0;
    uint bossDamageStat = 0;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        trySetUintFromRx(line, rxHitPoints, bossHitPoints);
        trySetUintFromRx(line, rxDamage, bossDamageStat);
    }
}
