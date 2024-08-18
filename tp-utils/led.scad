$fa = 2; $fs = 0.2;

eps = 0.01;

module led(l, w, h1, h2, col = "green") {
    r = w / 5;
    color("silver")
        linear_extrude(h1, convexity = 3)
            difference() {
                square([l, w], center = true);
                for (x = [-1, 1]) translate([x * l / 2, 0]) circle(r, $fn = 32);
            }
    color(col)
        translate([-0.2, 0, 0.05])
            linear_extrude(h1, convexity = 3)
                square([0.3, 0.3], center = true);
    color("white", 0.3)
        translate([0, 0, eps])
            linear_extrude(h2, scale = [0.8, 0.9], convexity = 3)
                square([l - 2 * r, w - eps], center = true);
}

module led_5050() {
    color("white")
        linear_extrude(1)
            square(5, center = true);
    color("gray")
        translate([0, 0, eps])
            cylinder(h = 1, d = 4);
    color("silver")
        for (a = [-1,1])
            translate([a * 1.6, 0, eps])
                linear_extrude(0.2)
                    square([1, 5.4], center = true);
}

module led_603(col = "green") {
    led(1.6, 0.8, 0.2, 0.6);
}

module led_805(col = "green") {
    led(2, 1.25, 0.3, 0.7);
}

module ws2812() {
    led_5050();
}

rotate(90) led_603();

translate([2, 0, 0]) rotate(90) led_805();

translate([6, 0, 0]) ws2812();