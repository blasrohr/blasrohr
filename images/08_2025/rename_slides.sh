#!/bin/bash

# Script um Folien mit Leerzeichen im Namen nach Zeitstempel zu sortieren und umzubenennen
# Usage: ./rename_slides.sh [ordner]

# Ordner festlegen (Standard: aktueller Ordner)
if [ "$1" ]; then
    TARGET_DIR="$1"
else
    TARGET_DIR="."
fi

# Prüfen ob Ordner existiert
if [ ! -d "$TARGET_DIR" ]; then
    echo "Fehler: Ordner '$TARGET_DIR' existiert nicht!"
    exit 1
fi

echo "Arbeite in Ordner: $TARGET_DIR"

# Wechseln in den Zielordner
cd "$TARGET_DIR" || exit 1

# Debug: Zeige alle PNG-Dateien
echo "=== Gefundene PNG-Dateien ==="
ls -la *.png 2>/dev/null || echo "Keine PNG-Dateien gefunden!"

# Prüfen ob Folie_*.png Dateien existieren
shopt -s nullglob  # Leere Expansion wenn keine Matches
files=(Folie_*.png)
if [ ${#files[@]} -eq 0 ]; then
    echo "Keine Dateien mit dem Pattern 'Folie_*.png' gefunden!"
    exit 1
fi

echo -e "\n=== Gefundene Folie-Dateien ==="
printf '%s\n' "${files[@]}"

# Temporären Ordner für Zwischenschritte erstellen
mkdir -p .temp_rename

# Array für sortierte Dateien erstellen (nach Änderungsdatum, neueste zuerst)
echo -e "\n=== Sortiere nach Datum ==="
IFS=$'\n' sorted_files=($(ls -t "Folie_"*.png 2>/dev/null))

# Counter für neue Dateinamen
counter=1

# Dateien umbenennen
echo -e "\n=== Umbenennung ==="
for file in "${sorted_files[@]}"; do
    if [ -f "$file" ]; then
        echo "Benenne '$file' um in '$counter.png'"
        
        # Erst in temporären Ordner verschieben, um Konflikte zu vermeiden
        mv "$file" ".temp_rename/$counter.png"
        
        ((counter++))
    fi
done

# Alle Dateien aus dem temporären Ordner zurück ins Hauptverzeichnis
if [ -d ".temp_rename" ]; then
    mv .temp_rename/*.png . 2>/dev/null
    rmdir .temp_rename 2>/dev/null
fi

echo -e "\nFertig! $((counter-1)) Dateien umbenannt."
echo -e "\n=== Ergebnis ==="
ls -la [0-9]*.png 2>/dev/null | head -10