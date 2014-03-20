avr=0.6;
rh=4;
rir=19/2-avr;
ty=2.55-2*avr;
ryr=rir+ty;
$fn=30;
spd=0.6;

module ff(){
	difference(){
		cylinder(r=ryr, h=rh);
		translate([0,0,-1]) cylinder(r=rir, h=rh+2);
	}
}

module ringprofil(){
	difference(){
		minkowski(){
			difference(){
				circle(r=rh/2);
				translate([-rh/2-1,ty/2,0]) square([2*rh,rh/2]);
				translate([-rh/2-1,-ty/2-rh/2,0]) square([2*rh,rh/2]);
			}
      // Avrunning
			circle(r=avr);
		}
    // Skåra
		translate([-1.1,ty/2-spd]) square([2.2,10]);
	}
}

module ringen_uten_tau(){
	rotate_extrude(convexity = 10)
		translate([ty/2+avr+rir, 0, 0])
			rotate([0,0,-90])
				ringprofil();
}
lt=0.06;
module tre_tau (rt=0.4){
	union(){
		translate([0,-rt-lt]) circle(r=rt);
		translate([cos(30)*(rt+lt),(rt+lt)/2]) circle(r=rt);
		translate([-cos(30)*(rt+lt),(rt+lt)/2]) circle(r=rt);
	}
}

module ringen(){
	union(){
		color("gold") scale([1.037,1.037,1.38]) translate([0,-10.5,0]) rotate([0,90,0]) tauringen();
		color("gold") ringen_uten_tau();
	}
}

module rotate_extrude_twist(){
  
}

radialRotation 	= 17	;// the number of times rotated into the hole in
axisRotation 	= 3	;// the number of times around the top of the torus
numberOfSpheres	= 200	;// number of spheres used to complete the knot
sphereQuality 	= 9	;// the larger the number, the lower the quality see
module gamle_tauringen() {
	union() {
		for ( i = [0:numberOfSpheres-1] ) {
			rotate( [0, 0, i*axisRotation*(360/numberOfSpheres)]) 
			 translate( [0, 70,5] ) {
				rotate( [i*radialRotation*(360/numberOfSpheres), 0,0]) 
				 translate( [0, 0, -5] ) {
					sphere(5,$fs=sphereQuality);
				 }
			 }
		}
	}
}

module tauringen(){
    import("da_definitive_tauring.stl", convexity=6);
}

//twist_ring(segs=21, twists=3, r=rir, $fn=10) tre_tau();
module twist_ring(segs = 60, twists=1, r=10){
  beta = 180/segs;
  h = 2*r*sin(180/segs)-0.2;
  //union(){
    for ( i = [0:segs-1] ) {
      rotate([0,0,i*360/segs])
        translate([r,0,0])
          rotate([90,0,-beta])
            rotate([0,0,i*twists*360/segs])
              linear_extrude(height=h, slices=4, 
                             twist=twists*360/segs) child(0); 
    }
  //}
}
//tauringen();
ringen($fn=160);
