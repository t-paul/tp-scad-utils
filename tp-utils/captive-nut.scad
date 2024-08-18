$fa = 2; $fs = 0.2;

eps = 0.01;
wall = 2.4;
tolerance = 0.2;

m2_hole_dia = 2.2;
m2_head_dia = 4.2;
m2_head_length = 1.6;

m3_hole_dia = 3.4;
m3_head_dia = 6;
m3_head_length = 2.2;

module captive_nut_base(d, h, o, w, wh, tolerance = 0.2, layer = 0.2) {
	translate([0, 0, -tolerance]) cylinder(d = d + 2 * tolerance, h = h + 2 * tolerance);
	translate([0, 0, o])
		linear_extrude(wh + tolerance)
			offset(tolerance)
				circle(d = w, $fn = 6);
	translate([0, 0, o + wh + tolerance - layer])
		linear_extrude(2 * layer)
				square([w/2, sqrt(3)/2*w + 2* tolerance], center = true);
}

module captive_nut_m2(h, o, wh, tolerance = 0.2, layer = 0.2) {
    captive_nut_base(m2_hole_dia, h, o, m2_head_dia + 2 * tolerance, m2_head_length + 2 * tolerance, tolerance = tolerance, layer = layer);
}

module captive_nut_m3(h, o, tolerance = 0.2, layer = 0.2) {
    captive_nut_base(m3_hole_dia, h, o, m3_head_dia + 2 * tolerance, m3_head_length + 2 * tolerance, tolerance = tolerance, layer = layer);
}
