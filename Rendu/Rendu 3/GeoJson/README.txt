***Reg�n�ration du fichier de coordonn�es:
J'ai g�n�r� de nouveau le fichier de coordonn�es car dans l'exemple suivant du json ils existent 
plusieurs param�tres qui ne figure pas dans le fichier coordon�es qu'on a g�n�r� dans le livrable3.



***Le fichier .xsl prend en entr� les deux fichiers .XML : pralognan et coordon�es, afin de g�n�rer 
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