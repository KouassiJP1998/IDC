//Classe qui definie une placeName
class PlaceName{

  constructor(id, key, idOrigine, adresse, doc){

    Object.defineProperty(this, "key", {value: null, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "type", {value: null, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "id", {value: null, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "idOrigine", {value: null, enumerable: true, configurable: false, writable: true});

    Object.defineProperty(this, "documentOrigine", {value: null, enumerable: true, configurable: false, writable: true});

    Object.defineProperty(this, "site", {value: null, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "lienSite", {value: null, enumerable: true, configurable: false, writable: true});

    Object.defineProperty(this, "points", {value: null, enumerable: true, configurable: false, writable: true});

    this.points = [];

    this.setId(id);
    this.setType(adresse);
    this.setKey(key);
    this.setIdOrigine(idOrigine);
    this.setSite(key);
    this.setDocOrigine(doc);
  }
}

//Ajout d'un point a partir de l'url
PlaceName.prototype.addPoints = function () {

  var nom = "unknown";
  var place = "unknown";
  var altitude = "unknown";

  //si l'url indique un simple noeud
  if (this.type == "node"){
    this.addOnepoint(-1, nom, place, altitude);
  }else { //si l'url indique un ensemble de noeud
    this.addMultiPoints(nom, place, altitude);
  }
};

//Ajout de plusieurs points
PlaceName.prototype.addMultiPoints = function (nom, place, altitude) {

  var url = this.getURL();
  var listeInfoPointsRef = [];

  //Récuperation de la liste des noeuds qui constituent la route
  $.ajax({
      url: url,
      type: "GET",
      async: false, // Mode synchrone
      dataType: "xml",
      success: function(xml)
      {
        $(xml).find('nd').each(function(){
            listeInfoPointsRef.push($(this).attr('ref'));
        })

        $(xml).find('tag').each(function()
        {
          if ($(this).attr('k') == "name"){
            nom = $(this).attr('v')
          }
          if ($(this).attr('k') == "place"){
            place = $(this).attr('v')
          }
          if ($(this).attr('k') == "ele"){
            altitude = $(this).attr('v')
          }
        });
      }
    });

    console.log(listeInfoPointsRef);

    //Ajout de chaque noeud
    for (var i = 0; i < listeInfoPointsRef.length; i++) {
      this.addOnepoint(listeInfoPointsRef[i],nom, place, altitude);
    }
};

//Ajout de plusieurs d'un seul point
PlaceName.prototype.addOnepoint = function(param, nom, place, altitude){

  if (param == -1) {
      var url = this.getURL();
  }
  else {
    this.lienSite = this.getURL();
    var url = "https://www.openstreetmap.org/api/0.6/node/" + param;
  }

  var point;

  //si source == openstreetmap
  if(this.site == "openstreetmap"){
    $.ajax({
        url: url,
        type: "GET",
        async: false, // Mode synchrone
        dataType: "xml",
        success: function(xml)
        {
          var latitude;
          var longitude;

          $(xml).find('node').each(function()
          {
              latitude = $(this).attr('lat');
              longitude = $(this).attr('lon');
          });

          $(xml).find('tag').each(function()
          {
            if ($(this).attr('k') == "name"){
              nom = $(this).attr('v')
            }
            if ($(this).attr('k') == "place"){
              place = $(this).attr('v')
            }
            if ($(this).attr('k') == "ele"){
              altitude = $(this).attr('v')
            }
          });

          point = new Point(latitude, longitude, nom, place, altitude);
        }
    });
  }

  //si source == geonames
  else{

    $.ajax({
        url: url,
        type: "GET",
        async: false, // Mode synchrone
        dataType: "xml",
        success: function(xml)
        {
          var latitude;
          var longitude;
          console.log("coucou");

          $(xml).find('lat').each(function()
          {
              latitude = $(this).text();
          });

          $(xml).find('lng').each(function()
          {
              longitude = $(this).text();
          });

          $(xml).find('name').each(function()
          {
              nom = $(this).text();
          });

          $(xml).find('elevation').each(function()
          {
              if ($(this).text() != ""){
                  altitude = $(this).text();
              }
          });

          point = new Point(latitude, longitude, nom, place, altitude);
        }
    });
  }

  this.points.push(point);
  console.log(point);

};

PlaceName.prototype.setKey = function(clef) {
  var words = clef.split(' ');
  this.key = words[1];
};

PlaceName.prototype.setType = function (type) {
    if(type.indexOf("way") == -1){
      this.type = "node";
    }else {
      this.type = "way";
    }
};

PlaceName.prototype.setIdOrigine = function (id) {
  this.idOrigine = id;
};

PlaceName.prototype.setId = function (id) {
  this.id = id;
};

PlaceName.prototype.setSite = function (clef) {
  if(clef.indexOf("osm") == -1){
        this.site = "geonames"
  }
  else {
      this.site = "openstreetmap"
  }
};

PlaceName.prototype.setDocOrigine = function (doc) {
    this.documentOrigine = doc;
};

PlaceName.prototype.getURL = function () {
  var url;

  if (this.site == "openstreetmap"){
      url = "https://www.openstreetmap.org/api/0.6/"+ this.type +"/" + this.key;
      this.lienSite = url;
      return url;
  }
  else {
      url = "http://api.geonames.org/get?geonameId="+this.key+"&username=unipau";
      this.lienSite = url;
      return url;
  }
};
