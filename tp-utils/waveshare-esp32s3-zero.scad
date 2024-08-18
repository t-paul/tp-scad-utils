$fa = 2; $fs = 0.2;

eps = 0.01;
wall = 1.6;
tolerance = 0.2;

esp32s3_width = 18;
esp32s3_length = 24;
esp32s3_thickness = 1.6;

usb_c_width = 9.2;
usb_c_length = 8;
usb_c_height = 3.5;

esp32s3_usb_c_pos = [0, 0, esp32s3_thickness + usb_c_height / 2];

function esp32s3_width() = esp32s3_width;
function esp32s3_length() = esp32s3_length;
function esp32s3_thickness() = esp32s3_thickness;
function esp32s3_usb_c_pos() = esp32s3_usb_c_pos;

module esp32s3_zero_pins(l, w) {
    yo = [-w/2, -w/2 + 1.27, "", w/2 - 1.27, w/2];
    for (x = [1:9], y = [-2,-1,1,2])
        translate([2.54 * x - 1.27/2, yo[y + 2], 0])
            children($row = y);
}

module esp32s3_zero(alpha = 1) {
    if ($preview) {
        w2  = esp32s3_width / 2;
        color("green", alpha = alpha)
            translate([0, -w2, 0])
                cube([esp32s3_length, esp32s3_width, esp32s3_thickness]);
        color("gold")
            render() esp32s3_zero_pins(esp32s3_length, esp32s3_width) {
                s = sign($row);
                translate([0, 0, -eps])
                    if (abs($row) == 1)
                        cylinder(d = 1.6, h = esp32s3_thickness + 2 * eps);
                    else
                        translate([0, s * (-1.27/2 + eps), esp32s3_thickness / 2 + eps])
                            cube([1.6, 1.27, esp32s3_thickness + 2 * eps], center = true);
            }

        // LED
        color("white", alpha = alpha)
            translate([9, 0, esp32s3_thickness - eps])
                linear_extrude(1) square(2, center = true);
        // Buttons
        for (yo = [-4, 4])
            translate([9, yo, esp32s3_thickness - eps]) {
                color("silver", alpha = alpha)
                    linear_extrude(1) square([2.6, 3.2], center = true);
                color("black")
                    cylinder(h = 1.2, d = 1.4);
            }
        // Chip
        color("black", alpha = alpha) translate([16, 0, esp32s3_thickness - eps])
            rotate(45)
                linear_extrude(0.8)
                    offset(0.2)
                        square(7, center = true);
        // USB-C
        color("silver", alpha = alpha)
            translate([-1.3, 0, esp32s3_thickness + usb_c_height / 2 - eps])
                rotate([0, 90, 0])
                    linear_extrude(usb_c_length)
                        offset(1.5) offset(-1.5)
                            square([usb_c_height, usb_c_width], center = true);
        // Antenna
        color("white", alpha = alpha)
            translate([22.7, -2.6, esp32s3_thickness - eps])
                linear_extrude(1) square([2.3, 5.6], center = true);
        color("red", alpha = alpha)
            translate([22.7, -2.6, esp32s3_thickness + eps])
                linear_extrude(1) square([2.3 + eps, 5], center = true);
    }
}

esp32s3_zero();
