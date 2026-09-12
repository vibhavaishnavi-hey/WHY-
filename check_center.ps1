Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$img = [System.Drawing.Bitmap]::FromFile($imgPath)

$suspiciousInside = 0
# Look in the central area of the pappadam stack (x from 100 to 260, y from 60 to 220)
for ($y = 60; $y -le 220; $y++) {
    for ($x = 100; $x -le 260; $x++) {
        $p = $img.GetPixel($x, $y)
        $diffRG = [Math]::Abs($p.R - $p.G)
        $diffGB = [Math]::Abs($p.G - $p.B)
        if ($p.R -ge 220 -and $p.G -ge 220 -and $p.B -ge 220 -and $diffRG -le 5 -and $diffGB -le 5) {
            $suspiciousInside++
        }
    }
}
Write-Output "Suspicious pixels inside central area: $suspiciousInside"
$img.Dispose()
