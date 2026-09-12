Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$img = [System.Drawing.Bitmap]::FromFile($imgPath)

# Sample top-left 30x30 pixels
for ($y = 0; $y -lt 25; $y += 5) {
    $line = ""
    for ($x = 0; $x -lt 35; $x += 5) {
        $p = $img.GetPixel($x, $y)
        $line += "$($p.R),$($p.G),$($p.B) "
    }
    Write-Output "y=${y} : $line"
}
$img.Dispose()
