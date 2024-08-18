$fa = 2; $fs = 0.2;

eps = 0.01;

usb_c_width = 5.6;
usb_c_length = 12.2;
usb_c_depth = 8;
usb_c_clip_width = 3.8;
usb_c_clip_length = 14.2;

function usb_c_receptible_width() = usb_c_width + 4;
function usb_c_receptible_length() = usb_c_length + 4;

// https://www.amazon.de/dp/B0CL9DYD76
// USB-C-Buchse für Panelmontage 3A
module usb_c_receptible(support = false, tolerance = 0.2) {
    o = 4 + 2 * tolerance;
    difference() {
        union() {
            translate([0, eps, 0])
                rotate([-90, 0, 0]) {
                   linear_extrude(usb_c_depth)
                        offset(o / 2)
                            square([usb_c_clip_length, usb_c_width], center = true);

                    if (support) {
                        translate([0, usb_c_width / 2 - eps, 0])
                            linear_extrude(usb_c_depth)
                                translate([-(usb_c_clip_length + o) / 2, 0])
                                    square([usb_c_clip_length + o, o / 2 + 2 * eps]);

                        translate([0, usb_c_width / 2 + o / 2, 0])
                            linear_extrude(usb_c_depth, scale = [1, 0])
                                translate([0, usb_c_depth / 2])
                                    square([usb_c_clip_length + o, usb_c_depth], center = true);
                        }
                    }
        }
        usb_c_receptible_neg(tolerance);
    }
}

module usb_c_receptible_neg(tolerance = 0.2) {
    translate([0, -eps, 0])
        rotate([-90, 0, 0])
            linear_extrude(usb_c_depth + 1)
                offset(0.6 + tolerance) offset(-0.6)
                    square([usb_c_length, usb_c_width], center = true);

    h1 = 1.6;
    h2 = 3;
	h2s = 1.8;
    translate([0, -eps, 0])
        rotate([-90, 0, 0]) {
            translate([0, 0, -eps + 0.6])
                mirror([0, 0, 1])
                    linear_extrude(1, scale = [(usb_c_clip_length + 1) / usb_c_clip_length, 1])
                        offset(0.3) offset(-0.3)
                            square([usb_c_clip_length, usb_c_clip_width], center = true);
            translate([0, 0, -eps])
                linear_extrude(h1 + 2 * eps)
                    offset(0.3) offset(-0.3)
                        square([usb_c_clip_length, usb_c_clip_width], center = true);
            translate([0, 0, h1])
                linear_extrude(h2, scale = [(usb_c_clip_length + h2s) / usb_c_clip_length, 1])
                    offset(0.3) offset(-0.3)
                        square([usb_c_clip_length, usb_c_clip_width], center = true);
            translate([0, 0, h1 + h2 - eps])
                linear_extrude(usb_c_depth - h2)
                    offset(0.3) offset(-0.3)
                        square([usb_c_clip_length + h2s, usb_c_clip_width], center = true);
        }
}

module usb_c_receptible_test() {
    difference() {
        h = 13;
        union() {
            translate([0, 0, 10])
                rotate([-90, 0, 0])
                    linear_extrude(3)
                        offset(2)
                            square([30, 15], center = true);

            linear_extrude(2)
                offset(2)
                    square([30, 10], center = true);
            translate([0, 0, h])
                usb_c_receptible(support = true);
        }
        translate([0, 0, h])
            usb_c_receptible_neg();
    }
}

usb_c_receptible_test();