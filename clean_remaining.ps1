Add-Type -AssemblyName System.Drawing
$destPath = "c:\Users\ASUS\WHY-\assets\pappadam.png"
$bmp = [System.Drawing.Bitmap]::FromFile($destPath)
$transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)

$count = 0
for ($y = 0; $y -lt $bmp.Height; $y++) {
    for ($x = 0; $x -lt $bmp.Width; $x++) {
        $p = $bmp.GetPixel($x, $y)
        if ($p.A -gt 0) {
            $diffRG = [Math]::Abs($p.R - $p.G)
            $diffGB = [Math]::Abs($p.G - $p.B)
            # Exactly matches the two checkerboard colors 255 and 239, or near-identical gray
            if ($diffRG -le 3 -and $diffGB -le 3 -and $p.R -ge 220) {
                $bmp.SetPixel($x, $y, $transparent)
                $count++
            }
        }
    }
}
$tmpPath = "c:\Users\ASUS\WHY-\assets\pappadam_clean.png"
$bmp.Save($tmpPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Move-Item -Path $tmpPath -Destination $destPath -Force
Write-Output "Cleared $count remaining checkerboard pixels."
