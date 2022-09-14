# MY WEATHER
Il progetto realizzato per la parte IOS del corso MobDev consiste in un'applicazione meteo in *objective c* utilizzando *Xcode*.
## Features principali ed esempi applicativi
Con l'app **MyWeather** è possibile:

 - Vedere le informazioni meteo della posizione attuale di oggi e dei prossimi 3 giorni <br />
 //inserire gi
 - Cercare una città e vedere le sue previsioni meteo <br />
  // inserire gif
 - Salvare una città in una lista di preferiti <br />
 // inserire gif
 - Visualizzare le città preferite in una mappa e vedere il meteo del giorno tramite un'annotazione <br />
 // inserire gif

## Uno sguardo da vicino
L'applicazione è basata sul modello **MVC**: **M**odel, **V**iew, **C**ontroller.
### Model
Il *model* si occupa di definire i dati dell'applicazione. <br />
Le classi *City*,*CityList* e *Forecast* costituiscono il model dell'applicazione. Ho deciso di usare una classe Forecast per gestire in modo **asincrono** l'acquisizione delle informazioni meteo tramite *open.meteo API* e garantire un utilizzo fluido dell'applicazione all'utente. <br />
L'utilizzo dell'API avviene tramite **serializzazione JSON**. 
### View e Controller
Le *view* visualizzano i dati contenuti nel model e "catturano" l'interazione dell'utente con l'applicazione, i *controller* sono il cervello dell'applicazione: forniscono il collegamento tra view e model, gestiscono gli input dell'utente mandati dalla view e mandano al model eventuali aggiornamenti. <br />
L'utilizzo di un **UInavigation controller** permette di gestire in maniera rapida ed intuitiva l'uso di views multiple mediante la struttura a stack (Logica LIFO). <br />
//immagine storyboard
Sono presenti 4 view controller:
 -  **MyWeatherTableViewController**: è un *UITableViewController statico*, primo controller dello stack, si occupa di mostrare il meteo attuale e le previsioni dei giorni futuri della città (che può essere stata seleziona oppure ricavata dalla posizione attuale).<br />
 Questa view attua la registrazione del *LocationManager* per ricavare la posizione attuale dell'utente e registra il controller all'ascolto delle notifiche mandate dalla classe *Forecast* una volta ultimata la richiesta delle informazioni meteo tramite API per aggiornare la view. <br />
 Durante l'avvio della view (metodo "*viewDidLoaded*") il controller recupera tramite file la lista delle città preferite (3 array che gestiscono nomi,latitudine e longitudine), da mandare tramite segue ai controller  (se i file non esistono vengono creati).<br />
 I tasti sulla *navigation bar* permettono di avviare le segues per i rispettivi view controller.
 - **SearchCityViewController**, viene chiamato tramite segues modale dal MyweatherTableViewController. E' una *UIView* che consente la ricerca della città su una **operation queue** che crea una *MKLocalSearchRequest* che si occupa di eseguire una *NaturalLanguageQuery* con la città inserita nell'apposita searchbar.<br />
 I risultati sono visualizzati su una *UITableView dinamica* con una sezione e numero di righe pari al numero di risultati ottenuti dalla ricerca. E' presente un listener che cattura il click su una cella della TableView che permette di mandare una notifica al MyWeatherTableViewController che stanzia una richiesta al Forecast per mostrare il meteo. <br />
 Una volta terminata l'operazione il SearchCityViewController riceve a sua volta una notifica per eseguire il pop di se stesso dallo stack del NavigationController.
 \\inserire immagine SearhCityViewController
