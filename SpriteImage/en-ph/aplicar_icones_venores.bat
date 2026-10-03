@echo off
rem Coloca os icones das Venores Potion 1k a 6k no SpriteImage\en-ph\item.spr (posicoes 649 a 654)
rem Copie este .bat e o item_spr_venores.patch para a pasta SpriteImage\en-ph e execute. Backup: item.spr.bak_venores
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_venores.patch'; $ok='88b51507c9889a78378dcb173e85a5f8';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja aplicado. Nada a fazer.'; exit 0 }" ^
 "if ($md5 -ne 'b80b0549f16ce95216fddd7850a357bc') { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_venores') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icones 649 a 654 aplicados. Backup em item.spr.bak_venores' } else { Copy-Item ($spr + '.bak_venores') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
