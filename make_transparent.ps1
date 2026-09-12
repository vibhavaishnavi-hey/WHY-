Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202114363.png"
$destDir = "c:\Users\ASUS\WHY-\assets"
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}
$destPath = Join-Path $destDir "pappadam.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$width = $src.Width
$height = $src.Height

$result = New-Object System.Drawing.Bitmap($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# Helper function to test if pixel is fake checkerboard
function IsCheckerboard($r, $g, $b) {
    if ($r -ge 210 -and $g -ge 210 -and $b -ge 210) {
        $diffRG = [Math]::Abs($r - $g)
        $diffGB = [Math]::Abs($g - $b)
        $diffRB = [Math]::Abs($r - $b)
        if ($diffRG -le 6 -and $diffGB -le 6 -and $diffRB -le 6) {
            return $true
        }
    }
    return $false
}

$visited = New-Object 'bool[,]' $width, $height
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

# Seed all 4 borders
for ($x = 0; $x -lt $width; $x++) {
    $pTop = $src.GetPixel($x, 0)
    if (IsCheckerboard $pTop.R $pTop.G $pTop.B) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, 0)))
        $visited[$x, 0] = $true
    }
    $pBot = $src.GetPixel($x, $height - 1)
    if (IsCheckerboard $pBot.R $pBot.G $pBot.B) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, $height - 1)))
        $visited[$x, $height - 1] = $true
    }
}
for ($y = 0; $y -lt $height; $y++) {
    $pLeft = $src.GetPixel(0, $y)
    if (IsCheckerboard $pLeft.R $pLeft.G $pLeft.B) {
        $queue.Enqueue((New-Object System.Drawing.Point(0, $y)))
        $visited[0, $y] = $true
    }
    $pRight = $src.GetPixel($width - 1, $y)
    if (IsCheckerboard $pRight.R $pRight.G $pRight.B) {
        $queue.Enqueue((New-Object System.Drawing.Point($width - 1, $y)))
        $visited[$width - 1, $y] = $true
    }
}

$dirs = @(
    (New-Object System.Drawing.Point(1, 0)),
    (New-Object System.Drawing.Point(-1, 0)),
    (New-Object System.Drawing.Point(0, 1)),
    (New-Object System.Drawing.Point(0, -1))
)

while ($queue.Count -gt 0) {
    $pt = $queue.Dequeue()
    foreach ($d in $dirs) {
        $nx = $pt.X + $d.X
        $ny = $pt.Y + $d.Y
        if ($nx -ge 0 -and $nx -lt $width -and $ny -ge 0 -and $ny -lt $height) {
            if (-not $visited[$nx, $ny]) {
                $p = $src.GetPixel($nx, $ny)
                if (IsCheckerboard $p.R $p.G $p.B) {
                    $visited[$nx, $ny] = $true
                    $queue.Enqueue((New-Object System.Drawing.Point($nx, $ny)))
                }
            }
        }
    }
}

# Now populate the result bitmap
$transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        if ($visited[$x, $y]) {
            $result.SetPixel($x, $y, $transparent)
        } else {
            $result.SetPixel($x, $y, $src.GetPixel($x, $y))
        }
    }
}

$result.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Host "Saved transparent image to: $destPath"

$src.Dispose()
$result.Dispose()
