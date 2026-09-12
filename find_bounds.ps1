Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202862756.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$w = $src.Width
$h = $src.Height

$minX = $w; $maxX = 0; $minY = $h; $maxY = 0

# A pixel is background if it is very close to white: R > 248 and G > 248 and B > 248
for ($y = 0; $y -lt $h; $y += 2) {
    for ($x = 0; $x -lt $w; $x += 2) {
        $p = $src.GetPixel($x, $y)
        if ($p.R -lt 245 -or $p.G -lt 245 -or $p.B -lt 240) {
            if ($x -lt $minX) { $minX = $x }
            if ($x -gt $maxX) { $maxX = $x }
            if ($y -lt $minY) { $minY = $y }
            if ($y -gt $maxY) { $maxY = $y }
        }
    }
}

Write-Output "Pappadam Bounding Box: X=[$minX, $maxX] Y=[$minY, $maxY]"
Write-Output "Width=$($maxX - $minX) Height=$($maxY - $minY)"

$src.Dispose()
