//Classe qui definie un point
class Point{

  constructor(latitude, longitude, nom, place, altitude){

    Object.defineProperty(this, "nom", {value: nom, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "place", {value: place, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "latitude", {value: latitude, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "longitude", {value: longitude, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "altitude", {value: altitude, enumerable: true, configurable: false, writable: true});

  }
}
