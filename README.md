
# Janis, Jimi, Kurt und Amy - der Club 27

Die Idee des Club27 ist ein moderner Mythos, welcher in der Tatsache begründet ist, dass einige berühmte Musiker im Alter von 27 Jahren ums Leben kamen. Berühmte und tragische Vertreter des Clubs sind unter anderen Kurt Cobain, Jim Morrison, Jimi Hendrix, Janis Joplin und Amy Whinehouse. Die Fragen, die ich anhand des Datensatzes **dewiki-20170101-persons.tsv** beantworten will sind: 

* Wer ist drin? Musiker? Prominente allgemein? 

* Was ist dran? Ist es tatsächlich so, dass überproportional viele Prominente mit 27 Jahren sterben? 

### Zusammensetzung des Club27


![Zusammensetzung des Club 27](https://agalii.github.io/club27/figures/stacked_comparison_up_down.svg) 


Teilt man alle Prominenten nach ihrem Beruf oder Betätigungsfeld ein, kann man vergleichen, ob sich die Gruppe derer die mit 27 Jahren starben von der Gesamtheit aller Prominenten in der Zusammensetzung unterscheidet. 

Musiker:innen und Schauspieler:innen schneiden dabei neutral ab, sie sind also im Vergleich zur Gesamtheit aller Prominenten keinem höheren Risiko ausgesetzt mit 27 zu sterben. Politiker:innen und Wissenschaftler:innen dagegen, sind im Club 27 vergleichsweise gering vertreten.

Auffallend stark vertreten sind Sänger:innen und Athlet:innen, und allen voran Menschen die im politischen Widerstand aktiv waren. Letztere haben einen fast 8-fach erhöhten Anteil am Club 27. 

Es gibt also Unterschiede zwischen den unterschiedlichen Gruppen an Prominenten, und Sänger rangieren immerhin auf Platz 3. Bleibt die Frage, ob es sich speziell um das mystische 27. Lebensjahr dreht, oder ob die Gründe und Verteilungen banaler sind. 

### Mythos und statistische Lebenserwartung


![Zusammensetzung des Club 27](https://agalii.github.io/club27/figures/age_dist_combined_groups.svg) 


Die klassische Kurve der Altersverteilung steigt anfangs gemächlich an, wird ab 40-50 Jahren immer steiler, findet ihr Maximum in der Altersspanne zwischen 70 und 80 Jahren und fällt danach steil wieder ab. 

Die grünen Linien zeigen einen verhältnismäßig geringen Anteil im Altersbereich unter 60 Jahren und eine Überhöhung am Maximum. Diese Linien stehen für Politiker:innen, Wissenschaftler:innen, Geistliche und Menschen aus dem Showbusiness (Regisseure, Moderatoren, Kabarettisten, etc.), welche demnach eine überdurchschnittliche Lebenserwartung haben.  

Ein gegenteiliges Bild zeichnen die blauen Linien der Athlet:innen, Sänger:innen und 'anderer'. Diese Gruppen sind einem überdurchschnittlich hohem Risiko ausgesetzt, im Alter zwischen 20 und 40 Jahren zu sterben. Auffällig ist hier der leichte 'Knick' der dunkelblauen Athlet:innenlinie zwischen 25 und 30 Jahren -- ein möglicher Hinweis auf den Club 27?

Am drastischsten ist der Verlauf der rote Linie der Widerstandskämpfer:innen. Diese Menschen sind einem um ein Vielfaches erhöhtem Risiko ausgesetzt, im Alter zwischen 20 und 50 Jahren zu sterben. Die Kurve ähnelt eher einer Schlange die einen Elefanten verschluckt hat und spiegelt wohl viele dramatische Schicksale wieder. 

Die Personengruppen, die einen überproportionalen Anteil am Club 27 darstellen, sind also generell einem höheren Risiko ausgesetzt in jungen Jahren zu sterben. Ein näherer Blick auf die Altersverteilung in dem Bereich 25 bis 30 Jahre zeigt, dass es hier keinen auffälligen Ausschlag bei 27 Jahren gibt. 

Verschiedene Gruppen haben aus verschiedenen Gründen unterschiedliche Lebenserwartungen. Die körperliche Belastung von Hochleistungssportler:innen, das wilde Leben der Sänger:innen oder die tragischen Schicksale von Menschen im politischen Widerstand -- darüber, was letztlich zu einem höheren Risiko von Todesfällen in jungen Jahren führt, kann spekuliert werden. Ebenso darüber, ob es vielleicht nur die besten ihres Metiers in den tragischen Club 27 schaffen ... 

## Auswertung
### Aussagekraft der Auswertung
Das Ergebnis dieser Auswertung ist mit etwas Vorsicht zu genießen, da die Daten keine neutrale Stichprobe darstellen. Zum einen ist mir das genaue Auswahlkriterium nicht bekannt, zum anderen kommen die Wikipediadaten mit eigenen Einschränkungen: 

1. Da die Daten aus der deutschen Wikipedia sind ist ein bias hin zu deutschen Persönlichkeiten festzustellen. 

2. Die Personen müssen bestimmte Voraussetzungen erfüllen um in die Wikipedia aufgenommen zu werden, welche nicht unabhängig von z.B. der Berufsgruppe sind. Während viele Musiker:innen schon unter 27 Karriere machen, werden Wissenschaftler:innen oder Politiker:innen oft erst in höherem Alter berühmt. 

### Umsetzung
Die Auswertung und Visualisierung der Daten wurde komplett in R umgesetzt. Die einzelnen Schritte sind auf viele einzelne R-Skripte aufgeteilt, welche jeweils einen klar abzugrenzenden Arbeitsschritt erfüllen und Zwischenergebnisse abspeichern. Diese Skripte können mit dem Kommando 

	make

auf der Kommandozeile aufgerufen werden. Dadurch werden alle Schritte ausgeführt, die zur Erstellung der beiden Abbildungen 'figures/stacked_comparison_up_down.svg' und 'figures/age_dist_combined_groups.svg' notwendig sind. Die komplette Berechnung aus den Rohdaten dauert relativ lange. Deshalb werden nur die Schritte ausgeführt welche notwendig sind, um etwaige Aktualisierungen in Daten und Skripten zu berücksichtigen. Die einzelnen Schritte und Skripte werden im folgenden kurz beschrieben. 

#### Rohdatenaufbereitung
##### Formatierung und Bereinigung der Datumsangaben und Kurzbeschreibungen

* **R/data_analysis/date_cleanup.R** ließt die Rohdaten aus data/raw/dewiki-20170101-persons.tsv, bereinigt die Datumsangaben und bringt das Datum in ein einheitliches Format. Ungenaue oder vage Einträge werden zunächst entfernt. Es werden alle Personen gelöscht, 

	* welche noch leben oder zu denen es aus anderen Gründen kein Sterbe- (oder Geburts-) datum gibt. 
	* zu denen es nur ungenaue Geburts- oder Sterbedaten gibt: Fehlende Tages- oder Monatsangabe, Zeitspannen ('bis', 'um', 'zwischen', etc.). 
	* welche a.C. geboren wurden. 
	* Einträge die mit 'vermutlich', 'getauft' oder 'beerdigt' markiert waren wurden behalten. 

* **R/data_analysis/age_calculation.R** transformiert die Daten von strings nach POIXlt, damit daraus das Alter der Personen berechnet werden kann. Personen mit negativem Alter oder solche die älter wurden als der älteste Mensch (laut Datensatz 122 Jahre) werden entfernt. 

* **R/data_analysis/property_cleanup.R** Die Kurzbeschreibung soll benutzt werden, um daraus den Beruf und das/die Betätigungsfeld/er einer Person zu ermitteln. Dazu werden zunächst alle Füllwörter und fall- oder genusabhängige Endungen entfernt. Danach wird die Kurzbeschreibung in ihre Einzelnen Wörter zerlegt (Properties oder Eigenschaften). 

#### Zusätzlich benötigte Informationen 
Die resultierenden Eigenschaften bestimmen die Zugehörigkeit einer Person zu bestimmten Kategorien oder Gruppen. Ich hatte ursprünglich gehofft, hier mit einer Clusteranalyse weiterzukommen, was sich ob der Vielzahl der entstehenden Cluster aber als wenig hilfreich herausstellte. Deshalb wurden manuell relevante Kategorien herausgesucht und die entsprechenden Attribute dafür definiert. 

Für die Kategorien *Athlet:in* und *Musiker:in* habe ich Daten zu Sportarten und Musikinstrumenten von Wikipedia heruntergeladen, welche mit den Skripten 

* **R/data_analysis/additional_data_music_cleanup.R** und 
* **R/data_analysis/additional_data_sport_cleanup.R** bereinigt und entsprechend aufbereitet werden.

Die beiden Skripte 

* **R/data_analysis/define_categories_all.R** und
* **R/data_analysis/define_categories_main.R** greifen diese Attribute auf, erweitern sie um eine Reihe manuell gesetzter Attribute und ordnen sie den ausgewählten Kategorien zu. Die beiden entstehenden Look-up-tables unterscheiden sich leicht in ihrer Formatierung, jenachdem ob alle zutreffenden Kategorien für eine Person gefunden werden sollen, oder nur die wichtigste. Im ersten Fall (Endung _all.R) würde ein Militärpfarrer sowohl der Kategorie 'Militär' als auch der Kategorie 'Geistliche:r' zugeordnet werden. Im zweiten Fall (Endung _main.R) wäre er nur 'Geistliche:r'. 

Die resultierenden Kategorien und Attribute wurden nach dem trial-and-error Prinzip identifiziert und sind keineswegs vollständig! 

* **R/plot/define_aux_data.R** definiert Farben und den Legendentext für alle verwendeten Gruppen, damit später alle Visualisierungsskripte zentral darauf zugreifen können. 

#### Extraktion von Kategorien aus den Kurzbeschreibungen
 
Der Vergleich der Attribute mit den aus der Kurzbeschreibung gewonnenen Eigenschaften erfolgt unter der Verwendung von regular expressions, um möglichst viele unterschiedliche Formulierungen und Wortkombinationen abzudecken. 

* **R/data_analysis/find_all_categories.R** extrahiert wie oben beschrieben alle zutreffenden Kategorien zu einer Person. 
* **R/data_analysis/find_main_categories.R** berücksichtigt nur die Hauptkategorie der zuerst genannten (validen) Eigenschaft. 

#### Datenauswertung
Die Datenauswertung beschränkt sich auf eine einfache Berechnung und den Vergleich von prozentualen Anteilen. Eine weitreichendere statistische Auswertung, wie beispielsweise ein Signifikanztest um die statistisch Relevanz der beobachteten (nicht-) Abweichungen vom Mittel zu beurteilen, wäre möglich. Für eine einfache und gleichzeit klare Darstellung der Daten und Ergebnisse schien dies allerdings nicht nötig. 

* **R/data_analysis/group_distributions_main_to_plot.R** berechnet die prozentualen Anteile aller Personengruppen am Club 27 und an der Gesamtheit der Personen. Das entstehende Datenfile dient als Grundlage für den Plot figures/stacked_comparison_up_down.svg.

* **R/data_analysis/age_distributions_1yr.R** und 
* **R/data_analysis/age_distributions_5yr.R** berechnen die Altersverteilung im Gesamtdatensatz, sowie für alle Gruppen, einmal auf ein Jahr genau, einmal auf 5-Jahrescluster vereinfacht. Die resultierenden Datenfiles werden für die Erstellung der Abbildung figures/age_dist_combined_groups.svg benötigt. 

#### Erstellung der Abbildungen
* **R/plot/stacked_comparison.R** und 
* **R/plot/age_distribution_per_category.R** generieren die beiden resultierenden Abbildungen

### Sonstiges
#### Verwendete R Libraries 
Die verwendeten R libraries werden während der Ausführung mit dem Makefile automatisch geladen, aber nicht installiert. Sollten diese nicht vorhanden sein, müssen sie manuell installiert werden: 

	R 

	install.packages("$PACKAGENAME")

Die verwendeten libraries sind: 

* showtext
* sysfonts
* stringr




