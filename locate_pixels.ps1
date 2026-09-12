Add-Type -AssemblyName System.Drawing
$img = [System.Drawing.Bitmap]::FromFile("c:\Users\ASUS\WHY-\assets\pappadam.png")
for ($y = 0; $y -lt $img.Height; $y++) {
    for ($x = 0; $x -lt $img.Width; $x++) {
        $p = $img.GetPixel($x, $y)
        if ($p.A -gt 0) {
            $diffRG = [Math]::Abs($p.R - $p.G)
            $diffGB = [Math]::Abs($p.G - $p.B)
            if ($diffRG -le 3 -and $diffGB -le 3 -and $p.R -ge 220) {
                Write-Output "x=$x y=$y : R=$($p.R) G=$($p.G) B=$($p.B)"
            }
        }
    }
}
$img.Dispose()
