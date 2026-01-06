from app import db
from datetime import datetime

class Personne(db.Model):
    __tablename__ = 'personne'
    
    IdPersonne = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(100), nullable=False)
    age = db.Column(db.Integer)
    niveauEtudeMax = db.Column(db.String(100))
    statu_Matrimonial = db.Column(db.String(50))
    numero_telephone = db.Column(db.String(20))
    photo = db.Column(db.String(255))
    
    # Relations
    contrats = db.relationship('Contrat', backref='personne', lazy=True)
    postes = db.relationship('PersonnePoste', backref='personne', lazy=True)

class Poste(db.Model):
    __tablename__ = 'poste'
    
    IdPoste = db.Column(db.Integer, primary_key=True)
    fonction = db.Column(db.String(100), nullable=False)
    niveau_etude_requis = db.Column(db.String(100))
    description_tache = db.Column(db.Text)
    
    # Relations
    annonces = db.relationship('Annonce', backref='poste', lazy=True)
    personnes = db.relationship('PersonnePoste', backref='poste', lazy=True)

class Annonce(db.Model):
    __tablename__ = 'annonce'
    
    IdAnnonce = db.Column(db.Integer, primary_key=True)
    DatePubliation = db.Column(db.Date, nullable=False)
    DelaiDepotCandidature = db.Column(db.Date, nullable=False)
    IdPoste = db.Column(db.Integer, db.ForeignKey('poste.IdPoste'), nullable=False)
    
    # Relations
    contrats = db.relationship('Contrat', backref='annonce', lazy=True)

class Contrat(db.Model):
    __tablename__ = 'contrat'
    
    IdCandidature = db.Column(db.Integer, primary_key=True)
    cv = db.Column(db.String(255))
    lettremotivation = db.Column(db.Text)
    status = db.Column(db.String(50), default='En attente')
    date_candidature = db.Column(db.DateTime, default=datetime.utcnow)
    IdAnnonce = db.Column(db.Integer, db.ForeignKey('annonce.IdAnnonce'), nullable=False)
    IdPersonne = db.Column(db.Integer, db.ForeignKey('personne.IdPersonne'), nullable=False)

class PersonnePoste(db.Model):
    __tablename__ = 'personneposte'
    
    IdPersonnePoste = db.Column(db.Integer, primary_key=True)
    DatePriseService = db.Column(db.Date, nullable=False)
    IdPersonne = db.Column(db.Integer, db.ForeignKey('personne.IdPersonne'), nullable=False)
    IdPoste = db.Column(db.Integer, db.ForeignKey('poste.IdPoste'), nullable=False)
