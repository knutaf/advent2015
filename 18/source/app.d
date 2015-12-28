import std.stdio;
import std.string;
import std.conv;

void printGrid(in bool[][] grid)
{
    foreach (const ref bool[] r; grid)
    {
        foreach (const ref bool cell; r)
        {
            writef("%s", cell ? "#" : ".");
        }

        writeln("");
    }
}

void main(string[] args)
{
    if (args.length < 2)
    {
        throw new Exception("need num steps");
    }

    uint numSteps = to!uint(args[1]);

    bool[][] grid;
    bool[][] next;
    uint row = 0;

    foreach (char[] l; stdin.byLine())
    {
        uint col = 0;

        if (row == 0 && col == 0)
        {
            grid.length = l.length;
            next.length = l.length;
            writefln("setting length to %s", grid.length);
        }

        if (col == 0)
        {
            grid[row].length = grid.length;
            next[row].length = next.length;
        }

        foreach (char c; l)
        {
            switch (c)
            {
            case '#':
                grid[row][col] = true;
                break;

            case '.':
                grid[row][col] = false;
                break;

            default:
                throw new Exception(format("unknown initial state %s", c));
            }

            col++;
        }

        row++;
    }

    grid[0][0] = true;
    grid[0][grid[0].length - 1] = true;
    grid[grid.length - 1][0] = true;
    grid[grid.length - 1][grid[grid.length - 1].length -1] = true;

    //writeln("Initial:");
    //printGrid(grid);
    //writeln("");

    foreach (uint step; 0 .. numSteps)
    {
        foreach (ulong r; 0 .. grid.length)
        {
            foreach (ulong c; 0 .. grid[r].length)
            {
                uint numOn = 0;
                if (r > 0)
                {
                    if (c > 0)
                    {
                        numOn += grid[r-1][c-1] ? 1 : 0;
                    }

                    numOn += grid[r-1][c] ? 1 : 0;

                    if (c < grid[r].length - 1)
                    {
                        numOn += grid[r-1][c+1] ? 1 : 0;
                    }
                }

                if (c > 0)
                {
                    numOn += grid[r][c-1] ? 1 : 0;
                }

                if (c < grid[r].length - 1)
                {
                    numOn += grid[r][c+1] ? 1 : 0;
                }

                if (r < grid.length - 1)
                {
                    if (c > 0)
                    {
                        numOn += grid[r+1][c-1] ? 1 : 0;
                    }

                    numOn += grid[r+1][c] ? 1 : 0;

                    if (c < grid[r].length - 1)
                    {
                        numOn += grid[r+1][c+1] ? 1 : 0;
                    }
                }

                if (grid[r][c])
                {
                    next[r][c] = (numOn == 2 || numOn == 3);
                }
                else
                {
                    next[r][c] = (numOn == 3);
                }
            }
        }

        next[0][0] = true;
        next[0][next[0].length - 1] = true;
        next[next.length - 1][0] = true;
        next[next.length - 1][next[next.length - 1].length -1] = true;

        //writefln("After %s steps:", step+1);
        //printGrid(next);
        //writeln("");

        bool[][] temp = grid;
        grid = next;
        next = temp;
    }

    uint numLightsOn = 0;
    foreach (const ref bool[] r; grid)
    {
        foreach (const ref bool cell; r)
        {
            numLightsOn += cell ? 1 : 0;
        }
    }

    writefln("num lights on: %s", numLightsOn);
}
