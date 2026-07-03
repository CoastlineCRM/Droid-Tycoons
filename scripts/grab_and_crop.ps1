# grab_and_crop.ps1
# Grab the current clipboard image and crop/center/resize it into a
# 195x188 black-background droid thumbnail that matches the Droidex art set.
#
# Usage:  powershell -STA -File scripts\grab_and_crop.ps1 -Name "SNOW MOUSE" [-Finish DEFAULT]
# Output: droids\<NAME>_<FINISH>.png   (spaces in NAME become underscores)

param(
  [Parameter(Mandatory=$true)][string]$Name,
  [string]$Finish = "DEFAULT"
)

Add-Type -AssemblyName System.Drawing

$root   = Split-Path $PSScriptRoot -Parent
$outDir = Join-Path $root "droids"
$file   = ($Name.ToUpper() -replace ' ','_') + "_" + $Finish.ToUpper() + ".png"
$outPath = Join-Path $outDir $file

$img = Get-Clipboard -Format Image
if ($null -eq $img) { Write-Output "NO_IMAGE_IN_CLIPBOARD"; exit 1 }
$img = [System.Drawing.Bitmap]$img

$targetW = 195; $targetH = 188; $fill = 0.94; $thresh = 48; $step = 2
$w = $img.Width; $h = $img.Height
$minX=$w; $minY=$h; $maxX=0; $maxY=0
for ($y=0; $y -lt $h; $y+=$step) {
  for ($x=0; $x -lt $w; $x+=$step) {
    $p = $img.GetPixel($x,$y)
    if (($p.R + $p.G + $p.B) -gt $thresh) {
      if ($x -lt $minX){$minX=$x}; if ($x -gt $maxX){$maxX=$x}
      if ($y -lt $minY){$minY=$y}; if ($y -gt $maxY){$maxY=$y}
    }
  }
}
if ($maxX -le $minX) { Write-Output "NO_CONTENT_FOUND"; exit 1 }

$bw=$maxX-$minX; $bh=$maxY-$minY
$mx=[int]($bw*0.04); $my=[int]($bh*0.04)
$minX=[Math]::Max(0,$minX-$mx); $minY=[Math]::Max(0,$minY-$my)
$maxX=[Math]::Min($w-1,$maxX+$mx); $maxY=[Math]::Min($h-1,$maxY+$my)
$cw=$maxX-$minX; $ch=$maxY-$minY

$out = New-Object System.Drawing.Bitmap($targetW,$targetH)
$g = [System.Drawing.Graphics]::FromImage($out)
$g.Clear([System.Drawing.Color]::Black)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$scale = [Math]::Min(($targetW*$fill)/$cw, ($targetH*$fill)/$ch)
$dw=[int]($cw*$scale); $dh=[int]($ch*$scale)
$dx=[int](($targetW-$dw)/2); $dy=[int](($targetH-$dh)/2)
$g.DrawImage($img,
  (New-Object System.Drawing.Rectangle($dx,$dy,$dw,$dh)),
  (New-Object System.Drawing.Rectangle($minX,$minY,$cw,$ch)),
  [System.Drawing.GraphicsUnit]::Pixel)
$g.Dispose()
$out.Save($outPath,[System.Drawing.Imaging.ImageFormat]::Png)
$out.Dispose(); $img.Dispose()
Write-Output "SAVED $file  (bbox ${cw}x${ch} -> scaled ${dw}x${dh})"
