$fa = 2; $fs = 0.2;

eps = 0.01;
wall = 2.4;
tolerance = 0.2;

sizes = object([
    // Metric Dia
    // 0: Hole Diameter
    // 1: Thread Pitch
    // 2/3: Width Across Flats (max/min)
    // 4/5: Width Across Corners (max/min)
    // 6/7: Thickness (max/min)
    // 8: Bearing Face

    [ "M1.6", [ 1.8, 0.35, 3.20, 3.02, 3.70, 3.41, 1.30, 1.05, 2.3 ] ],
    [ "M2",   [ 2.4, 0.40, 4.00, 3.82, 4.62, 4.32, 1.60, 1.35, 3.1 ] ],
    [ "M2.5", [ 2.9, 0.45, 5.00, 4.82, 5.77, 5.45, 2.00, 1.75, 4.1 ] ],
    [ "M3",   [ 3.4, 0.50, 5.50, 5.32, 6.35, 6.01, 2.40, 2.15, 4.6 ] ],
    [ "M3.5", [ 4.0, 0.60, 6.00, 5.82, 6.93, 6.58, 2.80, 2.55, 5.1 ] ],
    [ "M4",   [ 4.5, 0.70, 7.00, 6.78, 8.08, 7.66, 3.20, 2.90, 6.0 ] ],
]);

thread_hole = function(dia) sizes[dia][0];
thread_pitch = function(dia) sizes[dia][1];
thread_width = function(dia) sizes[dia][4];
thread_thickness = function(dia) sizes[dia][6];

m2_hole_dia = 2.2;
m2_head_dia = 4.4;
m2_head_length = 1.7;

m2_5_hole_dia = 2.8;
m2_5_head_dia = 5.4;
m2_5_head_length = 2.4;

m3_hole_dia = 3.4;
m3_head_dia = 6;
m3_head_length = 2.6;

module captive_nut_base(d, h, o, w, wh, tolerance = 0.2, layer = 0.2) {
    // The screw hole
	translate([0, 0, -tolerance])
        cylinder(d = d + 2 * tolerance, h = h + 2 * tolerance);
    // The nut trap
	translate([0, 0, o])
		linear_extrude(wh + tolerance)
			offset(tolerance)
				circle(d = w, $fn = 6);
    // Bridging helper
	translate([0, 0, o + wh + tolerance - layer])
		linear_extrude(2 * layer)
				square([w/2, sqrt(3)/2*w + 2* tolerance], center = true);
}

module captive_nut_metric(metric, h, o, tolerance = 0.2, layer = 0.2) {
    captive_nut_base(
        thread_hole(metric),
        h,
        o,
        thread_width(metric),
        thread_thickness(metric),
        tolerance = tolerance,
        layer = layer);
}

module captive_nut_m2(h, o, tolerance = 0.2, layer = 0.2) {
    captive_nut_metric("M2", h, o, tolerance, layer);
}

module captive_nut_m2_5(h, o, tolerance = 0.2, layer = 0.2) {
    captive_nut_metric("M2.5", h, o, tolerance, layer);
}

module captive_nut_m3(h, o, tolerance = 0.2, layer = 0.2) {
    captive_nut_metric("M3", h, o, tolerance, layer);
}
