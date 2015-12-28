import std.stdio;
import std.string;

void main()
{
    bool[][] grid;
    uint row = 0;

    foreach (char[] l; stdin.byLine())
    {
        uint col = 0;

        if (row == 0 && col == 0)
        {
            grid.length = l.length;
            writefln("setting length to %s", grid.length);
        }

        if (col == 0)
        {
            grid[row].length = grid.length;
        }

        foreach (char c; l)
        {
            writefln("doing %s,%s", row, col);
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

    foreach (const ref bool[] r; grid)
    {
        foreach (const ref bool cell; r)
        {
            writef("%s", cell ? "#" : ".");
        }

        writeln("");
    }
}
