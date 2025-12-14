// Butterdosen-Parameter und beide Module in einer Datei
// Steuerung: Was soll angezeigt werden?
zeige_deckel = false;
zeige_boden = true;

// Gemeinsame Variablen
butter_laenge = 95;
butter_breite = 72;
butter_hoehe = 38;
spielraum = 3;
wandstaerke = 1.5;

// Deckelmaße
deckel_innenlaenge = butter_laenge + 2*spielraum;
deckel_aussenlaenge = deckel_innenlaenge+ 2*wandstaerke;
deckel_innenbreite = butter_breite + 2*spielraum;
deckel_aussenbreite  = deckel_innenbreite + 2*wandstaerke;
deckel_hoehe = butter_hoehe + spielraum + wandstaerke; // eigentliche Deckelhöhe

// Bodenmaße (direkt aus Deckelmaßen berechnet)
boden_spiel = 0.1; // zusätzliches Spiel, damit Deckel gut passt
boden_aussenlaenge = deckel_innenlaenge - 2*boden_spiel;
boden_aussenbreite  = deckel_innenbreite- 2*boden_spiel;
boden_hoehe = 7; // 7mm effektive Höhe
boden_bodenstaerke = 5; // 0,5cm Bodenstärke

// Rast-Parameter
rast_hoehe = 2; // Höhe der Rastnase
rast_breite = 8; // Breite der Rastnase
rast_tiefe = 0.5; // Wie weit die Nase herausragt
rast_boden_z = 5; // Position am Boden: 0,5cm
rast_deckel_z = 6; // Position im Deckel: 0,6cm (von unten, da Deckel verkehrt)

// Modul für eine einzelne Rasteinsparung im Deckel
module rastaussparung() {
    cube([rast_breite, rast_tiefe, rast_hoehe], center=false);
}

// Deckel-Modul
// Die geschlossene Seite (Deckeloberseite) liegt im Koordinatensystem unten (z=0)
// Die Öffnung zeigt nach oben (z=cover_height_extra)
// Der Schnitt zum Abtrennen der Überhöhe erfolgt nach dem Druck bei z=cover_height
module deckel() {
    difference() {
        // Außen: Quader mit geschlossener Unterseite bei z=0
        cube([deckel_aussenlaenge, deckel_aussenbreite, deckel_hoehe], center=false);
        // Innen: Von oben nach unten ausgeschnitten, sodass unten geschlossen bleibt
        // Die innere Aussparung beginnt bei z=wandstaerke und reicht bis ganz nach oben
        translate([wandstaerke, wandstaerke, wandstaerke])
            cube([deckel_aussenlaenge-2*wandstaerke, deckel_aussenbreite-2*wandstaerke, deckel_hoehe], center=false);
        // Die Schnittkante für die finale Deckelhöhe ist bei z=cover_height
        // (Das kann nach dem Druck einfach abgeschnitten werden)

        rastQuader(deckel_hoehe);
             
    }
}

module rastQuader(hoehe){
     // Rasteinsparungen: 4 Aussparungen an den Seiten, innen, auf Höhe rast_deckel_z
        // Rasteinparungen in y-richtung
        translate([(deckel_innenlaenge- rast_breite)/2, wandstaerke- rast_tiefe, hoehe-rast_hoehe-2])
            cube([rast_breite, deckel_innenbreite+ 2* rast_tiefe, rast_hoehe], center=false);
        // Rasteinparungen in x-richtung
        translate([ wandstaerke- rast_tiefe,(deckel_innenbreite- rast_breite)/2, hoehe-rast_hoehe-2])
            cube([ deckel_innenlaenge+ 2* rast_tiefe, rast_breite, rast_hoehe], center=false);

}


// Boden-Modul
module boden() {
    intersection() {
        union() {
            translate([wandstaerke,wandstaerke,0]){
            difference() {
                // Außen: Hohlquader
                cube([boden_aussenlaenge, boden_aussenbreite, boden_hoehe], center=false);
                // Innen: Seitenwände 1,5mm, Boden 0,5cm dick
                translate([wandstaerke, wandstaerke, boden_bodenstaerke])
                    cube([boden_aussenlaenge-2*wandstaerke, boden_aussenbreite-2*wandstaerke, boden_hoehe], center=false);
            }
            }

            rastQuader(5);
        }
        // Schnitt auf 0,7cm Höhe
        //cube([boden_aussenlaenge, boden_aussenbreite, boden_hoehe], center=false);
    }
}


if (zeige_deckel) deckel();
if (zeige_boden) {
    if(zeige_deckel){
        // Boden unter den Deckel verschieben, damit sie nicht kollidieren
         translate([-boden_aussenlaenge-10, 0, 0])
            boden();
    }else{
        boden();
    }
}

