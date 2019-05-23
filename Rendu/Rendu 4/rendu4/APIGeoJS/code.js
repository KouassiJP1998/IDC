//Main document
var tableFichiersInit = ["./XMLFiles/1e_jour_de_pralognan_au_refuge_de_la_lei.xml",
                          "./XMLFiles/1ere_etape_du_chemin_vers_saint_jacques_.xml",
                        "./XMLFiles/1ere_etape_du_tmb.xml",
                      "./XMLFiles/2e_jour_du_refuge_de_la_leisse_au_refuge.xml",
                    "./XMLFiles/4eme_etape_du_tmb.xml",
                  "./XMLFiles/7eme_etape_du_tmb.xml",
                "./XMLFiles/alentours_d_hennebont_et_le_chemin_de_ha.xml",
              "./XMLFiles/au_depart_de_la_pointe_du_millier.xml",
            "./XMLFiles/au_depart_de_merrien.xml"];//liste des fichiers que l'on veut traiter

var tablePlaceName = [];
var id=0;
var tableauNom = [];

//Quand toute la page est chargée
window.onload = function(){
  console.log("test");
  //On récupère tous les placeName des differents fichiers
  for (var i = 0; i < tableFichiersInit.length; i++){
    recupFichierXMLNpm(tableFichiersInit[i]);
  }

//Pour chaque nom on essaye de le trouver sur

  for (var i = 0; i < tableauNom.length; i++) {
    APIrequest(tableauNom[i]);
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

//Fonction récuperation nom propres
function recupFichierXMLNpm(url){
  var id = 0;
  $.ajax({
      url: url,
      type: "GET",
      async: false, // Mode synchrone
      dataType: "xml",
      success: function(xml)
      {
        $(xml).find('Npr').each(function()
        {
          //si placeName a une clef
            trouve = false;

            var nom = $(this).attr('nom');

            var lieu = new Object();;
            lieu.nom = nom;
            lieu.url = url;
            lieu.id = id;

            //Vérification des doublons
            for (var i = 0; i < tableauNom.length; i++) {
              if (tableauNom[i].nom == lieu.nom && trouve == false && tableauNom[i].url == lieu.url) {
                trouve = true;
              }
            }

            //le phr n'existe pas pour ce document
            if (!trouve) {
              tableauNom.push(lieu);
              id++;
            }
        });
      }
  });

  console.log(tableauNom);
}

function APIrequest(lieu){
    var trouve = false;

    var id = lieu.id;
    var adresse = lieu.url;
    var key;
    //openStreetMap
    if (!trouve){

    }
    //Géoportal
    if (!trouve){

    }
    //geoname
    if (!trouve){

      var lien = "http://api.geonames.org/search?name= " + lieu.nom + "&country=FR&username=unipau";



      $.ajax({
          url: lien,
          type: "GET",
          async: false, // Mode synchrone
          dataType: "xml",
          success: function(xml)
          {

            //var racine = xml.documentElement;
            //var geoname = racine.getElementsByTagName("geoname");
            var racine = xml.documentElement;
            var geonameList = racine.getElementsByTagName("geoname");
            //var enfantgeo = enfants.getElementsByTagName("geoname");

            console.log("------------------------");



            $(xml).find('geoname').each(function()
            {

              if (!trouve) {
                $(this).find('name').each(function(){
                  if ($(this).text() == lieu.nom) {
                    trouve = true;
                    console.log($(this).text());
                  }
                });

                if (trouve) {

                  $(this).find('geonameId').each(function(){
                    key = "geonames " + $(this).text();
                    console.log(key);
                  });
                }
              }

            });
          }
      });
    }

    if (trouve) {
      console.log();
      console.log(key + adresse + id);
      var newPlace = new PlaceName(id, key, adresse);

      var find = false;

      //var newPlace = new PlaceName(id, key, adresse);

      //Vérification des doublons
      for (var i = 0; i < tablePlaceName.length; i++) {
        if (tablePlaceName[i].key == newPlace.key && find == false) {
          tablePlaceName[i].addDocument(id, adresse);
          trouve = true;
        }
      }

      //le placeName n'existe pas
      if (!find) {

        newPlace.addDocument(id, adresse);
        tablePlaceName.push(newPlace);
      }
    }

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
