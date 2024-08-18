$fa = 2; $fs = 0.2;

module sot23() {
    color("black")
        linear_extrude(1.26)
            square([2.9, 1.7], center = true);
    color("silver")
        for (a = [-1:1])
            translate([a * 0.95, 0, 0])
                linear_extrude(0.2)
                    square([0.4, 2.85], center = true);
}

sot23();