$fa = 2; $fs = 0.2;

eps = 0.01;

module resistor(n, size) {
    color("silver")
        linear_extrude(size.z, convexity = 3)
            difference() {
                square(size.xy, center = true);
            }
    color("black")
        translate([0, 0, eps])
            linear_extrude(size.z, convexity = 3)
                square([size.x - 0.4, size.y + eps], center = true);
}

module resistor_0201() resistor("0201", [ 0.6,  0.3, 0.25]);
module resistor_0402() resistor("0402", [ 1.0,  0.5, 0.35]);
module resistor_0603() resistor("0603", [1.55, 0.85, 0.45]);
module resistor_0805() resistor("0805", [ 2.0,  1.2, 0.45]);
module resistor_1206() resistor("1206", [ 3.2,  1.6, 0.55]);
module resistor_1210() resistor("1210", [ 3.2,  2.5, 0.55]);
module resistor_1812() resistor("1812", [ 3.2,  4.6, 0.55]);
module resistor_2010() resistor("2010", [ 5.0,  2.5, 0.6 ]);
module resistor_2512() resistor("2512", [ 6.3,  3.2, 0.6 ]);

rotate(90) resistor_0201();
translate([1, 0, 0]) rotate(90) resistor_0402();
translate([3, 0, 0]) rotate(90) resistor_0603();
translate([5, 0, 0]) rotate(90) resistor_0805();
translate([8, 0, 0]) rotate(90) resistor_1206();
translate([11, 0, 0]) rotate(90) resistor_1210();
translate([16, 0, 0]) rotate(90) resistor_1812();
translate([21, 0, 0]) rotate(90) resistor_2010();
translate([25, 0, 0]) rotate(90) resistor_2512();
