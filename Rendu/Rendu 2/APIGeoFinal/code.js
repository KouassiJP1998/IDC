//Main document
var tableFichiersInit = ["./XMLFiles/fr_leisse.xml","./XMLFiles/fr_pralognan.xml"] //liste des fichiers que l'on veut traiter
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
  parseToXML();
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
          if($(this).attr('key') != null){
            var test = new PlaceName(id, $(this).attr('key'),$(this).attr('xml:id'),$(this).attr('ref'),url);

            var trouve = false;

            //Vérification des doublons
            for (var i = 0; i < tablePlaceName.length; i++) {
              if (tablePlaceName[i].key == test.key) {
                trouve = true;
                console.log("find !");
              }
            }

            if (!trouve) {
              tablePlaceName.push(test);
              id++;
            }
          }
        });
      }
  });
}

//Fonction qui parse le tout en XML
function parseToXML(){

  var doc = document.implementation.createDocument("", "", null);
  var liste = doc.createElement("liste");

  for (var i = 0; i < tablePlaceName.length; i++) {

      var placeNameAdd = tablePlaceName[i];

      var placeNameElem = doc.createElement("Lieu");
      placeNameElem.setAttribute("id",placeNameAdd.id);
      placeNameElem.setAttribute("idOrigine",placeNameAdd.idOrigine);
      placeNameElem.setAttribute("lien",placeNameAdd.lienSite);
      placeNameElem.setAttribute("docOrigine",placeNameAdd.documentOrigine);
      placeNameElem.setAttribute("key",placeNameAdd.key);

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
