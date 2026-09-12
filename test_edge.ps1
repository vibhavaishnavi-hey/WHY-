Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$img = [System.Drawing.Bitmap]::FromFile($imgPath)

# Check line x=30 from y=0 to y=50
for ($y = 0; $y -le 40; $y++) {
    $p = $img.GetPixel(30, $y)
    $diffRG = [Math]::Abs($p.R - $p.G)
    $diffGB = [Math]::Abs($p.G - $p.B)
    Write-Output "y=$($y): R=$($p.R) G=$($p.G) B=$($p.B) | diffRG=$diffRG diffGB=$diffGB"
}
$img.Dispose()
