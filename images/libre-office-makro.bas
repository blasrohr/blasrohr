Sub ExportCurrentSlideToDownloads()
    Dim oDoc As Object
    Dim oCurrentSlide As Object
    Dim sExportPath As String
    Dim sHomeDir As String
    Dim sTimeStamp As String
    
    oDoc = ThisComponent
    
    ' Dokument gespeichert?
    If oDoc.getURL() = "" Then
        MsgBox "Bitte Präsentation zuerst speichern!"
        Exit Sub
    End If
    
    ' Aktuelle Folie
    oCurrentSlide = oDoc.getCurrentController().getCurrentPage()
    
    ' Linux Home-Verzeichnis ermitteln
    sHomeDir = Environ("HOME")
    
    ' Zeitstempel für eindeutigen Dateinamen
    sTimeStamp = Format(Now(), "yyyy-mm-dd_hh-mm-ss")
    
    ' Export-Pfad zusammensetzen (Linux-Style)
    sExportPath = "file://" & sHomeDir & "/Downloads/Folie_" & sTimeStamp & ".png"
    
    ' Export ausführen
    Dim aArgs(2) As New com.sun.star.beans.PropertyValue
    aArgs(0).Name = "URL"
    aArgs(0).Value = sExportPath
    aArgs(1).Name = "MediaType"
    aArgs(1).Value = "image/png"
    aArgs(2).Name = "FilterName"
    aArgs(2).Value = "impress_png_Export"
    
    Dim oExporter As Object
    oExporter = CreateUnoService("com.sun.star.drawing.GraphicExportFilter")
    oExporter.setSourceDocument(oCurrentSlide)
    
    If oExporter.filter(aArgs) Then
        MsgBox "Folie exportiert nach ~/Downloads/Folie_" & sTimeStamp & ".png"
    Else
        MsgBox "Export fehlgeschlagen!"
    End If
End Sub