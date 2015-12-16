import std.stdio;
import std.format;
import std.string;

enum ACTION
{
    ON,
    OFF,
    TOGGLE
}

struct Change
{
    ACTION action;
    uint r1;
    uint c1;
    uint r2;
    uint c2;
}

void main()
{
    immutable Change[] input =
    [
        {ACTION.ON, 887, 9, 959, 629},
        {ACTION.ON, 454, 398, 844, 448},
        {ACTION.OFF, 539, 243, 559, 965},
        {ACTION.OFF, 370, 819, 676, 868},
        {ACTION.OFF, 145, 40, 370, 997},
        {ACTION.OFF, 301, 3, 808, 453},
        {ACTION.ON, 351, 678, 951, 908},
        {ACTION.TOGGLE, 720, 196, 897, 994},
        {ACTION.TOGGLE, 831, 394, 904, 860},
        {ACTION.TOGGLE, 753, 664, 970, 926},
        {ACTION.OFF, 150, 300, 213, 740},
        {ACTION.ON, 141, 242, 932, 871},
        {ACTION.TOGGLE, 294, 259, 474, 326},
        {ACTION.TOGGLE, 678, 333, 752, 957},
        {ACTION.TOGGLE, 393, 804, 510, 976},
        {ACTION.OFF, 6, 964, 411, 976},
        {ACTION.OFF, 33, 572, 978, 590},
        {ACTION.ON, 579, 693, 650, 978},
        {ACTION.ON, 150, 20, 652, 719},
        {ACTION.OFF, 782, 143, 808, 802},
        {ACTION.OFF, 240, 377, 761, 468},
        {ACTION.OFF, 899, 828, 958, 967},
        {ACTION.ON, 613, 565, 952, 659},
        {ACTION.ON, 295, 36, 964, 978},
        {ACTION.TOGGLE, 846, 296, 969, 528},
        {ACTION.OFF, 211, 254, 529, 491},
        {ACTION.OFF, 231, 594, 406, 794},
        {ACTION.OFF, 169, 791, 758, 942},
        {ACTION.ON, 955, 440, 980, 477},
        {ACTION.TOGGLE, 944, 498, 995, 928},
        {ACTION.ON, 519, 391, 605, 718},
        {ACTION.TOGGLE, 521, 303, 617, 366},
        {ACTION.OFF, 524, 349, 694, 791},
        {ACTION.TOGGLE, 391, 87, 499, 792},
        {ACTION.TOGGLE, 562, 527, 668, 935},
        {ACTION.OFF, 68, 358, 857, 453},
        {ACTION.TOGGLE, 815, 811, 889, 828},
        {ACTION.OFF, 666, 61, 768, 87},
        {ACTION.ON, 27, 501, 921, 952},
        {ACTION.ON, 953, 102, 983, 471},
        {ACTION.ON, 277, 552, 451, 723},
        {ACTION.OFF, 64, 253, 655, 960},
        {ACTION.ON, 47, 485, 734, 977},
        {ACTION.OFF, 59, 119, 699, 734},
        {ACTION.TOGGLE, 407, 898, 493, 955},
        {ACTION.TOGGLE, 912, 966, 949, 991},
        {ACTION.ON, 479, 990, 895, 990},
        {ACTION.TOGGLE, 390, 589, 869, 766},
        {ACTION.TOGGLE, 593, 903, 926, 943},
        {ACTION.TOGGLE, 358, 439, 870, 528},
        {ACTION.OFF, 649, 410, 652, 875},
        {ACTION.ON, 629, 834, 712, 895},
        {ACTION.TOGGLE, 254, 555, 770, 901},
        {ACTION.TOGGLE, 641, 832, 947, 850},
        {ACTION.ON, 268, 448, 743, 777},
        {ACTION.OFF, 512, 123, 625, 874},
        {ACTION.OFF, 498, 262, 930, 811},
        {ACTION.OFF, 835, 158, 886, 242},
        {ACTION.TOGGLE, 546, 310, 607, 773},
        {ACTION.ON, 501, 505, 896, 909},
        {ACTION.OFF, 666, 796, 817, 924},
        {ACTION.TOGGLE, 987, 789, 993, 809},
        {ACTION.TOGGLE, 745, 8, 860, 693},
        {ACTION.TOGGLE, 181, 983, 731, 988},
        {ACTION.ON, 826, 174, 924, 883},
        {ACTION.ON, 239, 228, 843, 993},
        {ACTION.ON, 205, 613, 891, 667},
        {ACTION.TOGGLE, 867, 873, 984, 896},
        {ACTION.ON, 628, 251, 677, 681},
        {ACTION.TOGGLE, 276, 956, 631, 964},
        {ACTION.ON, 78, 358, 974, 713},
        {ACTION.ON, 521, 360, 773, 597},
        {ACTION.OFF, 963, 52, 979, 502},
        {ACTION.ON, 117, 151, 934, 622},
        {ACTION.TOGGLE, 237, 91, 528, 164},
        {ACTION.ON, 944, 269, 975, 453},
        {ACTION.TOGGLE, 979, 460, 988, 964},
        {ACTION.OFF, 440, 254, 681, 507},
        {ACTION.TOGGLE, 347, 100, 896, 785},
        {ACTION.OFF, 329, 592, 369, 985},
        {ACTION.ON, 931, 960, 979, 985},
        {ACTION.TOGGLE, 703, 3, 776, 36},
        {ACTION.TOGGLE, 798, 120, 908, 550},
        {ACTION.OFF, 186, 605, 914, 709},
        {ACTION.OFF, 921, 725, 979, 956},
        {ACTION.TOGGLE, 167, 34, 735, 249},
        {ACTION.ON, 726, 781, 987, 936},
        {ACTION.TOGGLE, 720, 336, 847, 756},
        {ACTION.ON, 171, 630, 656, 769},
        {ACTION.OFF, 417, 276, 751, 500},
        {ACTION.TOGGLE, 559, 485, 584, 534},
        {ACTION.ON, 568, 629, 690, 873},
        {ACTION.TOGGLE, 248, 712, 277, 988},
        {ACTION.TOGGLE, 345, 594, 812, 723},
        {ACTION.OFF, 800, 108, 834, 618},
        {ACTION.OFF, 967, 439, 986, 869},
        {ACTION.ON, 842, 209, 955, 529},
        {ACTION.ON, 132, 653, 357, 696},
        {ACTION.ON, 817, 38, 973, 662},
        {ACTION.OFF, 569, 816, 721, 861},
        {ACTION.ON, 568, 429, 945, 724},
        {ACTION.ON, 77, 458, 844, 685},
        {ACTION.OFF, 138, 78, 498, 851},
        {ACTION.ON, 136, 21, 252, 986},
        {ACTION.OFF, 2, 460, 863, 472},
        {ACTION.ON, 172, 81, 839, 332},
        {ACTION.ON, 123, 216, 703, 384},
        {ACTION.OFF, 879, 644, 944, 887},
        {ACTION.TOGGLE, 227, 491, 504, 793},
        {ACTION.TOGGLE, 580, 418, 741, 479},
        {ACTION.TOGGLE, 65, 276, 414, 299},
        {ACTION.TOGGLE, 482, 486, 838, 931},
        {ACTION.OFF, 557, 768, 950, 927},
        {ACTION.OFF, 615, 617, 955, 864},
        {ACTION.ON, 859, 886, 923, 919},
        {ACTION.ON, 391, 330, 499, 971},
        {ACTION.TOGGLE, 521, 835, 613, 847},
        {ACTION.ON, 822, 787, 989, 847},
        {ACTION.ON, 192, 142, 357, 846},
        {ACTION.OFF, 564, 945, 985, 945},
        {ACTION.OFF, 479, 361, 703, 799},
        {ACTION.TOGGLE, 56, 481, 489, 978},
        {ACTION.OFF, 632, 991, 774, 998},
        {ACTION.TOGGLE, 723, 526, 945, 792},
        {ACTION.ON, 344, 149, 441, 640},
        {ACTION.TOGGLE, 568, 927, 624, 952},
        {ACTION.ON, 621, 784, 970, 788},
        {ACTION.TOGGLE, 665, 783, 795, 981},
        {ACTION.TOGGLE, 386, 610, 817, 730},
        {ACTION.TOGGLE, 440, 399, 734, 417},
        {ACTION.TOGGLE, 939, 201, 978, 803},
        {ACTION.OFF, 395, 883, 554, 929},
        {ACTION.ON, 340, 309, 637, 561},
        {ACTION.OFF, 875, 147, 946, 481},
        {ACTION.OFF, 945, 837, 957, 922},
        {ACTION.OFF, 429, 982, 691, 991},
        {ACTION.TOGGLE, 227, 137, 439, 822},
        {ACTION.TOGGLE, 4, 848, 7, 932},
        {ACTION.OFF, 545, 146, 756, 943},
        {ACTION.ON, 763, 863, 937, 994},
        {ACTION.ON, 232, 94, 404, 502},
        {ACTION.OFF, 742, 254, 930, 512},
        {ACTION.ON, 91, 931, 101, 942},
        {ACTION.TOGGLE, 585, 106, 651, 425},
        {ACTION.ON, 506, 700, 567, 960},
        {ACTION.OFF, 548, 44, 718, 352},
        {ACTION.OFF, 194, 827, 673, 859},
        {ACTION.OFF, 6, 645, 509, 764},
        {ACTION.OFF, 13, 230, 821, 361},
        {ACTION.ON, 734, 629, 919, 631},
        {ACTION.TOGGLE, 788, 552, 957, 972},
        {ACTION.TOGGLE, 244, 747, 849, 773},
        {ACTION.OFF, 162, 553, 276, 887},
        {ACTION.OFF, 569, 577, 587, 604},
        {ACTION.OFF, 799, 482, 854, 956},
        {ACTION.ON, 744, 535, 909, 802},
        {ACTION.TOGGLE, 330, 641, 396, 986},
        {ACTION.OFF, 927, 458, 966, 564},
        {ACTION.TOGGLE, 984, 486, 986, 913},
        {ACTION.TOGGLE, 519, 682, 632, 708},
        {ACTION.ON, 984, 977, 989, 986},
        {ACTION.TOGGLE, 766, 423, 934, 495},
        {ACTION.ON, 17, 509, 947, 718},
        {ACTION.ON, 413, 783, 631, 903},
        {ACTION.ON, 482, 370, 493, 688},
        {ACTION.ON, 433, 859, 628, 938},
        {ACTION.OFF, 769, 549, 945, 810},
        {ACTION.ON, 178, 853, 539, 941},
        {ACTION.OFF, 203, 251, 692, 433},
        {ACTION.OFF, 525, 638, 955, 794},
        {ACTION.ON, 169, 70, 764, 939},
        {ACTION.TOGGLE, 59, 352, 896, 404},
        {ACTION.TOGGLE, 143, 245, 707, 320},
        {ACTION.OFF, 103, 35, 160, 949},
        {ACTION.TOGGLE, 496, 24, 669, 507},
        {ACTION.OFF, 581, 847, 847, 903},
        {ACTION.ON, 689, 153, 733, 562},
        {ACTION.ON, 821, 487, 839, 699},
        {ACTION.ON, 837, 627, 978, 723},
        {ACTION.TOGGLE, 96, 748, 973, 753},
        {ACTION.TOGGLE, 99, 818, 609, 995},
        {ACTION.ON, 731, 193, 756, 509},
        {ACTION.OFF, 622, 55, 813, 365},
        {ACTION.ON, 456, 490, 576, 548},
        {ACTION.ON, 48, 421, 163, 674},
        {ACTION.OFF, 853, 861, 924, 964},
        {ACTION.OFF, 59, 963, 556, 987},
        {ACTION.ON, 458, 710, 688, 847},
        {ACTION.TOGGLE, 12, 484, 878, 562},
        {ACTION.OFF, 241, 964, 799, 983},
        {ACTION.OFF, 434, 299, 845, 772},
        {ACTION.TOGGLE, 896, 725, 956, 847},
        {ACTION.ON, 740, 289, 784, 345},
        {ACTION.OFF, 395, 840, 822, 845},
        {ACTION.ON, 955, 224, 996, 953},
        {ACTION.OFF, 710, 186, 957, 722},
        {ACTION.OFF, 485, 949, 869, 985},
        {ACTION.ON, 848, 209, 975, 376},
        {ACTION.TOGGLE, 221, 241, 906, 384},
        {ACTION.ON, 588, 49, 927, 496},
        {ACTION.ON, 273, 332, 735, 725},
        {ACTION.ON, 505, 962, 895, 962},
        {ACTION.TOGGLE, 820, 112, 923, 143},
        {ACTION.ON, 919, 792, 978, 982},
        {ACTION.TOGGLE, 489, 461, 910, 737},
        {ACTION.OFF, 202, 642, 638, 940},
        {ACTION.OFF, 708, 953, 970, 960},
        {ACTION.TOGGLE, 437, 291, 546, 381},
        {ACTION.ON, 409, 358, 837, 479},
        {ACTION.OFF, 756, 279, 870, 943},
        {ACTION.OFF, 154, 657, 375, 703},
        {ACTION.OFF, 524, 622, 995, 779},
        {ACTION.TOGGLE, 514, 221, 651, 850},
        {ACTION.TOGGLE, 808, 464, 886, 646},
        {ACTION.TOGGLE, 483, 537, 739, 840},
        {ACTION.TOGGLE, 654, 769, 831, 825},
        {ACTION.OFF, 326, 37, 631, 69},
        {ACTION.OFF, 590, 570, 926, 656},
        {ACTION.OFF, 881, 913, 911, 998},
        {ACTION.ON, 996, 102, 998, 616},
        {ACTION.OFF, 677, 503, 828, 563},
        {ACTION.ON, 860, 251, 877, 441},
        {ACTION.OFF, 964, 100, 982, 377},
        {ACTION.TOGGLE, 888, 403, 961, 597},
        {ACTION.OFF, 632, 240, 938, 968},
        {ACTION.TOGGLE, 731, 176, 932, 413},
        {ACTION.ON, 5, 498, 203, 835},
        {ACTION.ON, 819, 352, 929, 855},
        {ACTION.TOGGLE, 393, 813, 832, 816},
        {ACTION.TOGGLE, 725, 689, 967, 888},
        {ACTION.ON, 968, 950, 969, 983},
        {ACTION.OFF, 152, 628, 582, 896},
        {ACTION.OFF, 165, 844, 459, 935},
        {ACTION.OFF, 882, 741, 974, 786},
        {ACTION.OFF, 283, 179, 731, 899},
        {ACTION.TOGGLE, 197, 366, 682, 445},
        {ACTION.ON, 106, 309, 120, 813},
        {ACTION.TOGGLE, 950, 387, 967, 782},
        {ACTION.OFF, 274, 603, 383, 759},
        {ACTION.OFF, 155, 665, 284, 787},
        {ACTION.TOGGLE, 551, 871, 860, 962},
        {ACTION.OFF, 30, 826, 598, 892},
        {ACTION.TOGGLE, 76, 552, 977, 888},
        {ACTION.ON, 938, 180, 994, 997},
        {ACTION.TOGGLE, 62, 381, 993, 656},
        {ACTION.TOGGLE, 625, 861, 921, 941},
        {ACTION.ON, 685, 311, 872, 521},
        {ACTION.ON, 124, 934, 530, 962},
        {ACTION.ON, 606, 379, 961, 867},
        {ACTION.OFF, 792, 735, 946, 783},
        {ACTION.ON, 417, 480, 860, 598},
        {ACTION.TOGGLE, 178, 91, 481, 887},
        {ACTION.OFF, 23, 935, 833, 962},
        {ACTION.TOGGLE, 317, 14, 793, 425},
        {ACTION.ON, 986, 89, 999, 613},
        {ACTION.OFF, 359, 201, 560, 554},
        {ACTION.OFF, 729, 494, 942, 626},
        {ACTION.ON, 204, 143, 876, 610},
        {ACTION.TOGGLE, 474, 97, 636, 542},
        {ACTION.OFF, 902, 924, 976, 973},
        {ACTION.OFF, 389, 442, 824, 638},
        {ACTION.OFF, 622, 863, 798, 863},
        {ACTION.ON, 840, 622, 978, 920},
        {ACTION.TOGGLE, 567, 374, 925, 439},
        {ACTION.OFF, 643, 319, 935, 662},
        {ACTION.TOGGLE, 185, 42, 294, 810},
        {ACTION.ON, 47, 124, 598, 880},
        {ACTION.TOGGLE, 828, 303, 979, 770},
        {ACTION.OFF, 174, 272, 280, 311},
        {ACTION.OFF, 540, 50, 880, 212},
        {ACTION.ON, 141, 994, 221, 998},
        {ACTION.ON, 476, 695, 483, 901},
        {ACTION.ON, 960, 216, 972, 502},
        {ACTION.TOGGLE, 752, 335, 957, 733},
        {ACTION.OFF, 419, 713, 537, 998},
        {ACTION.TOGGLE, 772, 846, 994, 888},
        {ACTION.ON, 881, 159, 902, 312},
        {ACTION.OFF, 537, 651, 641, 816},
        {ACTION.TOGGLE, 561, 947, 638, 965},
        {ACTION.ON, 368, 458, 437, 612},
        {ACTION.ON, 290, 149, 705, 919},
        {ACTION.ON, 711, 918, 974, 945},
        {ACTION.TOGGLE, 916, 242, 926, 786},
        {ACTION.TOGGLE, 522, 272, 773, 314},
        {ACTION.ON, 432, 897, 440, 954},
        {ACTION.OFF, 132, 169, 775, 380},
        {ACTION.TOGGLE, 52, 205, 693, 747},
        {ACTION.TOGGLE, 926, 309, 976, 669},
        {ACTION.OFF, 838, 342, 938, 444},
        {ACTION.ON, 144, 431, 260, 951},
        {ACTION.TOGGLE, 780, 318, 975, 495},
        {ACTION.OFF, 185, 412, 796, 541},
        {ACTION.ON, 879, 548, 892, 860},
        {ACTION.ON, 294, 132, 460, 338},
        {ACTION.ON, 823, 500, 899, 529},
        {ACTION.OFF, 225, 603, 483, 920},
        {ACTION.TOGGLE, 717, 493, 930, 875},
        {ACTION.TOGGLE, 534, 948, 599, 968},
        {ACTION.ON, 522, 730, 968, 950},
        {ACTION.OFF, 102, 229, 674, 529},
    ];

    /*
    immutable Change[] input =
    [
        {ACTION.ON, 0, 0, 2, 2},
        {ACTION.TOGGLE, 0, 0, 0, 0},
        {ACTION.TOGGLE, 0, 0, 0, 0},
        {ACTION.TOGGLE, 0, 0, 0, 0},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
        {ACTION.OFF, 0, 0, 2, 2},
    ];
    */

    uint[][] grid;
    grid.length = 1000;
    foreach (ref uint[] row; grid)
    {
        row.length = 1000;
        foreach (ref uint cell; row)
        {
            cell = 0;
        }
    }

    int totalOn = 0;
    foreach (const ref Change change; input)
    {
        if (change.r1 > change.r2)
        {
            throw new Exception("found r1 > r2");
        }

        if (change.c1 > change.c2)
        {
            throw new Exception("found c1 > c2");
        }

        for (uint r = change.r1; r <= change.r2; r++)
        {
            for (uint c = change.c1; c <= change.c2; c++)
            {
                final switch (change.action)
                {
                case ACTION.ON:
                    totalOn++;
                    grid[r][c]++;
                    break;

                case ACTION.OFF:
                    if (grid[r][c] > 0)
                    {
                        totalOn--;
                        grid[r][c]--;
                    }
                    break;

                case ACTION.TOGGLE:
                    totalOn += 2;
                    grid[r][c] += 2;
                    break;
                }
            }
        }
    }

    writefln("total on: %s", totalOn);
}
