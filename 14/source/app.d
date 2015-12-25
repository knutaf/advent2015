import std.stdio;
import std.format;
import std.string;
import std.regex;
import std.conv;
import std.algorithm;

enum STATE
{
    FLYING,
    RESTING,
}

struct Reindeer
{
    string name;
    uint speed;
    uint flyTime;
    uint restTime;

    uint nextEventDuration;
    STATE state;
    uint distance;
    uint points;

    public const pure string toString()
    {
        return format("%s can fly %s km/s for %s, but then must rest for %s seconds.", name, speed, flyTime, restTime);
    }
}

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need duration to simulate");
    }

    uint duration = to!uint(args[1]);

    Reindeer[] deer;

    auto rxLine = ctRegex!`^(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds\.$`;
    foreach (char[] l; stdin.byLine())
    {
        string line = l.idup();
        Captures!string cap = matchFirst(line, rxLine);
        if (cap)
        {
            Reindeer r;
            r.name = cap[1];
            r.speed = to!uint(cap[2]);
            r.flyTime = to!uint(cap[3]);
            r.restTime = to!uint(cap[4]);
            deer ~= r;
        }
        else
        {
            throw new Exception(format("unmatched line! %s", line));
        }
    }

    foreach (ref reindeer; deer)
    {
        writefln("deer: %s", reindeer.toString());

        reindeer.nextEventDuration = min(reindeer.flyTime, duration);
    }

    for (; duration > 0; duration--)
    {
        uint maxDistance = 0;

        foreach (ref reindeer; deer)
        {
            assert(reindeer.nextEventDuration > 0);
            reindeer.nextEventDuration--;

            final switch (reindeer.state)
            {
            case STATE.FLYING:
                reindeer.distance += reindeer.speed;
                if (reindeer.nextEventDuration == 0)
                {
                    reindeer.state = STATE.RESTING;
                    reindeer.nextEventDuration = min(reindeer.restTime, duration);
                }
                break;

            case STATE.RESTING:
                if (reindeer.nextEventDuration == 0)
                {
                    reindeer.state = STATE.FLYING;
                    reindeer.nextEventDuration = min(reindeer.flyTime, duration);
                }
                break;
            }

            if (reindeer.distance > maxDistance)
            {
                maxDistance = reindeer.distance;
            }
        }

        foreach (ref reindeer; deer)
        {
            if (reindeer.distance == maxDistance)
            {
                reindeer.points++;
            }
        }
    }

    assert(duration == 0);

    uint maxDistance = 0;
    uint maxPoints = 0;
    const(Reindeer)* maxPointsReindeer;
    const(Reindeer)* maxDistanceReindeer;
    foreach (const ref reindeer; deer)
    {
        if (reindeer.distance > maxDistance)
        {
            maxDistance = reindeer.distance;
            maxDistanceReindeer = &reindeer;
        }

        if (reindeer.points > maxPoints)
        {
            maxPoints = reindeer.points;
            maxPointsReindeer = &reindeer;
        }

        writefln("%s after %s seconds: %s, %s points", reindeer.name, duration, reindeer.distance, reindeer.points);
    }

    writefln("max distance: %s, %s km, %s points", maxDistanceReindeer.name, maxDistanceReindeer.distance, maxDistanceReindeer.points);
    writefln("max points: %s, %s km, %s points", maxPointsReindeer.name, maxPointsReindeer.distance, maxPointsReindeer.points);
}
