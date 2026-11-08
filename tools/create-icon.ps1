Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = 'Stop'
$outputPath = Join-Path $PSScriptRoot '..\src\main\resources\assets\healthindicators\icon.png'
$outputPath = [System.IO.Path]::GetFullPath($outputPath)
New-Item -ItemType Directory -Force -Path (Split-Path -Parent $outputPath) | Out-Null

function New-RoundedPath([single]$X, [single]$Y, [single]$Width, [single]$Height, [single]$Radius) {
    $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
    $diameter = $Radius * 2
    $path.AddArc($X, $Y, $diameter, $diameter, 180, 90)
    $path.AddArc(($X + $Width - $diameter), $Y, $diameter, $diameter, 270, 90)
    $path.AddArc(($X + $Width - $diameter), ($Y + $Height - $diameter), $diameter, $diameter, 0, 90)
    $path.AddArc($X, ($Y + $Height - $diameter), $diameter, $diameter, 90, 90)
    $path.CloseFigure()
    return $path
}

function Fill-RoundedRectangle(
    [System.Drawing.Graphics]$Graphics,
    [System.Drawing.Brush]$Brush,
    [single]$X,
    [single]$Y,
    [single]$Width,
    [single]$Height,
    [single]$Radius
) {
    $path = New-RoundedPath $X $Y $Width $Height $Radius
    $Graphics.FillPath($Brush, $path)
    $path.Dispose()
}

function Draw-Heart(
    [System.Drawing.Graphics]$Graphics,
    [single]$CenterX,
    [single]$Top,
    [single]$Size,
    [System.Drawing.Color]$Color
) {
    $width = $Size
    $height = $Size * 0.84
    $points = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($CenterX, ($Top + $height)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.46), ($Top + $height * 0.55)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.47), ($Top + $height * 0.29)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.37), ($Top + $height * 0.10)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.19), ($Top + $height * 0.06)),
        [System.Drawing.PointF]::new($CenterX, ($Top + $height * 0.26)),
        [System.Drawing.PointF]::new(($CenterX + $width * 0.19), ($Top + $height * 0.06)),
        [System.Drawing.PointF]::new(($CenterX + $width * 0.37), ($Top + $height * 0.10)),
        [System.Drawing.PointF]::new(($CenterX + $width * 0.47), ($Top + $height * 0.29)),
        [System.Drawing.PointF]::new(($CenterX + $width * 0.46), ($Top + $height * 0.55))
    )

    $shadowBrush = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(100, 0, 0, 0))
    $shadowPoints = [System.Drawing.PointF[]]@(
        $points | ForEach-Object { [System.Drawing.PointF]::new(($_.X + 2), ($_.Y + 7)) }
    )
    $Graphics.FillPolygon($shadowBrush, $shadowPoints)
    $shadowBrush.Dispose()

    $fill = [System.Drawing.SolidBrush]::new($Color)
    $outline = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(230, 255, 244, 244), 2.5)
    $Graphics.FillPolygon($fill, $points)
    $Graphics.DrawPolygon($outline, $points)

    $shine = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(95, 255, 255, 255))
    $shinePoints = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new(($CenterX - $width * 0.29), ($Top + $height * 0.19)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.18), ($Top + $height * 0.14)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.07), ($Top + $height * 0.27)),
        [System.Drawing.PointF]::new(($CenterX - $width * 0.27), ($Top + $height * 0.37))
    )
    $Graphics.FillPolygon($shine, $shinePoints)
    $fill.Dispose()
    $outline.Dispose()
    $shine.Dispose()
}

$bitmap = [System.Drawing.Bitmap]::new(512, 512, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

$background = [System.Drawing.Rectangle]::new(0, 0, 512, 512)
$backgroundBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $background,
    [System.Drawing.Color]::FromArgb(20, 28, 50),
    [System.Drawing.Color]::FromArgb(37, 72, 114),
    35
)
$graphics.FillRectangle($backgroundBrush, $background)
$backgroundBrush.Dispose()

$glow = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(30, 115, 190, 255))
$graphics.FillEllipse($glow, 66, 52, 380, 380)
$glow.Dispose()

$framePath = New-RoundedPath 24 24 464 464 54
$framePen = [System.Drawing.Pen]::new([System.Drawing.Color]::FromArgb(175, 120, 196, 255), 8)
$graphics.DrawPath($framePen, $framePath)
$framePath.Dispose()
$framePen.Dispose()

Draw-Heart $graphics 148 118 82 ([System.Drawing.Color]::FromArgb(255, 76, 98, 255))
Draw-Heart $graphics 225 93 94 ([System.Drawing.Color]::FromArgb(255, 236, 73, 99))
Draw-Heart $graphics 305 118 82 ([System.Drawing.Color]::FromArgb(255, 236, 73, 99))
Draw-Heart $graphics 376 144 67 ([System.Drawing.Color]::FromArgb(255, 245, 187, 74))

$teal = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 92, 201, 190))
$lavender = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 153, 150, 241))
$skinLeft = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 54, 69, 98))
$skinRight = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 90, 70, 61))
$eyeWhite = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(235, 241, 247, 255))
$eyeDark = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 25, 37, 60))

Fill-RoundedRectangle $graphics $teal 105 300 142 126 28
Fill-RoundedRectangle $graphics $lavender 265 300 142 126 28
$graphics.FillRectangle($skinLeft, 132, 255, 88, 82)
$graphics.FillRectangle($skinRight, 292, 255, 88, 82)
$graphics.FillRectangle($eyeWhite, 150, 284, 12, 13)
$graphics.FillRectangle($eyeWhite, 190, 284, 12, 13)
$graphics.FillRectangle($eyeDark, 153, 288, 6, 7)
$graphics.FillRectangle($eyeDark, 193, 288, 6, 7)
$graphics.FillRectangle($eyeWhite, 310, 284, 12, 13)
$graphics.FillRectangle($eyeWhite, 350, 284, 12, 13)
$graphics.FillRectangle($eyeDark, 313, 288, 6, 7)
$graphics.FillRectangle($eyeDark, 353, 288, 6, 7)

$barBacking = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 49, 65, 91))
$barHealth = [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, 236, 73, 99))
Fill-RoundedRectangle $graphics $eyeWhite 176 375 160 23 10
Fill-RoundedRectangle $graphics $barBacking 183 381 146 11 5
Fill-RoundedRectangle $graphics $barHealth 183 381 92 11 5

$teal.Dispose()
$lavender.Dispose()
$skinLeft.Dispose()
$skinRight.Dispose()
$eyeWhite.Dispose()
$eyeDark.Dispose()
$barBacking.Dispose()
$barHealth.Dispose()
$graphics.Dispose()
$bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()

$image = [System.Drawing.Image]::FromFile($outputPath)
try {
    [pscustomobject]@{
        Path = $outputPath
        Width = $image.Width
        Height = $image.Height
        Bytes = (Get-Item -LiteralPath $outputPath).Length
        SHA256 = (Get-FileHash -LiteralPath $outputPath -Algorithm SHA256).Hash
    } | Format-List
}
finally {
    $image.Dispose()
}
