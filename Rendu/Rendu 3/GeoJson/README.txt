***Regénération du fichier de coordonnées:
J'ai généré de nouveau le fichier de coordonnées car dans l'exemple suivant du json ils existent 
plusieurs paramétres qui ne figure pas dans le fichier coordonées qu'on a généré dans le livrable3.



***Le fichier .xsl prend en entré les deux fichiers .XML : pralognan et coordonées, afin de générer 
un fichier de format json comme la suivante : 
{
  "totalResultsCount": 4,
  "geonames": [
    {
      "lng": "6.7193",
      "geonameId": 2985610,
      "countryCode": "FR",
      "name": "Pralognan-la-Vanoise",
      "toponymName": "Pralognan-la-Vanoise",
      "lat": "45.38184",
      "fcl": "P",
      "fcode": "PPL"
    }]

Cette forme est valide par l'outils de visualisation Geojson.