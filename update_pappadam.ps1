Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\07d1f8b4-91f3-4192-a837-a81ba223b43f\.user_uploaded\media_1789204525786.png"
$destAssets = "c:\Users\ASUS\WHY-\assets\pappadam.png"
$destRoot = "c:\Users\ASUS\WHY-\pappadam.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)

$size = 720
$squareBmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($squareBmp)
$g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Center of the pappadam (531, 340) mapped to center of square canvas (360, 360)
$destX = 360 - 531
$destY = 360 - 340

$g.DrawImage($src, $destX, $destY, $src.Width, $src.Height)
$g.Dispose()
$src.Dispose()

$squareBmp.Save($destAssets, [System.Drawing.Imaging.ImageFormat]::Png)
$squareBmp.Save($destRoot, [System.Drawing.Imaging.ImageFormat]::Png)
$squareBmp.Dispose()

Write-Output "Successfully updated pappadam images to 720x720 square!"
