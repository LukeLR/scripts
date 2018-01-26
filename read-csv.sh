OLDIFS=$IFS
IFS=";"
while read number nachname vorname strasse plz ort email festnetz handy skype geburtstag geburtsort alter bereich funktion region suffix food bemerkung tshirtgroesse tshirtschnitt verteiler dropbox geschlecht dropboxaccount
 do
	echo BEGIN:VCARD
	echo VERSION:3.0
#	echo NON-ASCII=UTF8-4
	echo N:$nachname\;$vorname\;\;\;\;
	echo FN:$vorname $nachname
	echo ORG:TenSing Plus 2018\;$bereich
	echo TITLE:$funktion
#	echo TEL\;TYPE=home\;$festnetz
#	echo TEL\;TYPE=cell\;$handy
#	echo ADR\;TYPE=home\;\;\;$strasse\;$ort\;\;$plz\;Deutschland
	echo TEL\;TYPE=HOME\;TYPE=CELL\;TYPE=VOICE:$festnetz
	echo TEL\;TYPE=IPHONE\;TYPE=CELL\;TYPE=VOICE\;TYPE=pref:$handy
	echo item1.ADR\;TYPE=home\;TYPE=pref:\;\;$strasse\;$ort\;\;$plz\;Deutschland
	echo item1.X-ABADR:de
	echo EMAIL\;TYPE=INTERNET\;TYPE=HOME\;TYPE=pref:$email
#	echo IMPP:skype:$skype
	echo IMPP\;X-SERVICE-TYPE=skype\;TYPE=HOME\;TYPE=pref:skype:$skype
#	echo X-SKYPE-USERNAME:$skype
	IFS=". "
	echo $geburtstag|while read tag monat jahr
	do
		echo BDAY\;VALUE=date:$jahr-$monat-$tag
	done
	IFS=";"
#	echo BIRTHPLACE\;$geburtsort
	echo "NOTE:T-Shirt-Größe und Schnitt: $tshirtschnitt $tshirtgroesse\nVerteiler: $verteiler\n Dropbox: $dropbox $dropboxaccount\nBesondere Essgewohnheiten: $food\n\n$bemerkung\n"
#	echo GENDER:$geschlecht
#	echo X-GENDER:$geschlecht
	echo END:VCARD
 done < $1
IFS=$OLDIFS
