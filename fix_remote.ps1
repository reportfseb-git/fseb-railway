# fix_remote.ps1
Write-Host "🔧 Fixing Git Remote Configuration" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

Write-Host "`nCurrent remotes:" -ForegroundColor Yellow
git remote -v

Write-Host "`nUpdating 'origin' to new repository..." -ForegroundColor Green
git remote set-url origin https://github.com/reportfseb-git/fseb-railway2.git

Write-Host "`nUpdated remotes:" -ForegroundColor Yellow
git remote -v

Write-Host "`nPushing to new repository..." -ForegroundColor Green
git push -u origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nPush failed. Trying force push..." -ForegroundColor Red
    git push -f origin main
}

Write-Host "`n✅ Done!" -ForegroundColor Green
Write-Host "Your repository is now at: https://github.com/reportfseb-git/fseb-railway2.git" -ForegroundColor Cyan