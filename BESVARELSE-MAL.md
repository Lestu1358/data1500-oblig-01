# Besvarelse - Refleksjon og Analyse

**Student:** [Leo Alexander Stubbene]

**Studentnummer:** [1358]

**Dato:** [01.03.2026]

---

## Del 1: Datamodellering

### Oppgave 1.1: Entiteter og attributter

**Identifiserte entiteter:**
**Attributter for hver entitet:**

I casen vil jeg si det er fem sentrale entiteter. De 5 forskjellige er: kunde, stasjon, sykkel, lås og utleie.

Kunde er en viktig entitet fordi det er kundene som registrerer seg og leier sykler. Hver enkelte kunde får en unik ID altså en customer_id, som gjør at vi kan skille de fra hverandre i databasen. I tillegg lagres epost og telefonnummer, og disse burde være unike slik at samme person ikke registreres flere ganger. Vi lagrer også fornavn og etternavn for å vite hvem kunden er. 

Stasjon er stedet der sykler kan hentes og leveres, og hver stasjon har en unik ID, altså station_id og et navn. Vi trenger denne entiteten slik at systemet holder oversikt over hvor syklene befinner seg og hvor en utleier starter og avsluttes. 

Sykkel representerer alle sykler i systemet. Hver sykkel har en unik ID (bike_id). Vi lagrer også hvilken stasjon og lås sykkelen står på, slik at vi alltid vet hvor den befinner seg. Når sykkelen leies ut, er disse feltene tomme (NULL). På den måten kan vi skille mellom hvilke sykler som er i bruk og hvilke som er tilgjengelige. 

Lås er en egen entitet fordi hver stasjon har flere låser, og en sykkel festes til en bestemt lås. Hver lås har også sin egen unik ID (lock_id) og tilhører en stasjon. Lås trengs for å vite hvilke av låsene som sykkelen er koblet til når den er parkert. 

Utleie beskriver selve leieperioden mellom kunde og en sykkel. Den vil registrere når sykkelen ble leid og når den er tilbake på plass. Den vil også lagre hvilken kunde og hvilken sykkel det gjelder, samtidig som leiebeløpet. Vi trenger denne entiteten slik at vi kan ha oversikt over bruk og betaling. 


---

### Oppgave 1.2: Datatyper og `CHECK`-constraints

**Valgte datatyper og begrunnelser:**

Jeg har brukt SERIAL som datatype for primærnøkler fordi det automatisk generer unike ID-er. Tekstfelt som navn, adresse, mobilnummer og epost er lagret som VARCHAR, da dette er tekstverdier med variabel lengde. Tidspunktene returned_at og rented_at er lagret som TIMESTAMP fordi vi må registrere både klokkeslett og dato. Leiebeløpet er lagret som NUMERIC(10,2) for å sikre presis lagring av penger. Fremmednøkler er lagret som INTEGER, fordi de viser til primærnøkler som også er heltall. 

**`CHECK`-constraints:**

Jeg har lagt til CHECK constraints for å sikre gyldige verdier i databasen. Mobilnummer har en contstraint som sikrer at det bare inneholder riktig lengde og tall. Epost har en enkel constraint som sikrer at den inneholder @. Låsnummeret må være større en 0 for å unngå ugyldige nummer. Leiebeløp kan ikke være negativt, så jeg la til en constraint som sikrer at beløpet er null eller større en 0. Det er også en constraint som sikrer at innleveringstid ikke kan være før utlevert tid. Disse constraintene er nødvendige for å sikre dataintegritet og hindre feilregistreringer. 


**ER-diagram:**

[https://mermaid.ai/d/d10873ad-9652-484e-8c99-382920a1b2a5]

---
### Oppgave 1.3: Primærnøkler

**Valgte primærnøkler og begrunnelser:**

For hver entitet har jeg valgt en egen ID som primærnøkkel: customer_id, station_id, lock_id, rental_id og bike_id. Disse bruker for å identifisere hver rad unikt i databasen. rental_id er nødvendig for utleie da en kunde kan leie samme sykkel flere ganger, og hver leie må kunne skilles fra de andre. 

**Naturlige vs. surrogatnøkler:**

Jeg har valgt å bruke surrogatnøkler, istedenfor naturlige nøkler. Selv om for eksempel mobilnummer eller epost kunne vært naturlige nøkler for kunde, kunne disse verdiene endret seg over tid. Surrogatnøkler er derfor mer stabile og enklere å bruke i relasjoner mellom tabeller. 

**Oppdatert ER-diagram:**

https://mermaid.ai/d/47e70da0-c815-41b5-bc3d-3f0aee11d78a


---

### Oppgave 1.4: Forhold og fremmednøkler

**Identifiserte forhold og kardinalitet:**

Stasjon -> lås: en-til-mange. 
Stasjon -> Sykkel: en-til-mange. 
Lås -> Sykkel: en-til-en.
Kunde <-> Sykkel(via utleie): mange-til-mange løses opp av utleie. 
Kunde -> Utleie: en-til-mange.
Sykkel -> Utleie: en-til-mange. 


**Fremmednøkler:**

lock.station_id -> station.station_id implementerer at hver lås tilhører en stasjon. 
bike.current_station_id -> station.station_id implementerer hvor sykkelen står. Feltet kan være NULL når sykkelen er utleid. 
bike.current_lock_id -> lock.lock_id implementerer hvilken lås sykkelen er festet i. Feltet kan også være NULL når sykkelen er utleid. 
rental.customer_id -> customer.customer_id implementerer at en utleie tilhører en kunde. 
rental.bike_id -> bike.bike_id implementerer at en utleie gjelder en sykkel. Dette gjør at kunde og sykkel blir til mange-til-mange over tid, men "løses opp" ved koblingstabellen utleie. 


**Oppdatert ER-diagram:**

https://mermaid.ai/d/59aade10-cfac-4262-b5c3-76952815ff6a


---

### Oppgave 1.5: Normalisering

**Vurdering av 1. normalform (1NF):**

Datamodellen oppfyller 1NF fordi alle tabeller har en primærnøkkel, og hvert felt inneholder bare en verdi. Det vil si at vi ikke har flere verdier i samme kolonne eller lister i feltene. 

**Vurdering av 2. normalform (2NF):**

Datamodellen oppfyller 2NF fordi alle attributtene er avhengige av hele primærnøkkelen. Siden tabellene bruker enkle primærnøkler (IDer) oppstår det ikke delvise avhengigheter. 

**Vurdering av 3. normalform (3NF):**

Datamodellen oppfyller også 3NF siden atributtene kun er avhengige av primærnøkkelen i tabellen. Informasjon om kunder, stasjoner, sykler, låser og utleie er delt opp i egne tabeller, som bidrar til redusering av duplisert data. 

**Eventuelle justeringer:**

Det var ikke nødvendig å gjøre store endringer for å oppnå 3NF. Datamodellen hadde allerede strukturen for at hver type informasjon lå i sin egen tabell. 

---

## Del 2: Database-implementering

### Oppgave 2.1: SQL-skript for database-initialisering

**Plassering av SQL-skript:**

SQL-skriptet er lagt i mappen init scripts med navnet 01-init-database.sql.

**Antall testdata:**

- Kunder: [5]
- Sykler: [100]
- Sykkelstasjoner: [5]
- Låser: [100]
- Utleier: [50]

---

### Oppgave 2.2: Kjøre initialiseringsskriptet

**Dokumentasjon av vellykket kjøring:**

[Skriv ditt svar her - f.eks. skjermbilder eller output fra terminalen som viser at databasen ble opprettet uten feil]

**Spørring mot systemkatalogen:**

```sql
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Resultat:**

```
Databasen ble startet med docker compose up -d. Deretter koblet jeg meg til PostgreSQL containeren med docker exec -it data1500-postgres psql -U admin -d oblig01. Initialiseringsskriptet ble kjørt uten feil, og tabellene ble opprettet og fylt med testdata. 

RESULTAT TERMINAL:
------------
 bike
 customer
 lock
 rental
 station
(5 rows)


```

---

## Del 3: Tilgangskontroll

### Oppgave 3.1: Roller og brukere

**SQL for å opprette rolle:**

```sql
CREATE ROLE kunde;

```

**SQL for å opprette bruker:**

```sql
CREATE USER kunde_1 WITH password 'kunde123';
GRANT kunde TO kunde_1;

```

**SQL for å tildele rettigheter:**

```sql
GRANT SELECT ON customer TO kunde;
GRANT SELECT ON station TO kunde;
GRANT SELECT ON lock TO kunde;
GRANT SELECT ON bike TO kunde;
GRANT SELECT ON rental TO kunde;
```

---

### Oppgave 3.2: Begrenset visning for kunder

**SQL for VIEW:**

```sql
[Skriv din SQL-kode for VIEW her]
```

**Ulempe med VIEW vs. POLICIES:**

[Skriv ditt svar her - diskuter minst én ulempe med å bruke VIEW for autorisasjon sammenlignet med POLICIES]

---

## Del 4: Analyse og Refleksjon

### Oppgave 4.1: Lagringskapasitet

**Gitte tall for utleierate:**

- Høysesong (mai-september): 20000 utleier/måned
- Mellomsesong (mars, april, oktober, november): 5000 utleier/måned
- Lavsesong (desember-februar): 500 utleier/måned

**Totalt antall utleier per år:**

[Skriv din utregning her]

**Estimat for lagringskapasitet:**

[Skriv din utregning her - vis hvordan du har beregnet lagringskapasiteten for hver tabell]

**Totalt for første år:**

[Skriv ditt estimat her]

---

### Oppgave 4.2: Flat fil vs. relasjonsdatabase

**Analyse av CSV-filen (`data/utleier.csv`):**

**Problem 1: Redundans**

[Skriv ditt svar her - gi konkrete eksempler fra CSV-filen som viser redundans]

**Problem 2: Inkonsistens**

[Skriv ditt svar her - forklar hvordan redundans kan føre til inkonsistens med eksempler]

**Problem 3: Oppdateringsanomalier**

[Skriv ditt svar her - diskuter slette-, innsettings- og oppdateringsanomalier]

**Fordeler med en indeks:**

[Skriv ditt svar her - forklar hvorfor en indeks ville gjort spørringen mer effektiv]

**Case 1: Indeks passer i RAM**

[Skriv ditt svar her - forklar hvordan indeksen fungerer når den passer i minnet]

**Case 2: Indeks passer ikke i RAM**

[Skriv ditt svar her - forklar hvordan flettesortering kan brukes]

**Datastrukturer i DBMS:**

[Skriv ditt svar her - diskuter B+-tre og hash-indekser]

---

### Oppgave 4.3: Datastrukturer for logging

**Foreslått datastruktur:**

[Skriv ditt svar her - f.eks. heap-fil, LSM-tree, eller annen egnet datastruktur]

**Begrunnelse:**

**Skrive-operasjoner:**

[Skriv ditt svar her - forklar hvorfor datastrukturen er egnet for mange skrive-operasjoner]

**Lese-operasjoner:**

[Skriv ditt svar her - forklar hvordan datastrukturen håndterer sjeldne lese-operasjoner]

---

### Oppgave 4.4: Validering i flerlags-systemer

**Hvor bør validering gjøres:**

[Skriv ditt svar her - argumenter for validering i ett eller flere lag]

**Validering i nettleseren:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i applikasjonslaget:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Validering i databasen:**

[Skriv ditt svar her - diskuter fordeler og ulemper]

**Konklusjon:**

[Skriv ditt svar her - oppsummer hvor validering bør gjøres og hvorfor]

---

### Oppgave 4.5: Refleksjon over læringsutbytte

**Hva har du lært så langt i emnet:**

[Skriv din refleksjon her - diskuter sentrale konsepter du har lært]

**Hvordan har denne oppgaven bidratt til å oppnå læringsmålene:**

[Skriv din refleksjon her - koble oppgaven til læringsmålene i emnet]

Se oversikt over læringsmålene i en PDF-fil i Canvas https://oslomet.instructure.com/courses/33293/files/folder/Plan%20v%C3%A5ren%202026?preview=4370886

**Hva var mest utfordrende:**

[Skriv din refleksjon her - diskuter hvilke deler av oppgaven som var mest krevende]

**Hva har du lært om databasedesign:**

[Skriv din refleksjon her - reflekter over prosessen med å designe en database fra bunnen av]

---

## Del 5: SQL-spørringer og Automatisk Testing

**Plassering av SQL-spørringer:**

[Bekreft at du har lagt SQL-spørringene i `test-scripts/queries.sql`]


**Eventuelle feil og rettelser:**

[Skriv ditt svar her - hvis noen tester feilet, forklar hva som var feil og hvordan du rettet det]

---

## Del 6: Bonusoppgaver (Valgfri)

### Oppgave 6.1: Trigger for lagerbeholdning

**SQL for trigger:**

```sql
[Skriv din SQL-kode for trigger her, hvis du har løst denne oppgaven]
```

**Forklaring:**

[Skriv ditt svar her - forklar hvordan triggeren fungerer]

**Testing:**

[Skriv ditt svar her - vis hvordan du har testet at triggeren fungerer som forventet]

---

### Oppgave 6.2: Presentasjon

**Lenke til presentasjon:**

[Legg inn lenke til video eller presentasjonsfiler her, hvis du har løst denne oppgaven]

**Hovedpunkter i presentasjonen:**

[Skriv ditt svar her - oppsummer de viktigste punktene du dekket i presentasjonen]

---

**Slutt på besvarelse**
