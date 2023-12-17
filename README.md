Questo script è puramente a scopo dimostrativo  
è stato frutto dall'idea di altri script come  [MSMG Toolkit](https://msmgtoolkit.in/ "MSMG Toolkit")  e  [NTLite](https://www.ntlite.com/ "NTLite")  ecc.

ASSICURATI CHE LA  **ISO**  DI WINDOWS SIA INTEGRA E NON PERSONALIZZATA, LE ISO PERSONALIZZATE ALTRUI PRESENTANO ELABORAZIONI PARTICOLARI A VOLTE NON COMPATIBILI CON QUESTA VERSIONE DI SCRIPT

**Procedimento:**

1.  Disattiva l’antivirus
2.  Montare la iso di windows nell’unità
3.  Lancia WinMod.cmd
4.  Per cambiare il nome e label della iso dovrai cambiare il nome in queste stringhe:

**set IsoName=nomeiso**

**set IsoLabel=nomelabel**

Dovrai cambiare il numero  _2861_  con il numero giusto della tua versione di windows se diversa da  _2861_  per rimuovere alcuni programmi

**Esempio Windows 11 23H2 versione dicembre 2023**

###### microsoft-windows-wallpaper-content-extended-fod-package31bf3856ad364e35amd6410.0.22621.2861

**La tua versione se diversa**

###### microsoft-windows-wallpaper-content-extended-fod-package31bf3856ad364e35amd6410.0.22621.numerodellatuaversione

Si trovano nelle righe  _`165/174`_

Nella cartella RegFile puoi aggiungere i file  _.reg_  che vorrai inserire nel registro
