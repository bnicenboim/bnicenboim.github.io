---
title: "Woordenduel"
format:
  html:
    toc: false
    navbar: false
    page-layout: article
    theme:
      - cosmo
      - brand
    css: word-prediction-explained.css
    include-in-header:
      text: |
        <link rel="icon" type="image/svg+xml" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='100' height='100' rx='20' fill='url(%23g)'/><text x='50' y='68' font-size='62' text-anchor='middle' font-family='system-ui,sans-serif'>💬</text><text x='68' y='52' font-size='28' text-anchor='middle' font-family='system-ui,sans-serif' font-weight='bold' fill='white'>?</text></svg>">
lang: nl
---

[**Speel het spel**](word-prediction.html?lang=nl)

## Waar gaat het spel over?

Het doel van het spel is om een verborgen zin te raden. Je krijgt het eerste woord te zien en probeert het volgende woord te raden voordat de andere spelers dat doen. Dit klinkt simpel, maar is ook interessant: **het voorspellen van het volgende woord in een zin is iets wat je hersenen de hele tijd automatisch doen, zonder dat je het merkt.**

---

## Je hersenen lopen altijd een stap voor

Maak deze zin af:

> <em>Ze trok haar jas aan, pakte haar sleutels en liep naar de \_\_\_</em>

Je dacht bijna zeker aan *deur*. Iets in je hersenen wist het gewoon.

En deze:

> <em>Het regende, dus pakte ze haar \_\_\_</em>

*Paraplu*, waarschijnlijk. Of misschien *jas*.

> <em>Hij dronk een koffie en at \_\_\_</em>

*Een broodje? Een stuk taart? Een croissant?* Dat is lastiger. Er zijn meerdere mogelijkheden die even goed passen.

Dat verschil is belangrijk: **sommige woorden zijn veel makkelijker te voorspellen dan andere.** Voorspelbare woorden voelen heel logisch. Onvoorspelbare woorden kunnen alle kanten op. Het spel maakt dit zichtbaar: sommige woorden worden meteen geraden, andere zijn voor iedereen een raadsel.

---

## Hoe weten we dat de hersenen voorspellen?

Je kunt niet *voelen* dat je hersenen voorspellingen maken. Maar wetenschappers hebben manieren gevonden om te zien wanneer je hersenen dit doen.

Eén manier is het volgen van oogbewegingen tijdens het lezen. Je ogen glijden niet vloeiend over de pagina, maar springen van woord naar woord. Het blijkt dat ze minder tijd besteden aan voorspelbare woorden — die slaan ze soms zelfs helemaal over — en langer stilstaan bij verrassende woorden. Bij voorspelbare woorden heeft het brein al een goed idee van wat er komt, dus hoeft het niet zo nauwkeurig te kijken.

Er is ook een directere methode. Je hersenen werken op elektriciteit: miljarden cellen communiceren via kleine uitbarstingen van elektrische activiteit — dat zijn je neuronen. Al die kleine signalen tellen op, en een deel van die activiteit bereikt het oppervlak van je hoofd. Door kleine sensoren op iemands hoofdhuid te plaatsen (een techniek genaamd EEG, elektro-encefalografie) kun je die signalen opvangen terwijl iemand leest. Het ziet eruit als een badmuts vol kabels, en wat het registreert is een soort samenvatting van wat miljoenen neuronen op elk moment doen. Wanneer er een onverwacht woord verschijnt, verandert de elektrische reactie. Hoe verrassender het woord, hoe groter de verandering. De hersenen zeggen in feite: "Wacht even, dit had ik niet verwacht."

---

## Context is alles

Kijk wat er gebeurt als je meer context toevoegt aan het laatste voorbeeld, "<em>Hij dronk een koffie en at \_\_\_</em>". Bijvoorbeeld:

> <em>Het was zijn verjaardag. Hij dronk een koffie en at \_\_\_</em>

Nu is *een stuk taart* veel duidelijker.

Hoe verder je in een zin komt, hoe makkelijker het raden wordt. Je hersenen gebruiken alles wat beschikbaar is: de woorden die al zijn gezegd, wat "logisch" is in de echte wereld en wat mensen meestal zeggen in dat soort situaties. Meer context betekent minder mogelijke opties en dus makkelijkere voorspellingen.

Hetzelfde gebeurt bij het luisteren. Je begint te verwerken wat iemand zegt nog voordat de zin is afgelopen. In een gesprek beginnen mensen vaak al hun antwoord te formuleren *terwijl de ander nog aan het praten is*, omdat ze al aanvoelen waar het naartoe gaat.

---

## Wat doen de AI-spelers?

In het spel doen de AI-spelers precies hetzelfde als jij: ze bekijken de woorden die tot nu toe zichtbaar zijn en doen hun beste gok.

De AI-spelers in dit spel zijn **grote taalmodellen**: programma's die getraind zijn op enorme hoeveelheden tekst, waaronder boeken, nieuwsartikelen, websites en gesprekken.

De training werkt als volgt: het model ziet een reeks woorden en probeert te raden wat er daarna komt. Als het fout zit, wordt het een beetje bijgesteld. Na miljarden rondes ontwikkelt het iets wat lijkt op een gevoel voor hoe taal werkt — welke woorden meestal op welke volgen, in welke contexten. Deze taak van het volgende woord voorspellen is ook de basis van chatbots zoals ChatGPT. Voordat een chatbot een gesprek kan voeren of vragen kan beantwoorden, moet hij eerst de patronen van taal leren door precies dit te oefenen: het volgende woord voorspellen, keer op keer, op enorme hoeveelheden tekst.

Wat een taalmodel groter of kleiner maakt, draait om **parameters**: getallen binnenin het model die tijdens de training worden aangepast. Zie ze als kleine draaiknoppen. Elke knop regelt een klein deel van hoe het model reageert op een woord of patroon. Meer knoppen betekent kleinere verschillen en subtielere patronen. Minder knoppen betekent een ruwer, vager beeld van de taal.

De modellen in dit spel zijn klein en verouderd. Het Engelse model (Pythia, uit 2023) heeft ongeveer 410 miljoen parameters. De Nederlandse en Spaanse modellen zijn gebaseerd op GPT-2 (uit 2019) en hebben elk ongeveer 125 miljoen parameters. Dat klinkt als veel, totdat je hoort dat de krachtigste modellen van ChatGPT ongeveer zo'n 1,8 *biljoen* parameters hebben — ongeveer 4.000 keer meer dan Pythia. Een beetje als het verschil tussen een fiets en een groot vliegtuig.

Waarom gebruiken we dan niet de grote modellen? Omdat de modellen in dit spel *lokaal* moeten draaien, hier in je browser, op je eigen computer. ChatGPT draait op enorme servers, datacenters vol gespecialiseerde hardware beheerd door bedrijven als OpenAI. De modellen hier zijn klein genoeg om te downloaden en op een gewone laptop te draaien, of zelfs op een telefoon.

Het Engelse model doet het door zijn grotere omvang iets beter. Maar de kleinere Nederlandse en Spaanse modellen zijn getraind op tekst in hun eigen taal, en doen het dus veel beter wanneer de zin in die taal is — precies wat je zou verwachten.

---

## Vogels en vliegtuigen

::: {layout="[2,1]" layout-valign="center"}
Zijn menselijke hersenen en taalmodellen hetzelfde? Absoluut niet. Ze zijn zo verschillend als vogels en vliegtuigen. De een leeft en is het resultaat van miljoenen jaren evolutie; de ander is de ander is door mensen ontworpen en gemaakt van metaal. Ze hebben ook heel verschillende redenen om te vliegen. Maar ze vliegen allebei, en ze slagen daar allebei in omdat ze dezelfde natuurkunde gebruiken: aerodynamica, de manier waarop lucht om een vleugel stroomt.

![Afbeelding gemaakt met ChatGPT (OpenAI).](birds-and-planes-chatgpt.png)
:::

Het bestuderen van vliegtuigen kan ons veel leren over het *medium* waar vogels doorheen vliegen. Niet over veren of spieren, maar over de lucht zelf — wat vliegen mogelijk maakt.

Iets vergelijkbaars is er aan de hand met taalmodellen en menselijke hersenen. Ze zijn totaal anders gebouwd, maar ze bewegen zich allebei door hetzelfde: **taal**. Door te bestuderen wat een model voorspelbaar of verrassend vindt, leren we over de patronen in de taal: wat waar meestal voorkomt, wat gewoon is en wat ongebruikelijk is. Dat zijn dezelfde patronen die bepalen hoe onze hersenen woorden verwerken. In zekere zin meet de score van het spel dit ook: wie het beste overeenkomt met de statistische patronen van de taal, scoort het hoogst.

Hoe ver deze gelijkenis gaat, is een open vraag. Sommige onderzoekers vinden dat taalmodellen zo anders zijn dan hersenen dat het misleidend is om ze te vergelijken. Anderen denken dat de overeenkomsten dieper gaan dan je zou verwachten. Dit is nog niet uitgezocht, en het is een boeiende open vraag in dit onderzoek op dit moment.

---

[*Bruno Nicenboim*](https://bruno.nicenboim.me/) *— Computationele Cognitiewetenschap, Tilburg Universiteit*

[*Lenneke Lichtenberg*](https://research.tilburguniversity.edu/en/persons/lenneke-lichtenberg/) *— Communicatie en Cognitie, Tilburg Universiteit* 
