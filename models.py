from database import db
from datetime import datetime

class Personnel:
    """Modèle pour la table personnel"""
    
    @staticmethod
    def create(nom, prenom, email, numeroTelephone=None, adresse=None, 
               codePostal=None, ville=None, niveauEtudeEleve=None, photo=None, dateNaissance=None):
        """Créer un nouveau personnel"""
        query = """
            INSERT INTO personnel 
            (nom, prenom, email, numeroTelephone, adresse, codePostal, ville, 
             niveauEtudeEleve, photo, dateNaissance, actif)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 1)
        """
        args = (nom, prenom, email, numeroTelephone, adresse, codePostal, ville, 
                niveauEtudeEleve, photo, dateNaissance)
        return db.execute_update(query, args)
    
    @staticmethod
    def get_all(actif_only=True):
        """Récupérer tous les personnels"""
        query = "SELECT * FROM personnel"
        if actif_only:
            query += " WHERE actif = 1"
        query += " ORDER BY nom, prenom"
        return db.execute_query(query)
    
    @staticmethod
    def get_by_id(id_personnel):
        """Récupérer un personnel par ID"""
        query = "SELECT * FROM personnel WHERE id_personnel = %s"
        result = db.execute_query(query, (id_personnel,))
        return result[0] if result else None
    
    @staticmethod
    def get_by_email(email):
        """Récupérer un personnel par email"""
        query = "SELECT * FROM personnel WHERE email = %s"
        result = db.execute_query(query, (email,))
        return result[0] if result else None
    
    @staticmethod
    def update(id_personnel, **kwargs):
        """Mettre à jour un personnel"""
        allowed_fields = ['nom', 'prenom', 'email', 'numeroTelephone', 'adresse', 
                         'codePostal', 'ville', 'niveauEtudeEleve', 'photo', 'dateNaissance', 'actif']
        
        fields = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not fields:
            return 0
        
        set_clause = ", ".join([f"{k} = %s" for k in fields.keys()])
        query = f"UPDATE personnel SET {set_clause} WHERE id_personnel = %s"
        args = list(fields.values()) + [id_personnel]
        return db.execute_update(query, args)
    
    @staticmethod
    def delete(id_personnel):
        """Supprimer un personnel (soft delete)"""
        query = "UPDATE personnel SET actif = 0 WHERE id_personnel = %s"
        return db.execute_update(query, (id_personnel,))

class Poste:
    """Modèle pour la table poste"""
    
    @staticmethod
    def create(fonction, departement=None, specialite=None, niveauRequis=None, 
               description=None, nombrePostesDisponibles=1, dureeContratPrevu=None):
        """Créer un nouveau poste"""
        query = """
            INSERT INTO poste 
            (fonction, departement, specialite, niveauRequis, description, 
             nombrePostesDisponibles, dureeContratPrevu)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        args = (fonction, departement, specialite, niveauRequis, description, 
                nombrePostesDisponibles, dureeContratPrevu)
        return db.execute_update(query, args)
    
    @staticmethod
    def get_all():
        """Récupérer tous les postes"""
        query = "SELECT * FROM poste ORDER BY fonction"
        return db.execute_query(query)
    
    @staticmethod
    def get_by_id(id_post):
        """Récupérer un poste par ID"""
        query = "SELECT * FROM poste WHERE id_post = %s"
        result = db.execute_query(query, (id_post,))
        return result[0] if result else None
    
    @staticmethod
    def update(id_post, **kwargs):
        """Mettre à jour un poste"""
        allowed_fields = ['fonction', 'departement', 'specialite', 'niveauRequis', 
                         'description', 'nombrePostesDisponibles', 'dureeContratPrevu']
        
        fields = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not fields:
            return 0
        
        set_clause = ", ".join([f"{k} = %s" for k in fields.keys()])
        query = f"UPDATE poste SET {set_clause} WHERE id_post = %s"
        args = list(fields.values()) + [id_post]
        return db.execute_update(query, args)
    
    @staticmethod
    def delete(id_post):
        """Supprimer un poste"""
        query = "DELETE FROM poste WHERE id_post = %s"
        return db.execute_update(query, (id_post,))

class Annonce:
    """Modèle pour la table annonce"""
    
    @staticmethod
    def create(datePublication, dateCloturePostulation, id_post, dateClotureAnnonce=None, 
               nombrePostes=1, id_statut=1):
        """Créer une nouvelle annonce"""
        query = """
            INSERT INTO annonce 
            (datePublication, dateCloturePostulation, dateClotureAnnonce, 
             nombrePostes, id_post, id_statut)
            VALUES (%s, %s, %s, %s, %s, %s)
        """
        args = (datePublication, dateCloturePostulation, dateClotureAnnonce, 
                nombrePostes, id_post, id_statut)
        return db.execute_update(query, args)
    
    @staticmethod
    def get_all():
        """Récupérer toutes les annonces"""
        query = """
            SELECT a.*, p.fonction, sa.libelle as statut 
            FROM annonce a
            LEFT JOIN poste p ON a.id_post = p.id_post
            LEFT JOIN statut_annonce sa ON a.id_statut = sa.id_statut
            ORDER BY a.datePublication DESC
        """
        return db.execute_query(query)
    
    @staticmethod
    def get_by_id(id_annonce):
        """Récupérer une annonce par ID"""
        query = """
            SELECT a.*, p.fonction, sa.libelle as statut 
            FROM annonce a
            LEFT JOIN poste p ON a.id_post = p.id_post
            LEFT JOIN statut_annonce sa ON a.id_statut = sa.id_statut
            WHERE a.id_annonce = %s
        """
        result = db.execute_query(query, (id_annonce,))
        return result[0] if result else None
    
    @staticmethod
    def get_active():
        """Récupérer les annonces actives"""
        query = """
            SELECT a.*, p.fonction, sa.libelle as statut 
            FROM annonce a
            LEFT JOIN poste p ON a.id_post = p.id_post
            LEFT JOIN statut_annonce sa ON a.id_statut = sa.id_statut
            WHERE a.id_statut = 1 AND a.dateCloturePostulation >= CURDATE()
            ORDER BY a.datePublication DESC
        """
        return db.execute_query(query)
    
    @staticmethod
    def update(id_annonce, **kwargs):
        """Mettre à jour une annonce"""
        allowed_fields = ['datePublication', 'dateCloturePostulation', 'dateClotureAnnonce',
                         'nombrePostes', 'id_post', 'id_statut']
        
        fields = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not fields:
            return 0
        
        set_clause = ", ".join([f"{k} = %s" for k in fields.keys()])
        query = f"UPDATE annonce SET {set_clause} WHERE id_annonce = %s"
        args = list(fields.values()) + [id_annonce]
        return db.execute_update(query, args)
    
    @staticmethod
    def delete(id_annonce):
        """Supprimer une annonce"""
        query = "DELETE FROM annonce WHERE id_annonce = %s"
        return db.execute_update(query, (id_annonce,))

class Candidature:
    """Modèle pour la table candidature"""
    
    @staticmethod
    def create(id_annonce, id_personnel, cheminCv=None, cheminLettreMotivation=None, 
               id_statut=1, observations=None):
        """Créer une nouvelle candidature"""
        query = """
            INSERT INTO candidature 
            (id_annonce, id_personnel, cheminCv, cheminLettreMotivation, id_statut, observations)
            VALUES (%s, %s, %s, %s, %s, %s)
        """
        args = (id_annonce, id_personnel, cheminCv, cheminLettreMotivation, id_statut, observations)
        return db.execute_update(query, args)
    
    @staticmethod
    def get_all():
        """Récupérer toutes les candidatures"""
        query = """
            SELECT c.*, p.nom, p.prenom, p.email, a.id_post, po.fonction,
                   sc.libelle as statut
            FROM candidature c
            LEFT JOIN personnel p ON c.id_personnel = p.id_personnel
            LEFT JOIN annonce a ON c.id_annonce = a.id_annonce
            LEFT JOIN poste po ON a.id_post = po.id_post
            LEFT JOIN statut_candidature sc ON c.id_statut = sc.id_statut
            ORDER BY c.dateCandidature DESC
        """
        return db.execute_query(query)
    
    @staticmethod
    def get_by_id(id_candidature):
        """Récupérer une candidature par ID"""
        query = """
            SELECT c.*, p.nom, p.prenom, p.email, a.id_post, po.fonction,
                   sc.libelle as statut
            FROM candidature c
            LEFT JOIN personnel p ON c.id_personnel = p.id_personnel
            LEFT JOIN annonce a ON c.id_annonce = a.id_annonce
            LEFT JOIN poste po ON a.id_post = po.id_post
            LEFT JOIN statut_candidature sc ON c.id_statut = sc.id_statut
            WHERE c.id_candidature = %s
        """
        result = db.execute_query(query, (id_candidature,))
        return result[0] if result else None
    
    @staticmethod
    def get_by_annonce(id_annonce):
        """Récupérer les candidatures pour une annonce"""
        query = """
            SELECT c.*, p.nom, p.prenom, p.email,
                   sc.libelle as statut
            FROM candidature c
            LEFT JOIN personnel p ON c.id_personnel = p.id_personnel
            LEFT JOIN statut_candidature sc ON c.id_statut = sc.id_statut
            WHERE c.id_annonce = %s
            ORDER BY c.dateCandidature DESC
        """
        return db.execute_query(query, (id_annonce,))
    
    @staticmethod
    def update(id_candidature, **kwargs):
        """Mettre à jour une candidature"""
        allowed_fields = ['dateExamen', 'id_statut', 'observations']
        
        fields = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not fields:
            return 0
        
        set_clause = ", ".join([f"{k} = %s" for k in fields.keys()])
        query = f"UPDATE candidature SET {set_clause} WHERE id_candidature = %s"
        args = list(fields.values()) + [id_candidature]
        return db.execute_update(query, args)
    
    @staticmethod
    def delete(id_candidature):
        """Supprimer une candidature"""
        query = "DELETE FROM candidature WHERE id_candidature = %s"
        return db.execute_update(query, (id_candidature,))

class Contrat:
    """Modèle pour la table contrat"""
    
    @staticmethod
    def create(id_personnel, typeContrat, montantSalaire, dateDebut, 
               typeRemuneration=None, dateFin=None, id_statut=1, dureeHebrdo=None, avantages=None):
        """Créer un nouveau contrat"""
        query = """
            INSERT INTO contrat 
            (id_personnel, typeContrat, montantSalaire, typeRemuneration, dateDebut, 
             dateFin, id_statut, dureeHebrdo, avantages)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        args = (id_personnel, typeContrat, montantSalaire, typeRemuneration, dateDebut,
                dateFin, id_statut, dureeHebrdo, avantages)
        return db.execute_update(query, args)
    
    @staticmethod
    def get_all():
        """Récupérer tous les contrats"""
        query = """
            SELECT c.*, p.nom, p.prenom, sc.libelle as statut
            FROM contrat c
            LEFT JOIN personnel p ON c.id_personnel = p.id_personnel
            LEFT JOIN statut_contrat sc ON c.id_statut = sc.id_statut
            ORDER BY c.dateDebut DESC
        """
        return db.execute_query(query)
    
    @staticmethod
    def get_by_id(id_contrat):
        """Récupérer un contrat par ID"""
        query = """
            SELECT c.*, p.nom, p.prenom, sc.libelle as statut
            FROM contrat c
            LEFT JOIN personnel p ON c.id_personnel = p.id_personnel
            LEFT JOIN statut_contrat sc ON c.id_statut = sc.id_statut
            WHERE c.id_contrat = %s
        """
        result = db.execute_query(query, (id_contrat,))
        return result[0] if result else None
    
    @staticmethod
    def get_by_personnel(id_personnel):
        """Récupérer les contrats d'un personnel"""
        query = """
            SELECT c.*, sc.libelle as statut
            FROM contrat c
            LEFT JOIN statut_contrat sc ON c.id_statut = sc.id_statut
            WHERE c.id_personnel = %s
            ORDER BY c.dateDebut DESC
        """
        return db.execute_query(query, (id_personnel,))
    
    @staticmethod
    def update(id_contrat, **kwargs):
        """Mettre à jour un contrat"""
        allowed_fields = ['typeContrat', 'montantSalaire', 'typeRemuneration', 'dateDebut',
                         'dateFin', 'id_statut', 'dureeHebrdo', 'avantages']
        
        fields = {k: v for k, v in kwargs.items() if k in allowed_fields}
        if not fields:
            return 0
        
        set_clause = ", ".join([f"{k} = %s" for k in fields.keys()])
        query = f"UPDATE contrat SET {set_clause} WHERE id_contrat = %s"
        args = list(fields.values()) + [id_contrat]
        return db.execute_update(query, args)
    
    @staticmethod
    def delete(id_contrat):
        """Supprimer un contrat"""
        query = "DELETE FROM contrat WHERE id_contrat = %s"
        return db.execute_update(query, (id_contrat,))
