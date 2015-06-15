Muzikanten Marktplaats
======================

Korte inleiding
------------------

*Dit project bestaat momenteel alleen als oefening. Ik wil mijn rails-skills verbeteren, dat kan je alleen doen door te bouwen.*

Deze Rails website is gebaseerd op een bestaande Facebook groep met dezelfde naam. Ik ben zelf muzikant (gitarist van opleiding), en zoals meeste muzikanten ben ook een liefhebber van tweedehands websites af te speuren in de zoek van een pareltje. Meestal doe je dat op de bekende `marktplaats.nl` website. Wat interessant is bij de Muzikanten Marktplaats Facebook groep is de sfeer. Het voelt niet als een grote website waar een hoop achter de schermen gebeurd. Het is een kleine 'exclusieve' community die samen wat mooie spullen ruilen/verkopen. Het voelt ook als een interactief gesprek tussen medemuzikanten. Dit komt vooral doordat het op Facebook is. Niemand is anoniem, het gesprek gebeurt vlak onder de advertentie en iedereen kan zien wie er al heeft gereageerd en hoe. Iedereen kan vragen stellen, het is simpelweg gezelliger.


Doelen
------

De Muzikanten Marktplaats Facebook groep verschilt nogal met traditionele tweedehands sites. De doelen voor dit project zijn gedreven door die verschillen. Ik wil de essentie van een Facebook groep grijpen en presenteren in de vorm van een dedicated website. Het moet een plek zijn waar een community omheen kan groeien.

* Er worden geen dedicated muma accounts aangemaakt. Je moet via Facebook inloggen. Dit doe ik om de anonimiteit weg te halen die je meestal terugvind op tweedehands websites. Als je iets niet vertrouwd kan je het Facebook profiel van de verkoper bekijken.
* Winkels zijn niet toegelaten. Het gaat hier uitsluitend voor tweedehands verkoop, van particulier tot particulier.
* Alle gesprekken zijn openbaar. Als je iets wil vragen over een advertentie, zet een reactie neer onder de advertentie. Zo kan de hele community meepraten.

Technische Specs
----------------

* Ruby Versie: 2.2.1p85

* Rails versie: 4.2.1

* Development database: sqlite3

* Production database: MySQL

Website lokaal draaien
----------------------

1. Repo clonen
2. `bundle install; rake db:migrate`
3. Solr server opstarten. Dit doe je met `bundle exec rake sunspot:solr:start` (en `stop` als je hem wil stoppen);
4. `open http://localhost:3000 && rails s`
