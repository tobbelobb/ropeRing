avr=0.5;
rir=19/2-avr;
ty=1.8-2*avr;
ryr=rir+ty;
$fn=30;
spd=0.3;
bignum=100;

module ringprofil(sb, rh){
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
		translate([-sb/2,ty/2-spd]) square([sb,10]);
	}
}

module ringprofil2(sb, rh){
  cr=7;
  difference(){
    union(){
      minkowski(){
        difference(){
          circle(r=rh/2);
          translate([-rh/2-1,ty/2,0]) square([2*rh,rh/2]);
          translate([-rh/2-1,-ty/2-rh/2,0]) square([2*rh,rh/2]);
        }
        // Avrunning
        circle(r=avr);
      }
      translate([0,-cr+(cr-sqrt(cr*cr-(rh/2)*(rh/2)))+ty/2+avr])
      difference(){
        circle(r=cr, $fn=200);
        translate([rh/2,-bignum/2]) square([bignum, bignum]);
        translate([-bignum-rh/2,-bignum/2]) square([bignum, bignum]);
        translate([-bignum/2,-bignum+5.65]) 
          square([100, 100]);
      }
    }
  // Skåra
  translate([-sb/2,ty/2-spd]) square([sb,10]);
  }
}


module ringen_uten_tau(sb, rh){
	rotate_extrude(convexity = 10)
		translate([ty/2+avr+rir, 0, 0])
			rotate([0,0,-90])
				ringprofil2(sb, rh);
}

// hf = høydefaktor, tauringen
// sb = sporbredde, det tauringen ligger i
// rh = ringhöyde (ikke inkludert avrunning med 0.4 mm radie)
module ringen(hf, sb, rh){
	union(){
		color("gold") scale([0.980,0.980,hf]) translate([0,-10.5,0]) rotate([0,90,0]) tauringen();
		color("gold") ringen_uten_tau(sb, rh);
	}
}

module tauringen(){
    import("da_definitive_tauring.stl", convexity=6);
}

//ringprofil2(1.7);
//tauringen();
// Torbjørns ring
translate([25,0,0])
ringen(hf=1.3,$fn=160, sb=2.1, rh=4.0);
// Majas ring
ringen(hf=1.13,$fn=160, sb=1.7, rh=3.5);
