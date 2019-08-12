import 'package:github_search/models/SearchResult.dart';
import 'package:github_search/services/data/GithubService.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {

  GithubService _service = new GithubService();
    
    final _searchController = new BehaviorSubject<String>();
    Observable<String> get searchflux => _searchController.stream;
    Sink<String> get searchEvent => _searchController.sink; 
  
    Observable<SearchResult> apiResultflux;
  
    SearchBloc() { //Essas são as transformações 
      apiResultflux = searchflux
      .distinct()
      .where((valor) => valor.length> 2)
      //.debounce(Duration(milliseconds:500))
      .asyncMap(_service.search)
      .switchMap((valor) => Observable.just(valor)); // Esse switchMap pega a última coisa que o usuário digitou, descarts todas as outroas que que vieram antes, só a última pega.
    }
  
    void dispose(){
      _searchController?.close();
    }
  
  }
  
