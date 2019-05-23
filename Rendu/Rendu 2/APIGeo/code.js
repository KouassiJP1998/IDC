var tableFichiersInit = ["./XMLFiles/recupLieux.xml","./XMLFiles/recupLieux2.xml"]
var tablePlaceName = [];
var id=0;

window.onload = function(){

  for (var i = 0; i < tableFichiersInit.length; i++){
    recupFichierXmlInitial2(tableFichiersInit[i]);
  }

  for (var i = 0; i < tablePlaceName.length; i++) {
    tablePlaceName[i].addPoints();
  }
  console.log(tablePlaceName);
  parseToXML();
}

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
            id++;
            tablePlaceName.push(test);
          }
        });
      }
  });
}

function recupInfos(){
  for (var i = 0; i < tablePlaceName.length; i++) {
    tablePlaceName[i].addPoints();
  }
}

function test(){
  var request = new XMLHttpRequest();
  var url="https://www.openstreetmap.org/api/0.6/node/249838326";
  request.responseType = 'xml';
  request.open('GET', url);
  request.send();

  request.onload = function(){
    var result = [];
    var xmlDoc = request.responseXML;
    console.log(xmlDoc);
  }
}

function parseToXML(){

  var doc = document.implementation.createDocument("", "", null);
  var liste = doc.createElement("liste");

  for (var i = 0; i < tablePlaceName.length; i++) {

      var placeNameAdd = tablePlaceName[i];

      var placeNameElem = doc.createElement("placeName");
      placeNameElem.setAttribute("id",placeNameAdd.id);
      placeNameElem.setAttribute("idOrigine",placeNameAdd.idOrigine);
      placeNameElem.setAttribute("lien",placeNameAdd.lienSite);
      placeNameElem.setAttribute("docOrigine",placeNameAdd.documentOrigine);
      placeNameElem.setAttribute("key",placeNameAdd.key);

      for (var j = 0; j < placeNameAdd.points.length; j++) {

        var pointElement = doc.createElement("point");
        if (placeNameAdd.points[j].nom != null) {
            pointElement.setAttribute("name",placeNameAdd.points[j].nom);
        }
        if (placeNameAdd.points[j].place != null) {
            pointElement.setAttribute("place",placeNameAdd.points[j].place);
        }

        pointElement.setAttribute("latitude",placeNameAdd.points[j].latitude);
        pointElement.setAttribute("longitude",placeNameAdd.points[j].longitude);

        placeNameElem.appendChild(pointElement);

      }

      liste.appendChild(placeNameElem);
  }

  doc.appendChild(liste);

  document.getElementById('xml').innerHTML = "<xmp><?xml version=\"1.0\" encoding=\"UTF-8\"?></xmp>";

  var xmlText = new XMLSerializer().serializeToString(doc);
  var xmlTextNode = document.createTextNode(xmlText);
  var parentDiv = document.getElementById('xml');
  parentDiv.appendChild(xmlTextNode);

  console.log(xmlText);

}
