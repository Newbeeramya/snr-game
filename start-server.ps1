# Simple HTTP Server for Avatar Blasting Game
# Run this script to start the HTTP server

$port = 8080
$url = "http://localhost:$port/"

Write-Host "Starting HTTP Server for Avatar Blasting Game..." -ForegroundColor Green
Write-Host "Server will be available at: $url" -ForegroundColor Yellow
Write-Host "Game URL: ${url}toy-picker.html" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Red
Write-Host ""

# Create HTTP Listener
Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

Write-Host "Server is running! Open your browser and go to:" -ForegroundColor Green
Write-Host "http://localhost:8080/toy-picker.html" -ForegroundColor White -BackgroundColor Blue

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/") {
            $localPath = "/toy-picker.html"
        }
        
        $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
        
        Write-Host "Request: $($request.Url)" -ForegroundColor Gray
        
        if (Test-Path $filePath) {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            
            # Set content type based on file extension
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $response.ContentType = "text/html; charset=utf-8" }
                ".css" { $response.ContentType = "text/css" }
                ".js" { $response.ContentType = "application/javascript" }
                ".png" { $response.ContentType = "image/png" }
                ".jpg" { $response.ContentType = "image/jpeg" }
                ".gif" { $response.ContentType = "image/gif" }
                default { $response.ContentType = "text/plain" }
            }
            
            $response.ContentLength64 = $buffer.Length
            $response.StatusCode = 200
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        } else {
            $response.StatusCode = 404
            $errorContent = "404 - File Not Found: $localPath"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorContent)
            $response.ContentLength64 = $buffer.Length
            $response.ContentType = "text/plain"
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        
        $response.OutputStream.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Server stopped." -ForegroundColor Red
}
