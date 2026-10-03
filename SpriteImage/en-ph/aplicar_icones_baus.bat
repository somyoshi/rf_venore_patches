@echo off
rem Coloca os icones dos baus Talic, Gem T3, Gem T4 e Gem T5 no SpriteImage\en-ph\item.spr (posicoes 645 a 648)
rem Substitui a versao anterior desses icones, se ja tiver sido aplicada. Backup: item.spr.bak_baus
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
 "$spr='item.spr'; $patch='item_spr_baus.patch'; $ok='b80b0549f16ce95216fddd7850a357bc';" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'Ja aplicado. Nada a fazer.'; exit 0 }" ^
 "if (@('554b4d0ef8d7b7603c327d16275350de','2fad3d89c4b3934c6953e9d07c44c68a','0e695573c030f7d64514d92385d15fc7','6f992eb14e8a49eb60c35bbb1ce458b1') -notcontains $md5) { Write-Host ('item.spr diferente do esperado (' + $md5 + '). Nada foi alterado.'); exit 1 }" ^
 "Copy-Item $spr ($spr + '.bak_baus') -Force;" ^
 "$b=[IO.File]::ReadAllBytes($spr); $p=[IO.File]::ReadAllBytes($patch);" ^
 "$n=[BitConverter]::ToUInt32($p,4); $pos=8;" ^
 "for($k=0;$k -lt $n;$k++){ $off=[BitConverter]::ToUInt32($p,$pos); $len=[BitConverter]::ToUInt32($p,$pos+4); [Array]::Copy($p,$pos+8,$b,$off,$len); $pos+=8+$len };" ^
 "[IO.File]::WriteAllBytes($spr,$b);" ^
 "$md5=(Get-FileHash $spr -Algorithm MD5).Hash.ToLower();" ^
 "if ($md5 -eq $ok) { Write-Host 'OK: icones 645 a 648 aplicados. Backup em item.spr.bak_baus' } else { Copy-Item ($spr + '.bak_baus') $spr -Force; Write-Host 'ERRO: resultado diferente, original restaurado.' }"
pause
