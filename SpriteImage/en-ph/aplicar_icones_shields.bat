@echo off
rem Coloca os icones novos dos shields 57/60/63/65/67 no SpriteImage\en-ph\item.spr (shields 53 a 57)
rem Precisa do item.spr com a Pocao de Protecao (icone 657) ja aplicada (ou com versao anterior dos shields). Backup: item.spr.bak_shields
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_shields.patch'; $ok='9e4e7c88361d40a7098ef0c21d593862';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja aplicado. Nada a fazer.'; exit 0 }" ^
 "if (@('e0434b29823f0ec45d9c2e4ebbde966b','ead4d48787d1a864042d1847eb8d41da','02447777f50b6b83aaaa661ed6e1802d') -notcontains $md5) { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_shields') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icones dos shields 57-67 aplicados. Backup em item.spr.bak_shields' } else { Copy-Item ($spr + '.bak_shields') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
