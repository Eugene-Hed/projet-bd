ETUDE ET ANALYSE DU MODULE GESTION DU PERSONNELS
1-	Besoins fonctionnels 

	Gestion des informations du personnel
	Gestion des fonction et rôle 
• Attribution de rôles ( Directeur, Adjoints, Enseignant, Secrétaire…)
• Gestion des départements (Maths, Sciences, …)
• Gestion des matières enseignées par chaque enseignant
• Gestion des emplois du temps du personnel
	Gestion des contrats
	Gestion de l’assiduité 
	Gestion des congés 
	Gestion de la paie
2-	Entités 
	Personnel
	Fonction
	Département
	Matière
	Assiduité
	Permission
	Congé
	Salaire
	Contrat




3-	DICTIONNAIRE DE DONNÉES COMPLET

Module : Gestion du personnel 

TABLE	CHAMPS	TYPE	TAILLE	DESCRIPTION	CONTRAINTE
Personnels 	Matricule_perso	VARCHAR	20	Matricule unique	UNIQUE, NOT NULL clé primaire
	Nom_perso	VARCHAR	50	Nom du personnel	
	Prenom_perso	VARCHAR	50	Prénom du personnel	
	Sexe_perso	Char	01	Sexe	
	date_nais_perso	DATE	/	Date de naissance	JJ/MM/AAAA
	lieu_nais_perso	VARCHAR	100	Lieu de naissance	
	Nationalite_perso	VARCHAR	50	Nationalité	
	Tel_perso	VARCHAR	12	Numéro de téléphone	
	Email_perso	VARCHAR	100	Adresse email	
	ville_perso	TEXT		Ville du personnel 	
	quartier_perso	TEXT		Quartier du personnel 	
	Photo_perso	VARCHAR	255	Photo du personnel	
	situation_matri_perso	VARCHAR	30	Situation matrimoniale	
	date_emb_perso	DATE	—	Date d’embauche	
	Statut_perso			Statut du personnel	
	Password_perso	VARCHAR	50	Mot de passe du personnel 	

FONCTION	id_fonction	INT	10	Identifiant de la fonction	 Auto incrément clé primaire
	libelle_fonction	VARCHAR	50	Nom de la fonction	UNIQUE, NOT NULL

DEPARTEMENT	id_departement	INT	10	Identifiant du département	 Auto incrément clé primaire
	nom_departement	VARCHAR	50	Nom du département	NOT NULL

MATIÈRE	id_matiere	INT	10	Identifiant de la matière	Auto incrément Cléprimaire 
	nom_matiere	VARCHAR	50	Nom de la matière	NOT NULL
	Quota_horaire_Mat	int	10	Nombre d’heure dédié à la matière 	
	Coef_Mat	int	10	Coefficient de la matière	

Assiduité	id_Assiduité	INT	10	Identifiant présence	 Auto incrément
	date_presence	DATE		Date de présence	JJ/MM/AAAA
	Statut_assiduité	Booléen		Statut d’assiduité (present ou absent)	
	heure_arrivee	TIME		Heure d’arrivée	
	heure_depart	TIME		Heure de départ	

PERMISSION 

	id_permission	INT	10	Identifiant permission	Auto incrément 
	date_debut	DATE		Date de début de la permission	JJ/MM/AAAA
	date_fin	DATE		Date de Fin de la permission	JJ/MM/AAAA
	Motif	TEXT		Motif de l’absence	
	statut_permission		EN_ATTENTE/ACCEPTE/REFUSE	Statut de la permission	

CONGÉ 	id_conge	INT	10	Identifiant congé	Clé primaire Auto incrément  
	date_debut	DATE		Début congé	JJ/MM/AAAA
	date_fin	DATE		Fin congé	JJ/MM/AAAA
	type_conge	VARCHAR	50	Type de congé	
	statut_conge		EN_ATTENTE/ACCEPTE/REFUSE	Statut	

SALAIRE	id_salaire	INT	10	Identifiant salaire	Clé primaire Auto incrément
	Mois_salaire	VARCHAR		Mois de paie	
	salaire_base	DECIMAL		Salaire de base	
	Prime_salaire	DECIMAL		Prime	
	Deduction_salaire	DECIMAL		Déductions	
	salaire_net	DECIMAL		Salaire net	
    
CONTRAT	Id_contrat	Int	20	Identifiant du contrat	Clé primaire auto incrément 
	Libellé_contrat	Text		Libellé du contrat 	
	Date_emb	Date		Date d’embauche	JJ/MM/AAAA
	Date_Fin	Date		Date de fin du contrat 	JJ/MM/AAAA





