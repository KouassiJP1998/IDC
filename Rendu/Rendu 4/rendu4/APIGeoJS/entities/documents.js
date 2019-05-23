class Document{

  constructor(docOrigine){

    Object.defineProperty(this, "docOrigine", {value: docOrigine, enumerable: true, configurable: false, writable: true});
    Object.defineProperty(this, "listeIdOrigine", {value: null, enumerable: true, configurable: false, writable: true});

    this.listeIdOrigine = [];

  }
}

Document.prototype.addIdOrigine = function(idOrigine){
  this.listeIdOrigine.push(idOrigine);
}
