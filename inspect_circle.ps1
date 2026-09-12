Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202862756.jpg"
$src = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Output "Size: $($src.Width) x $($src.Height)"

$c = $src.GetPixel(0, 0)
Write-Output "Corner (0,0): R=$($c.R) G=$($c.G) B=$($c.B)"
$c2 = $src.GetPixel(10, 10)
Write-Output "Corner (10,10): R=$($c2.R) G=$($c2.G) B=$($c2.B)"

$src.Dispose()
