// Wemos D1 Mini ESP32
//
// Torsten Paul <Torsten.Paul@gmx.de>, December 2023
// CC BY-SA 4.0
// https://creativecommons.org/licenses/by-sa/4.0/

tolerance = 0.3;

wall = 2;
eps = 0.01;

d1_mini_esp32_width = 31.4;
d1_mini_esp32_length = 39;
d1_mini_esp32_thickness = 1;
d1_mini_esp32_standoff = 3;
d1_mini_esp32_reset_cutout = 7;

usb_micro_height = 2;

screwhole = function(a, d) (d / 2 + tolerance * sin(5 * a)) * [sin(a), cos(a)];

function d1_mini_esp32_standoff() = d1_mini_esp32_standoff;
function d1_mini_esp32_thickness() = d1_mini_esp32_thickness;
function usb_micro_height() = usb_micro_height;

module d1_mini_esp32(alpha = 1) {
	if ($preview) {
		w2  = d1_mini_esp32_width / 2;
		color("green", alpha = alpha) render() difference() {
			translate([-w2, 0, 0])
				cube([d1_mini_esp32_width, d1_mini_esp32_length, d1_mini_esp32_thickness]);
			// reset button cutout
			translate([-w2, 0])
				cube([2 * 2.54, 2 * d1_mini_esp32_reset_cutout, 3], center = true);
			translate([-w2 - 1, d1_mini_esp32_length - 3, -1])
				rotate(45)
					cube([8, 8, 3]);
			translate([w2 + 1, d1_mini_esp32_length - 3, -1])
				rotate(45)
					cube([8, 8, 3]);
		}
		color("silver", alpha = alpha) translate([-7.5, 14, d1_mini_esp32_thickness - eps])
			cube([15, 17, 3.2]);
		color("black", alpha = alpha) translate([-9, 13.5, d1_mini_esp32_thickness - eps])
			cube([18, 25, 0.7]);
		color("silver", alpha = alpha) translate([-5, -1, d1_mini_esp32_thickness - eps])
			cube([10, 8, usb_micro_height]);
	}
}

module usb_micro_cutout(h = 10) {
	rotate([-90, 0, 0])
		translate([0, 0, -0.2])
			linear_extrude(h + 0.2)
				offset(1) offset(-1)
					square([12, 8], center = true);
}

module d1_mini_esp32_holder() {
	w2 = d1_mini_esp32_width / 2;

	module clip(l, h, w = wall) {
		assert(w <= d1_mini_esp32_standoff);
		difference() {
			union() {
				translate([-w/2, 0, 0])
					cube([w, l, d1_mini_esp32_standoff + eps]);
				translate([-w, 0, 0])
					cube([w, l, d1_mini_esp32_standoff + h + tolerance + eps]);
				translate([-2 * w, 0, 0])
					cube([3.5 * w, l, w]);
				translate([-w, 0, d1_mini_esp32_standoff + h + tolerance])
					linear_extrude(w / 2, scale = [1.5,1])
						square([w, l]);
				translate([-w, 0, d1_mini_esp32_standoff + h + w / 2 + tolerance])
					linear_extrude(1)
						square([1.5 * w, l]);

			}
			translate([-2 * w, -eps + d1_mini_esp32_reset_cutout, w])
				rotate([90, 0, 0])
					cylinder(h = 3 * d1_mini_esp32_length, r = w, center = true);
			translate([1.5 * w, -eps + d1_mini_esp32_reset_cutout, w])
				rotate([90, 0, 0])
					cylinder(h = 3 * d1_mini_esp32_length, r = w, center = true);
		}
	}

	translate([0, -eps, 0]) {
		translate([+0, d1_mini_esp32_length + tolerance, 0])
			rotate(-90)
				translate([0, -d1_mini_esp32_width / 4, 0])
					clip(d1_mini_esp32_width / 2, d1_mini_esp32_thickness + tolerance, 1.5 * wall);
		translate([w2 + tolerance, 0, 0])
			mirror([1, 0, 0])
				clip(d1_mini_esp32_length + eps, d1_mini_esp32_thickness, 1.5 * wall);
		translate([-w2 - tolerance, d1_mini_esp32_reset_cutout, 0])
			clip(d1_mini_esp32_length - d1_mini_esp32_reset_cutout + eps, d1_mini_esp32_thickness, 1.5 * wall);
	}
}
