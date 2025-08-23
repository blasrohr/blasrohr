#!/bin/bash

# Super einfache Version - sortiert Folien nach Zeitstempel im Dateinamen
# Format: Folie_2025-08-22  16-39-57.png
# ÄLTESTE wird zu 1.png

echo "=== Gefundene Folie-Dateien ==="
ls -1 Folie_*.png 2>/dev/null || { echo "Keine Folie_*.png Dateien gefunden!"; exit 1; }

# Erstelle temporäre Datei mit Zeitstempel-Extraktion
temp_file="/tmp/folie_sort_$$"

echo -e "\n=== Erstelle Sortier-Liste ==="
for file in Folie_*.png; do
    if [ -f "$file" ]; then
        # Extrahiere Zeitstempel: Folie_2025-08-22  16-39-57.png
        # Entferne "Folie_" und ".png"
        timestamp="${file#Folie_}"
        timestamp="${timestamp%.png}"
        
        # Ersetze Leerzeichen und Bindestriche für bessere Sortierung
        # 2025-08-22  16-39-57 wird zu 20250822163957
        sortable=$(echo "$timestamp" | sed 's/[- ]//g')
        
        echo "Datei: $file -> Sortkey: $sortable"
        echo "$sortable|$file" >> "$temp_file"
    fi
done

# Sortiere nach Zeitstempel (älteste zuerst - OHNE -r)
echo -e "\n=== Sortiere (älteste zuerst) ==="
sort -t'|' -k1,1 -n "$temp_file" > "${temp_file}_sorted"

# Temporären Ordner erstellen
mkdir -p .temp_rename

# Dateien umbenennen
counter=1
echo -e "\n=== Umbenennung ==="
while IFS='|' read -r sortkey filename; do
    if [ -f "$filename" ]; then
        echo "[$counter] $filename (Zeitstempel: $sortkey) -> $counter.png"
        mv "$filename" ".temp_rename/$counter.png"
        ((counter++))
    fi
done < "${temp_file}_sorted"

# Dateien zurück ins Hauptverzeichnis
mv .temp_rename/*.png . 2>/dev/null
rmdir .temp_rename 2>/dev/null

# Aufräumen
rm -f "$temp_file" "${temp_file}_sorted"

echo -e "\nFertig! $((counter-1)) Dateien sortiert nach Dateinamen-Zeitstempel."
echo -e "Älteste Folie (18-11-22) ist jetzt 1.png"
echo -e "\n=== Ergebnis ==="
ls -la [0-9]*.png 2>/dev/null