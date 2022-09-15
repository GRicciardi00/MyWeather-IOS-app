# MY WEATHER
Progetto per la parte IOS del corso MobDev, consiste in un'applicazione meteo in *objective c* realizzata *Xcode*.
## Features principali ed esempi applicativi
Con l'app **MyWeather** è possibile:

 - Vedere le informazioni meteo della posizione attuale di oggi e dei prossimi 3 giorni <br />
 ![](https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20main%20scene.gif)
 - Cercare una città e vedere le sue previsioni meteo <br />
 ![](https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20search%20city.gif)
 - Salvare una città in una lista dei preferiti <br />
![](https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20add%20favourite.gif)
 - Selezionare una città della lista dei preferiti <br />
 ![](https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20fav%20list.gif)
 - Visualizzare le città preferite in una mappa e vedere il meteo del giorno tramite un'annotazione <br />
 ![](https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/gif%20map%20view%20.gif)

## Uno sguardo da vicino
L'applicazione è basata sul modello **MVC**: **M**odel, **V**iew, **C**ontroller.
### Model
>Il *model* si occupa di definire i dati dell'applicazione. <br />

Le classi *City*,*CityList* e *Forecast* costituiscono il model dell'applicazione. Ho deciso di usare una classe Forecast per gestire in modo **asincrono** l'acquisizione delle informazioni meteo tramite l'API *open.meteo* e garantire un utilizzo fluido dell'applicazione all'utente. <br />
L'utilizzo dell'API avviene tramite **serializzazione JSON**. 
### ViewController
> Le *view* visualizzano i dati contenuti nel model e "catturano" l'interazione dell'utente con l'applicazione, i *controller* sono il cervello dell'applicazione: forniscono il collegamento tra view e model, gestiscono gli input dell'utente mandati dalla view e mandano al model eventuali aggiornamenti. <br />

L'utilizzo di un **UInavigation controller** permette di gestire in maniera rapida ed intuitiva l'uso di views multiple mediante la struttura a stack (Logica LIFO). <br />

<img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/Storyboard.png width="30%" height="30%">

Sono presenti 4 view controller:
 -  **MyWeatherTableViewController**: è un *UITableViewController statico*, primo controller dello stack, si occupa di mostrare il meteo attuale e le previsioni dei giorni futuri della città (che può essere stata seleziona oppure ricavata dalla posizione attuale).<br />
 Questa view attua la registrazione del *LocationManager* per ricavare la posizione attuale dell'utente e registra il controller all'ascolto delle notifiche mandate dalla classe *Forecast* una volta ultimata la richiesta delle informazioni meteo tramite API per aggiornare la view. <br />
 Durante l'avvio della view (metodo "*viewDidLoaded*") il controller recupera tramite file la lista delle città preferite (3 array che gestiscono nomi,latitudine e longitudine), da mandare tramite segue ai controller  (se i file non esistono vengono creati).<br />
 I tasti sulla *navigation bar* permettono di avviare le segues per i rispettivi view controller. <br />
 
 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/mainVC.png width="20%" height="20%">
 
 - **SearchCityViewController**, viene chiamato tramite segues modale dal MyweatherTableViewController. E' una *UIView* che consente la ricerca della città su una **operation queue** che crea una *MKLocalSearchRequest* che si occupa di eseguire una *NaturalLanguageQuery* con la città inserita nell'apposita searchbar.<br />
 I risultati sono visualizzati su una *UITableView dinamica* con una sezione e numero di righe pari al numero di risultati ottenuti dalla ricerca. E' presente un listener che cattura il click su una cella della TableView che permette di mandare una notifica al MyWeatherTableViewController che stanzia una richiesta al Forecast per mostrare il meteo. <br />
 Una volta terminata l'operazione il SearchCityViewController riceve a sua volta una notifica per eseguire il pop di se stesso dallo stack del NavigationController. <br />
 **N.B**: questa operazione di scambio notifiche poteva essere sostituita con l'implementazione di un delegate (tramite definizione di un protocollo) del viewcontroller che segnalava la selezione di una città.
 
 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/FavCitiesVC.png width="20%" height="20%">
 
 -**FavouritesCitiesTableViewController**: è il View Controller che si occupa di mostrare all'utente la lista delle città preferite, si tratta di una *TableView dinamica* con una sezione e numero di righe pari al numero di città presenti negli array mandati da MyWeatherTableViewController durante la segue.<br />
 Quando un'utente seleziona una cella della table view viene applicato lo stesso procedimento spiegato prima per notificare al MyWeatherTableViewController di inizializzare l'oggetto Forecast ed eseguire la transizione per mostrare la view.
<br />

 <img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/SearchVC.png width="20%" height="20%">
 
 - **FavouritesMapViewController**: utilizzato per mostrare la mappa all'utente con le annotazioni posizionate nelle città salvate nei preferiti. Si tratta di un *UIViewController* con all'interno una *MapView*. <br />
Per creare le annotazioni il ViewController riceve durante la segue gli array delle città preferite salvate su file edisegna un'annotazione per ogni coppia di coordinate della città preferite. <br />
E' presente un Listener sul tocco di un'annotazione che procede con la generazione di una richiesta meteo del giorno attuale nella città selezionata.  <br />

<img src=https://github.com/GRicciardi00/MobDev-Giuseppe-Ricciardi-IOS/blob/main/Screenshots/mapVC.png width="20%" height="20%">
