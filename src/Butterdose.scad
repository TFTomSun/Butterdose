use <./Module.scad>
// Butterdosen-Parameter und beide Module in einer Datei
// Steuerung: Was soll angezeigt werden?
zeige_deckel = true;
deckel_umdrehen = true;
zeige_boden = true;

// Gemeinsame Variablen
butter_laenge = 95;
butter_breite = 72;
butter_hoehe = 38;
spielraum = 3;
wandstaerke = 1.5;

// Deckelmaße
deckel_innenlaenge = butter_laenge + 2 * spielraum;
deckel_aussenlaenge = deckel_innenlaenge + 2 * wandstaerke;
deckel_innenbreite = butter_breite + 2 * spielraum;
deckel_aussenbreite = deckel_innenbreite + 2 * wandstaerke;
deckel_hoehe = butter_hoehe + spielraum + wandstaerke; // eigentliche Deckelhöhe

// Bodenmaße (direkt aus Deckelmaßen berechnet)
boden_spiel = 0.1; // zusätzliches Spiel, damit Deckel gut passt
boden_aussenlaenge = deckel_innenlaenge - 2 * boden_spiel;
boden_aussenbreite = deckel_innenbreite - 2 * boden_spiel;
boden_hoehe = 7; // 7mm effektive Höhe
boden_bodenstaerke = 6.5; // 0,5cm Bodenstärke
deckelAuflagePosition = 3; // Höhe der Auflagefläche im Boden
deckelAuflageHoehe = 2; // Dicke der Auflagefläche im Boden
deckelAuflageBreite = 3;

// // Rast-Parameter
// rast_hoehe = 2; // Höhe der Rastnase
// rast_breite = 8; // Breite der Rastnase
// rast_tiefe = 0.5; // Wie weit die Nase herausragt

// module rastQuader(hoehe) {

//     rastVorichtung(hoehe, rast_breite, rast_tiefe, rast_hoehe, 
//     deckel_innenbreite, deckel_innenlaenge,wandstaerke);
// }


// Deckel-Modul
// Die geschlossene Seite (Deckeloberseite) liegt im Koordinatensystem unten (z=0)
// Die Öffnung zeigt nach oben (z=cover_height_extra)
// Der Schnitt zum Abtrennen der Überhöhe erfolgt nach dem Druck bei z=cover_height
module deckel() {
    Hohlquader( deckel_aussenlaenge,  deckel_aussenbreite,  deckel_hoehe,  wandstaerke, obenOffen=false);
}

// Boden-Modul
module boden() {

    Hohlquader( boden_aussenlaenge, boden_aussenbreite, boden_hoehe,  wandstaerke,1){
       translate([-wandstaerke, -wandstaerke, deckelAuflagePosition]) {
        cube([boden_aussenlaenge+deckelAuflageBreite, boden_aussenbreite+deckelAuflageBreite, deckelAuflageHoehe], center=false);
      }
    }
}

if (zeige_deckel){
  // Deckel umkehren wenn aktiviert, damit die geschlossene Seite unten ist
  Spiegeln("z",deckel_hoehe, deckel_umdrehen)
    deckel();
} 
if (zeige_boden) {
  if (zeige_deckel) {
    // Boden unter den Deckel verschieben, damit sie nicht kollidieren
    translate([-boden_aussenlaenge - 10, 0, 0])
      boden();
  } else {
    boden();
  }
}
