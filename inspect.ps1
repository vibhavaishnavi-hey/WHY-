Add-Type -AssemblyName System.Drawing
$imgPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$img = [System.Drawing.Bitmap]::FromFile($imgPath)
Write-Output ("PixelFormat: " + $img.PixelFormat)
Write-Output ("Size: " + $img.Width + "x" + $img.Height)
$corner = $img.GetPixel(0, 0)
Write-Output ("Corner: R=" + $corner.R + " G=" + $corner.G + " B=" + $corner.B + " A=" + $corner.A)
$img.Dispose()
