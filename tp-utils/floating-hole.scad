module floating_hole(d1, h1, d2, h2, tolerance = 0.2, eps = 0.01, layer = 0.2) {
    dt1 = d1 + 2 * tolerance;
    dt2 = d2 + 2 * tolerance;
    translate([0, 0, -eps]) {
        cylinder(d = dt1, h = h1 + eps);
        cylinder(d = dt2, h = h2 + eps);
    }
    translate([0, 0, h1 - eps]) linear_extrude(layer + eps) intersection() {
        circle(d = dt1);
        square([dt1, dt2], center = true);
    }
    translate([0, 0, h1 + layer - eps]) linear_extrude(layer + eps) intersection() {
        circle(d = dt1);
        square(dt2, center = true);
    }
}
