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

module Hohlquader(aussenLaenge, aussenBreite, aussenHoehe, wandstaerke, tiefe = 0, obenOffen = true  ) {
  difference() {
    // Außenquader
    union() {
    cube([aussenLaenge, aussenBreite, aussenHoehe], center=false);
    children();
    }
    // Innenquader
    tiefeFinal = tiefe == 0 ? wandstaerke:tiefe;
    hoeheFinal = obenOffen == true ?  (tiefeFinal) : (aussenHoehe - tiefeFinal);
    positionZ = obenOffen == true ? aussenHoehe-tiefeFinal : -tiefeFinal;
    translate([wandstaerke, wandstaerke, positionZ])
      cube([aussenLaenge - 2 * wandstaerke, aussenBreite - 2 * wandstaerke, hoeheFinal+1], center=false);
  }
}

module rastVorichtung(hoehe,rast_breite, rast_tiefe, rast_hoehe, ziel_breite, ziel_laenge,wandstaerke) {
  // Rasteinsparungen: 4 Aussparungen an den Seiten, innen, auf Höhe rast_deckel_z
  versatz = 0.4;

  // Rasteinparungen in y-richtung
  VolumenKoerper(rast_breite, "yz", ziel_laenge / 2) {
    translate([wandstaerke - rast_tiefe, hoehe, 0])
      Trapez(ziel_breite + 2 * rast_tiefe, rast_hoehe, versatz);
  }
  // Rasteinparungen in x-richtung
  VolumenKoerper(rast_breite, "xz", -ziel_breite / 2) {
    translate([wandstaerke - rast_tiefe, hoehe, 0])
      Trapez(ziel_laenge + 2 * rast_tiefe, rast_hoehe, versatz);
  }
}
