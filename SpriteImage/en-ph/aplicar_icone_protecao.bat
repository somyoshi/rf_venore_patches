@echo off
rem Coloca o icone da Pocao de Protecao (talic) no SpriteImage\en-ph\item.spr (posicao 657)
rem Precisa do item.spr com caixas, baus, Venores e FP/SP ja aplicados. Backup: item.spr.bak_protecao
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_protecao.patch'; $ok='e0434b29823f0ec45d9c2e4ebbde966b';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja aplicado. Nada a fazer.'; exit 0 }" ^
 "if ($md5 -ne '708be918bcb37197e8b2244395e5bf49') { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_protecao') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icone 657 (Pocao de Protecao) aplicado. Backup em item.spr.bak_protecao' } else { Copy-Item ($spr + '.bak_protecao') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
