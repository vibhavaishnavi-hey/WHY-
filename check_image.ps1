Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789200931724.png"
if (!(Test-Path $srcPath)) {
    Write-Host "Source not found: $srcPath"
    exit 1
}

$bmp = [System.Drawing.Bitmap]::FromFile($srcPath)
Write-Host "Image size: $($bmp.Width) x $($bmp.Height)"
$bmp.Dispose()
