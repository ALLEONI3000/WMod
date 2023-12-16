
Questo script è puramente a scopo dimostrativo
è stato frutto dall'idea di altri script come MSMG Toolkit e NTLite ecc.


Assicurati che la iso di windows sia integra e non personalizzata
Le iso personalizzate altrui presentano elaborazioni particolari
a volte non compatibili con questa versione di script.

Procedimento:
A) Disattiva l'antivirus
B) Montare la iso di windows nell'unità
C) Lancia WinMod.cmd
D) Per cambiare il nome e label della iso, dovrai cambiare il nome in queste stringhe:

::####################################
set IsoName=WinMod
set IsoLabel=WinMod
::####################################


Dovrai cambiare il numero 2861 con il numero giusto della tua versione di windows 
se diversa da 2861 per rimuovere alcuni programmi

Esempio
Windows 11 versione dicembre 2023
Microsoft-Windows-Wallpaper-Content-Extended-FoD-Package~31bf3856ad364e35~amd64~~10.0.22621.2861
La tua versione se diversa
Microsoft-Windows-Wallpaper-Content-Extended-FoD-Package~31bf3856ad364e35~amd64~~10.0.22621.numerodellatuaversione
Si trovano nelle righe  165/174 

Nella cartella RegFile puoi aggiungere i file .reg che vorrai inserire nel registro
