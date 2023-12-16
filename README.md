Questo script è puramente a scopo dimostrativo  
è stato frutto dall’idea di altri script come MSMG Toolkit,NTLite ecc.

Assicurati che la iso di windows sia integra e non personalizzata, le iso personalizzate altrui, presentano elaborazioni particolari a volte non compatibili con questa versione di script.

**Procedimento:**  
1. Disattiva l’antivirus  
2. Montare la iso di windows nell’unità  
3. Lancia WinMod.cmd  
4. Per cambiare il nome e label della iso, dovrai cambiare il nome in queste stringhe:

**set IsoName=nomeiso**  
**set IsoLabel=nomelabel**

Dovrai cambiare il numero *2861* con il numero giusto della tua versione di windows se diversa da *2861* per rimuovere alcuni programmi

Esempio Windows 11 versione dicembre 2023 Microsoft-Windows-Wallpaper-Content-Extended-FoD-Package31bf3856ad364e35amd6410.0.22621.2861 La tua versione se diversa Microsoft-Windows-Wallpaper-Content-Extended-FoD-Package31bf3856ad364e35amd6410.0.22621.numerodellatuaversione 
Si trovano nelle righe *`165/174`*

Nella cartella RegFile puoi aggiungere i file *.reg* che vorrai inserire nel registro
