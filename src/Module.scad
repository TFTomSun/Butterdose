module Ausrichten(basisFlaeche = "xy") {
  if (basisFlaeche == "yz") {
    rotate([90, 0, 90]) {
      children();
    }
  } else if (basisFlaeche == "xz") {
    rotate([90, 0, 0])
      children();
  } else if (basisFlaeche == "xy") {
    children();
  }
}
module Aushoehlen(wandstaerke){
  difference() {
    children();
    translate([wandstaerke, wandstaerke, wandstaerke])
    
     children(index);
      cube([  // Innenraum
        children_bbox().x - 2 * wandstaerke,
        children_bbox().y - 2 * wandstaerke,
        children_bbox().z - wandstaerke
      ], center=false);
  }
}
module Trapez(breite, hoehe, versatz = 0) {

      polygon(
        [
          [0, 0], // unten links
          [breite, 0], // unten rechts
          [breite - versatz, hoehe], // oben rechts
          [versatz, hoehe], // oben links
        ]
      );
}

module Spiegeln(achse = "y", offset = 0, active = true) {

  if (active) {

    spiegelWerte = achse == "x" ? [1, 0, 0] : achse == "y" ? [0, 1, 0] : [0, 0, 1];
    verschiebeWerte = achse == "x" ? [-offset, 0, 0] : achse =="y" ? [0, -offset, 0]: [0, 0, -offset];

    // Deckel umkehren, damit die geschlossene Seite unten ist
    mirror(spiegelWerte)
      translate(verschiebeWerte)
        children();
  } else {
    children();
  }
}

module VolumenKoerper(volumenTiefe, basisFlaeche = "xy", tiefenVersatz = 0) {

  Ausrichten(basisFlaeche) {
    translate([0, 0, tiefenVersatz])
      linear_extrude(height=volumenTiefe, center=true) {
        children();
      }
  }
}
