@echo off
rem Restaura os icones das caixas, baus e Venores Potion no SpriteImage\en-ph\item.spr (o auto-update voltou o arquivo original)
rem Fica nesta pasta junto com item_spr_restaura.patch. Backup: item.spr.bak_restaura
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_restaura.patch'; $ok='88b51507c9889a78378dcb173e85a5f8';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja esta certo. Nada a fazer.'; exit 0 }" ^
 "if ($md5 -ne 'b44e5625551763de36796a5d52e062e6') { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_restaura') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icones 640 a 654 restaurados. Backup em item.spr.bak_restaura' } else { Copy-Item ($spr + '.bak_restaura') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
