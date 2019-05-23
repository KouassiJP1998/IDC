//Main document
var tableFichiersInit = ["./XMLFiles/fr_leisse.xml","./XMLFiles/fr_pralognan.xml"];//liste des fichiers que l'on veut traiter

var tablePlaceName = [];
var id=0;

//Quand toute la page est chargée
window.onload = function(){

  //On récupère tous les placeName des differents fichiers
  for (var i = 0; i < tableFichiersInit.length; i++){
    recupFichierXmlInitial2(tableFichiersInit[i]);
  }

  //Pour chaque place name récupéré, on ajoute leurs points
  for (var i = 0; i < tablePlaceName.length; i++) {
        tablePlaceName[i].addPoints();
  }

  console.log(tablePlaceName);
  //On parse en XML
  parseToXML2();
}

//Fonction de récuperation des placeName
function recupFichierXmlInitial2(url){
  $.ajax({
      url: url,
      type: "GET",
      async: false, // Mode synchrone
      dataType: "xml",
      success: function(xml)
      {
        $(xml).find('placeName').each(function()
        {
          //si placeName a une clef
          if($(this).attr('key') != null){

            var key = $(this).attr('key');
            var idOrigine = $(this).attr('xml:id');
            var adresse = $(this).attr('ref');

            //var test = new PlaceName(id, $(this).attr('key'),$(this).attr('xml:id'),$(this).attr('ref'),url);
            var trouve = false;

            var newPlace = new PlaceName(id, key, adresse);

            //Vérification des doublons
            for (var i = 0; i < tablePlaceName.length; i++) {
              if (tablePlaceName[i].key == newPlace.key && trouve == false) {
                tablePlaceName[i].addDocument(idOrigine, url);
                trouve = true;
              }
            }

            //le placeName n'existe pas
            if (!trouve) {

              newPlace.addDocument(idOrigine, url);
              tablePlaceName.push(newPlace);
              id++;
            }
          }
        });
      }
  });
  console.log(tablePlaceName);
}

//Fonction qui parse le tout en XML
function parseToXML2(){

  var doc = document.implementation.createDocument("", "", null);
  var liste = doc.createElement("liste");

  for (var i = 0; i < tablePlaceName.length; i++) {

      var placeNameAdd = tablePlaceName[i];

      var placeNameElem = doc.createElement("Lieu");
      placeNameElem.setAttribute("id",placeNameAdd.id);
      placeNameElem.setAttribute("lien",placeNameAdd.lienSite);
      placeNameElem.setAttribute("key",placeNameAdd.key);

      for (var k = 0; k < placeNameAdd.listeDocuments.length; k++) {
        console.log(placeNameAdd);
        var documentElement = doc.createElement("document");
        documentElement.setAttribute("docOrigine", placeNameAdd.listeDocuments[k].docOrigine);

        for (var l = 0; l < placeNameAdd.listeDocuments[k].listeIdOrigine.length; l++) {
          var idOrigineElement = doc.createElement("idOrigine");
          idOrigineElement.setAttribute("idOrigine", placeNameAdd.listeDocuments[k].listeIdOrigine[l]);
          documentElement.appendChild(idOrigineElement);
        }
        placeNameElem.appendChild(documentElement);
      }

      for (var j = 0; j < placeNameAdd.points.length; j++) {

        var pointElement = doc.createElement("point");
        if (placeNameAdd.points[j].nom != "unknown") {
            pointElement.setAttribute("name",placeNameAdd.points[j].nom);
        }
        if (placeNameAdd.points[j].place != "unknown") {
            pointElement.setAttribute("place",placeNameAdd.points[j].place);
        }
        if (placeNameAdd.points[j].altitude != "unknown") {
            pointElement.setAttribute("altitude",placeNameAdd.points[j].altitude);
        }

        pointElement.setAttribute("latitude",placeNameAdd.points[j].latitude);
        pointElement.setAttribute("longitude",placeNameAdd.points[j].longitude);

        placeNameElem.appendChild(pointElement);

      }

      liste.appendChild(placeNameElem);
  }

  doc.appendChild(liste);

  //On affiche le nouveau fichier XML dans le navigateur, il ne reste alors qu'a copier coller le tout dans oxygène et faire une indentation automatique.
  document.getElementById('xml').innerHTML = "<xmp><?xml version=\"1.0\" encoding=\"UTF-8\"?></xmp>";

  var xmlText = new XMLSerializer().serializeToString(doc);
  var xmlTextNode = document.createTextNode(xmlText);
  var parentDiv = document.getElementById('xml');
  parentDiv.appendChild(xmlTextNode);

  console.log(xmlText);

}
