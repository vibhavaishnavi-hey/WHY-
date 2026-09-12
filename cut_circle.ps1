Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\ASUS\.gemini\antigravity-ide\brain\8b7de0d1-1845-4304-880b-8ab4e4545e12\.user_uploaded\media_1789202862756.jpg"
$destDir = "c:\Users\ASUS\WHY-\assets"
if (!(Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}
$destPath = Join-Path $destDir "pappadam.png"

$src = [System.Drawing.Bitmap]::FromFile($srcPath)
$w = $src.Width
$h = $src.Height

# Bounding box is X=[174, 848], Y=[22, 662]
# Center: cx = 511, cy = 342, half-size = 340
$cx = 511
$cy = 342
$half = 340

# Create high-res 680x680 canvas
$cropBmp = New-Object System.Drawing.Bitmap(680, 680, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)

# BFS flood fill on the cropped region
$visited = New-Object 'bool[,]' 680, 680
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

function IsWhite($r, $g, $b) {
    # Background white threshold
    return ($r -ge 243 -and $g -ge 243 -and $b -ge 238)
}

# Copy cropped pixels and seed borders
for ($y = 0; $y -lt 680; $y++) {
    for ($x = 0; $x -lt 680; $x++) {
        $sx = $cx - $half + $x
        $sy = $cy - $half + $y
        if ($sx -ge 0 -and $sx -lt $w -and $sy -ge 0 -and $sy -lt $h) {
            $p = $src.GetPixel($sx, $sy)
            $cropBmp.SetPixel($x, $y, $p)
        } else {
            $cropBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
            $visited[$x, $y] = $true
        }
    }
}

# Seed outer border
for ($x = 0; $x -lt 680; $x++) {
    $pTop = $cropBmp.GetPixel($x, 0)
    if (IsWhite $pTop.R $pTop.G $pTop.B) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, 0)))
        $visited[$x, 0] = $true
    }
    $pBot = $cropBmp.GetPixel($x, 679)
    if (IsWhite $pBot.R $pBot.G $pBot.B) {
        $queue.Enqueue((New-Object System.Drawing.Point($x, 679)))
        $visited[$x, 679] = $true
    }
}
for ($y = 0; $y -lt 680; $y++) {
    $pLeft = $cropBmp.GetPixel(0, $y)
    if (IsWhite $pLeft.R $pLeft.G $pLeft.B) {
        $queue.Enqueue((New-Object System.Drawing.Point(0, $y)))
        $visited[0, $y] = $true
    }
    $pRight = $cropBmp.GetPixel(679, $y)
    if (IsWhite $pRight.R $pRight.G $pRight.B) {
        $queue.Enqueue((New-Object System.Drawing.Point(679, $y)))
        $visited[679, $y] = $true
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
        if ($nx -ge 0 -and $nx -lt 680 -and $ny -ge 0 -and $ny -lt 680) {
            if (-not $visited[$nx, $ny]) {
                $p = $cropBmp.GetPixel($nx, $ny)
                if (IsWhite $p.R $p.G $p.B) {
                    $visited[$nx, $ny] = $true
                    $queue.Enqueue((New-Object System.Drawing.Point($nx, $ny)))
                }
            }
        }
    }
}

# Apply transparency to visited pixels
$transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)
for ($y = 0; $y -lt 680; $y++) {
    for ($x = 0; $x -lt 680; $x++) {
        if ($visited[$x, $y]) {
            $cropBmp.SetPixel($x, $y, $transparent)
        }
    }
}

# Resize to smooth high-definition 500x500
$finalBmp = New-Object System.Drawing.Bitmap(500, 500, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($finalBmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.DrawImage($cropBmp, 0, 0, 500, 500)
$g.Dispose()

$finalBmp.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Png)
Write-Output "Successfully saved round pappadam to: $destPath"

# Save base64 string
$bytes = [System.IO.File]::ReadAllBytes($destPath)
$b64 = [System.Convert]::ToBase64String($bytes)
[System.IO.File]::WriteAllText("c:\Users\ASUS\WHY-\pappadam_base64.txt", $b64)
Write-Output "Base64 length: $($b64.Length)"

$src.Dispose()
$cropBmp.Dispose()
$finalBmp.Dispose()
