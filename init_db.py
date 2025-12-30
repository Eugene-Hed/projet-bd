#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script d'initialisation de la base de données
Remplit les données de base nécessaires pour que l'application fonctionne correctement
"""

from database import db
from datetime import datetime, timedelta

def init_database():
    """Initialiser la base de données avec les données de base"""
    print("=" * 60)
    print("🔧 INITIALISATION DE LA BASE DE DONNÉES")
    print("=" * 60)
    
    try:
        db.connect()
        cursor = db.connection.cursor()
        
        # 1. Créer les statuts d'annonce
        print("\n📢 Création des statuts d'annonce...")
        statuts_annonce = [
            (1, 'Actif', 'Annonce active et en cours'),
            (2, 'Clôturée', 'Annonce clôturée'),
            (3, 'Brouillon', 'Annonce en brouillon')
        ]
        
        for id_statut, libelle, description in statuts_annonce:
            query = "INSERT IGNORE INTO statut_annonce (id_statut, libelle, description) VALUES (%s, %s, %s)"
            cursor.execute(query, (id_statut, libelle, description))
        
        db.connection.commit()
        print("✅ Statuts d'annonce créés")
        
        # 2. Créer les statuts de candidature
        print("\n📝 Création des statuts de candidature...")
        statuts_candidature = [
            (1, 'En attente', 'Candidature en attente'),
            (2, 'Acceptée', 'Candidature acceptée'),
            (3, 'Refusée', 'Candidature refusée'),
            (4, 'En entretien', 'Candidat en entretien')
        ]
        
        for id_statut, libelle, description in statuts_candidature:
            query = "INSERT IGNORE INTO statut_candidature (id_statut, libelle, description) VALUES (%s, %s, %s)"
            cursor.execute(query, (id_statut, libelle, description))
        
        db.connection.commit()
        print("✅ Statuts de candidature créés")
        
        # 3. Créer les statuts de contrat
        print("\n📄 Création des statuts de contrat...")
        statuts_contrat = [
            (1, 'Actif', 'Contrat actif'),
            (2, 'Résilié', 'Contrat résilié'),
            (3, 'Complété', 'Contrat complété')
        ]
        
        for id_statut, libelle, description in statuts_contrat:
            query = "INSERT IGNORE INTO statut_contrat (id_statut, libelle, description) VALUES (%s, %s, %s)"
            cursor.execute(query, (id_statut, libelle, description))
        
        db.connection.commit()
        print("✅ Statuts de contrat créés")
        
        # 4. Créer un poste de démonstration si nécessaire
        print("\n💼 Vérification des postes...")
        cursor.execute("SELECT COUNT(*) FROM poste")
        poste_count = cursor.fetchone()[0]
        
        if poste_count == 0:
            print("   Aucun poste trouvé, création de postes de démonstration...")
            postes = [
                ('Développeur Python', 'IT', 'Backend', 'Bac+3', 'Développeur Python Senior'),
                ('Développeur JavaScript', 'IT', 'Frontend', 'Bac+3', 'Développeur JavaScript React'),
                ('Chef de Projet', 'Management', 'Gestion', 'Bac+5', 'Chef de Projet Agile'),
                ('Data Scientist', 'IT', 'Data', 'Bac+5', 'Data Scientist Machine Learning'),
                ('Responsable RH', 'RH', 'Recrutement', 'Bac+3', 'Responsable Recrutement')
            ]
            
            for fonction, dept, spec, niveau, desc in postes:
                query = """
                INSERT INTO poste (fonction, departement, specialite, niveauRequis, description)
                VALUES (%s, %s, %s, %s, %s)
                """
                cursor.execute(query, (fonction, dept, spec, niveau, desc))
            
            db.connection.commit()
            print(f"✅ {len(postes)} postes de démonstration créés")
        else:
            print(f"✅ {poste_count} poste(s) existe(nt) déjà")
        
        # 5. Créer un personnel de démonstration si nécessaire
        print("\n👥 Vérification du personnel...")
        cursor.execute("SELECT COUNT(*) FROM personnel")
        personnel_count = cursor.fetchone()[0]
        
        if personnel_count == 0:
            print("   Aucun personnel trouvé, création de personnels de démonstration...")
            personnels = [
                ('Dupont', 'Jean', 'jean.dupont@example.com', '0612345678', 'Paris', 'Bac+5'),
                ('Martin', 'Marie', 'marie.martin@example.com', '0623456789', 'Lyon', 'Bac+4'),
                ('Bernard', 'Pierre', 'pierre.bernard@example.com', '0634567890', 'Marseille', 'Bac+3'),
                ('Durand', 'Sophie', 'sophie.durand@example.com', '0645678901', 'Toulouse', 'Bac+5'),
                ('Moreau', 'Luc', 'luc.moreau@example.com', '0656789012', 'Nice', 'Bac+3')
            ]
            
            for nom, prenom, email, tel, ville, niveau in personnels:
                query = """
                INSERT INTO personnel (nom, prenom, email, numeroTelephone, ville, niveauEtudeEleve, actif)
                VALUES (%s, %s, %s, %s, %s, %s, 1)
                """
                cursor.execute(query, (nom, prenom, email, tel, ville, niveau))
            
            db.connection.commit()
            print(f"✅ {len(personnels)} personnels de démonstration créés")
        else:
            print(f"✅ {personnel_count} personnel(s) existe(nt) déjà")
        
        # 6. Créer une annonce de démonstration si nécessaire
        print("\n📢 Vérification des annonces...")
        cursor.execute("SELECT COUNT(*) FROM annonce")
        annonce_count = cursor.fetchone()[0]
        
        if annonce_count == 0:
            print("   Aucune annonce trouvée, création d'annonce de démonstration...")
            
            # Vérifier qu'il existe au moins un poste
            cursor.execute("SELECT id_post FROM poste LIMIT 1")
            result = cursor.fetchone()
            
            if result:
                today = datetime.now().date()
                closure_date = today + timedelta(days=30)
                
                query = """
                INSERT INTO annonce (datePublication, dateCloturePostulation, id_post, nombrePostes, id_statut)
                VALUES (%s, %s, %s, 2, 1)
                """
                cursor.execute(query, (str(today), str(closure_date), result[0]))
                db.connection.commit()
                print("✅ Annonce de démonstration créée")
            else:
                print("⚠️  Impossible de créer une annonce: aucun poste disponible")
        else:
            print(f"✅ {annonce_count} annonce(s) existe(nt) déjà")
        
        cursor.close()
        
        print("\n" + "=" * 60)
        print("✅ INITIALISATION RÉUSSIE !")
        print("=" * 60)
        print("\n📊 État de la base de données:")
        
        cursor = db.connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM poste")
        print(f"  • Postes: {cursor.fetchone()[0]}")
        cursor.execute("SELECT COUNT(*) FROM personnel")
        print(f"  • Personnel: {cursor.fetchone()[0]}")
        cursor.execute("SELECT COUNT(*) FROM annonce")
        print(f"  • Annonces: {cursor.fetchone()[0]}")
        cursor.execute("SELECT COUNT(*) FROM candidature")
        print(f"  • Candidatures: {cursor.fetchone()[0]}")
        cursor.execute("SELECT COUNT(*) FROM contrat")
        print(f"  • Contrats: {cursor.fetchone()[0]}")
        cursor.close()
        
    except Exception as e:
        print(f"\n❌ ERREUR: {e}")
        import traceback
        traceback.print_exc()
        return False
    finally:
        db.disconnect()
    
    return True

if __name__ == '__main__':
    success = init_database()
    exit(0 if success else 1)
