@echo off
rem Coloca os icones das Venores FP e SP Potion (7 dias) no SpriteImage\en-ph\item.spr (posicoes 655 e 656)
rem Precisa do item.spr com caixas, baus e Venores 1k-6k ja aplicados. Backup: item.spr.bak_fpsp
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_fpsp.patch'; $ok='708be918bcb37197e8b2244395e5bf49';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja aplicado. Nada a fazer.'; exit 0 }" ^
 "if ($md5 -ne '88b51507c9889a78378dcb173e85a5f8') { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_fpsp') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icones 655 e 656 aplicados. Backup em item.spr.bak_fpsp' } else { Copy-Item ($spr + '.bak_fpsp') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
