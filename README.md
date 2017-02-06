# Janis, Jimi, Kurt und Amy. 
Gibt es den Club27?

Wenn Ja, wer ist dabei, welche Persönlichkeiten sind darin vertreten, welche nicht.... 

## Story...

Die Idee des Club27 ist ein moderner Mythos, welcher in der Tatsache begründet ist, dass einige berühmte Musiker im Alter von 27 Jahren ums Leben kamen. Berühmte und tragische Vertreter des Clubs sind unter anderen Kurt Cobain, Jim Morrison, Jimi Hendrix, Janis Joplin und Amy Whinehouse. 

* Wer ist drin? Musiker? Prominente allgemein? 

* Was ist dran? Ist es tatsächlich so, dass überproportional viele Prominente mit 27 Jahren sterben? 

### Zusammensetzung des Club27


![Zusammensetzung des Club 27](https://agalii.github.io/club27/figures/stacked_comparison_up_down.svg)


Teilt man alle Prominenten nach ihrem Beruf oder Betätigungsfeld ein, kann man vergleichen, ob sich die Gruppe derer die mit 27 Jahren starben von der Gesamtheit aller Prominenten in der Zusammensetzung unterscheidet. 

Musiker:innen und Schauspieler:innen schneiden dabei neutral ab, sie sind also im Vergleich zur Gesamtheit aller Prominenten keinem höheren Risiko ausgesetzt mit 27 zu sterben. Politiker:innen und Wissenschaftler:innen dagegen, sind im Club 27 vergleichsweise gering vertreten.

Auffallend stark vertreten sind Sänger:innen und Athlet:innen, und allen voran Menschen die im politischen Widerstand aktiv waren. Letztere haben einen fast 8-fach erhöhten Anteil am Club 27. 

Es gibt also Unterschiede zwischen den unterschiedlichen Gruppen an Prominenten, und Sänger rangieren immerhin auf Platz 3. Bleibt die Frage ob es sich speziell um das mystische 27. Lebensjahr dreht, oder ob die Gründe banaler sind. 

### Mythos und statistische Lebenserwartung


![Zusammensetzung des Club 27](https://agalii.github.io/club27/figures/age_dist_combined_groups.svg)


Die klassische Kurve der Altersverteilung steigt anfangs gemächlich an, wird ab 40-50 Jahren immer steiler, findet ihr Maximum in der Altersspanne zwischen 70 und 80 Jahren (Tendenz steigend) und fällt danach steil wieder ab. 

Die grünen Linien zeigen einen verhältnismäßig geringen Anteil im Altersbereich unter 60 Jahren und eine Überhöhung am Maximum. Diese Linien stehen für Politiker:innen, Wissenschaftler:innen, Geistliche und Menschen aus dem Showbusiness (Regisseure, Moderatoren, Kabarettisten, etc.), welche demnach eine überdurchschnittliche Lebenserwartung haben.  

Ein gegenteiliges Bild zeichnen die blauen Linien der Athlet:innen, Sänger:innen und 'anderer'. Diese Gruppen sind einem überdurchschnittlich hohem Risiko Ausgesetzt im Alter zwischen 20 und 40 Jahren zu sterben. Auffällig ist hier der leichte 'Knick' der dunkelblauen Athlet:innenlinie zwischen 25 und 30 Jahren -- ein möglicher hinweis auf den Club 27?

Am drastischten ist der Verlauf der rote Linie der Widerstandskämpfer:innen. Diese Menschen sind einem um ein Vielfaches erhöhtem Risiko ausgesetzt, im Alter zwischen 20 und 50 Jahren zu sterben. Die Kurve ähnelt eher einer Schlange die einen Elefanten verschluckt hat und spiegelt wohl viele dramatische Schicksale wieder. 

Die Personengruppen, die einen überproportionalen Anteil am Club 27 darstellen, sind also generell einem höheren Risiko ausgesetzt in jungen Jahren zu sterben. Ein näherer Blick auf die Altersverteilung in dem Bereich 25 bis 30 Jahre zeigt, dass es hier keinen auffälligen Ausschlag bei 27 Jahren gibt. 

Verschiedene Gruppen haben aus verschiedenen Gründen unterschiedliche Lebenserwartungen. Die körperliche Belastung von Hochleistungssportler:innen, das wilde Leben der Sänger:innen oder die tragischen Schicksale von Menschen im politischen Widerstand -- darüber, was letztlich zu einem höheren Risiko von Todesfällen in jungen Jahren führt, kann spekuliert werden. Ebenso darüber, ob es vielleicht nur die besten ihres Metiers in den tragischen Club 27 schaffen... 

## Auswertung
### Anmerkung zur Aussagekraft der Auswertung: 

Die Daten sind offensichtlich keine neutrale Stichprobe. Zum einen ist mir das genaue Auswahlkriterium nicht bekannt, zum anderen kommen Wikipediadaten mit eigenen Einschränkungen: 
1. Da die Daten aus der deutschen Wikipedia sind ist ein bias hin zu deutschen Persönlichkeiten festzustellen
2. Die Personen müssen bestimmte Voraussetzungen erfüllen um in die Wikipedia aufgenommen zu werden, welche nicht unabhängig von z.B. der Berufsgruppe sind. Während viele Musiker schon unter 27 berühmt sind, beginnt die Karriere eines Wissenschaftlers oder Politikers meist erst in höherem Alter. 

### Datenbereinigung
#### Formatierung und Bereinigung der Daten
Neben konkreten Datumsangaben, gab es einige ungenaue oder vage Einträge, welche zunächst entfernt werden mussten. Es wurden alle Personen gelöscht,  

* welche noch leben oder zu denen es aus anderen Gründen kein Sterbe- (oder Geburts-) datum gibt. 
* zu denen es nur ungenaue Geburts- oder Sterbedaten gibt: Fehlende Tages- oder Monatsangabe, Zeitspannen ('bis', 'um', 'vermutlich', etc.). 
* welche a.C. geboren wurden.   

Einträge die mit 'getauft' oder 'beerdigt' markiert waren wurden behalten. 

#### Extraktion von Kategorien aus den Kurzbeschreibungen
Die Kurzbeschreibung wurde bnutzt um daraus den Beruf und das/die Betätigungsfeld/er einer Person zu ermitteln. Dazu wurden zunächst alle Füllwörter und fall- oder genusabhängige Endungen entfernt. Danach würde die Kurzbeschreibung in ihre Einzelnen Wörter zerlegt welche dann auf die Zugehörigkeit zu bestimmten Kategorien geprüft werden konnten. Ich hatte ursprünglich gehofft, hier mit einer Clusteranalyse weiterzukommen, was sich ob der Vielzahl der entstehenden Cluster aber als wenig hilfreich herausstellte.

Deshalb wurden manuell relevante Kategorien (oder Gruppen) herausgesucht und die entsprechenden Attribute dafür definiert. Für die Kategorien *Athlet:in* und *Musiker:in* habe ich dazu Daten zu Sportarten und Musikinstrumenten von Wikipedia verwendet und entsprechend aufbereitet.  

Die resultierenden Kategorien und Attribute wurden nach dem trial-and-error Prinzip identifiziert und sind keineswegs vollständig! 

### Datenauswertung
Die Datenauswertung beschränkt sich auf eine einfache Berechnung und den Vergleich von prozentualen Anteilen. Eine weitreichendere statistische Auswertung, wie beispielsweise ein Signifikanztest um die statistisch Relevanz der beobachteten (nicht-) Abweichungen vom Mittel zu beurteilen, wäre möglich. Dies erschien mir in Anbetracht der relativ klaren Muster allerdings überflüssig. 

### Sonstiges
#### Verwendete R Libraries 
Die verwendeten R libraries werden während der Ausführung mit dem Makefile automatisch geladen, aber nicht installiert. Sollten diese nicht vorhanden sein, müssen sie manuell installiert werden: 

	install.packages("$PACKAGENAME")

Die verwendeten libraries sind: 

* showtext
* sysfonts
#### Laufzeit
Die Eigenschaften aller Personen auf Übereinstimmung mit allen Attributen der verschiedenen Gruppen zu prüfen dauert.

