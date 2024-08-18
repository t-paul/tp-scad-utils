use <pcb.scad>
use <sot23.scad>
use <led.scad>

$fa = 2; $fs = 0.2;

eps = 0.01;

ttp223_touch_width = 11.1;
ttp223_touch_length = 14.7;
ttp223_touch_thickness = 1.0;

function ttp223_touch_width() = ttp223_touch_width;
function ttp223_touch_length() = ttp223_touch_length;
function ttp223_touch_thickness() = ttp223_touch_thickness;

module pin(od = 1.6, h = 1.6) {
    translate([0, 0, -eps])
        cylinder(d = od, h = h + 2 * eps);
}

module pin_neg(id = 1, h = 1.6) {
    translate([0, 0, -2*eps])
        cylinder(d = id, h = h + 4 * eps);
}

module ttp223_touch_pin_pos() {
    for (a = [1:3])
        translate([(a - 2) * 2.54, ttp223_touch_length - 2.54 / 2])
            children($pin = a);
}

module ttp223_touch() {
    if ($preview) difference() {
        union() {
            color("OrangeRed")
                linear_extrude(ttp223_touch_thickness)
                    translate([-ttp223_touch_width/2, 0])
                        offset(0.2) offset(-0.2)
                            square([ttp223_touch_width, ttp223_touch_length]);

            // Silk
            color("white")
                translate([0, ttp223_touch_width/2, eps])
                    linear_extrude(ttp223_touch_thickness) {
                        resize([ttp223_touch_width / 2, -1], auto = true)
                            text("TOUCH", halign = "center", valign = "center");
                        difference() {
                            circle(d = ttp223_touch_width - 0.2);
                            circle(d = ttp223_touch_width - 0.6);
                        }
                    }
            // Pins
            color("silver")
                ttp223_touch_pin_pos()
                    pin(h = ttp223_touch_thickness);

            // Back side
            rotate([0, 180, 0]) {
                // TTP223
                translate([0, 2.0, -eps])
                    sot23();
                // LED
                translate([-4, 2.0, -eps])
                    rotate(90)
                        led_603();
                // Pin description
                color("white")
                    ttp223_touch_pin_pos()
                        translate([0, -1, -ttp223_touch_thickness + eps])
                            linear_extrude(ttp223_touch_thickness)
                                rotate(-90)
                                    resize([-1, 1.27], auto = true)
                                        text(["GND", "I/O", "VCC"][$pin - 1], valign = "center");
            }
        }
        // Pins hole
        color("silver")
            ttp223_touch_pin_pos()
                pin_neg(h = ttp223_touch_thickness);
    }
}

module ttp223_touch_pcb_holder(h, wall = 1.6, tolerance = 0.2, support = false) {
    pcb_holder(ttp223_touch_width, ttp223_touch_length, h, ttp223_touch_thickness, wall = wall, tolerance = tolerance, support = support);
}

ttp223_touch();
translate([18,0,0]) rotate(90) ttp223_touch_pcb_holder(2);
translate([18,0,2+ttp223_touch_thickness]) rotate([0,180,0]) ttp223_touch();
