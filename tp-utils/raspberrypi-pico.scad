module raspberrypi_pico_pins(l, w) {
	yo = [-w/2, -w/2 + 1.27, "", w/2 - 1.27, w/2];
	for (x = [1:20], y = [-2,-1,1,2])
		translate([2.54 * x - 1.27, yo[y + 2], 0])
			children($row = y);
}

module raspberrypi_pico() {
	l = 51;
	w = 21;
	h = 1;
	eps = 0.01;
	
	if ($preview) {
		difference() {
			union() {
				color("green")
				translate([0, -w/2, 0]) cube([l, w, h]);
				
				color("gold")
				raspberrypi_pico_pins(l, w) {
					s = sign($row);
					translate([0, 0, -eps])
						if (abs($row) == 1)
							cylinder(d = 1.6, h = h + 2 * eps);
						else
							translate([0, s * (-1.27/2 + eps), h / 2 + eps])
								cube([1.6, 1.27, h + 2 * eps], center = true);
					}
				color("silver") translate([-1, -4, h - eps])
					cube([6, 8, 2]);
				color("silver") translate([33, -6, h - eps])
					cube([10, 12, 2]);
				color("black") translate([20, -4, h - eps])
					cube([8, 8, 2]);
				color("silver") translate([9, -6, h - eps])
					cube([4, 3, 2]);
				color("white") translate([11, -4.5, h - eps])
					cylinder(r = 1, h = 3);
			}

			color("gold")
			raspberrypi_pico_pins(l, w)
				cylinder(d = 1, h = 5 * h, center = true);
		}
	}
}
