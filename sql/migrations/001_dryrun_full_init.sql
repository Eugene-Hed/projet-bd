-- Dry-run pour Migration 001 (consolidée)
-- Ce script estime le nombre d'inserts/updates que la migration effectuerait.
-- Il ne modifie pas les données. Exécutez-le connecté à `sge`.

-- 1) employe -> personnel : combien d'employés ont un email absent de personnel ?
SELECT COUNT(*) AS nb_employes_a_inserer_via_email
FROM employe e
WHERE e.email IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email = e.email);

-- 2) employe sans email -> personnel (basé sur nom+prenom+date_embauche)
SELECT COUNT(*) AS nb_employes_sans_email_a_inserer
FROM employe e
WHERE e.email IS NULL
  AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email IS NULL AND p.nom = e.nom AND p.prenom = e.prenom AND COALESCE(p.dateEmbauche::text,'') = COALESCE(e.date_embauche::text,''));

-- 3) utilisateur -> personnel (email)
SELECT COUNT(*) AS nb_utilisateurs_a_inserer
FROM utilisateur u
WHERE u.email IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM personnel p WHERE p.email = u.email);

-- 4) presence : combien de lignes ont id_utilisateur non null ?
SELECT COUNT(*) AS nb_presence_avec_utilisateur FROM presence WHERE EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_utilisateur') AND id_utilisateur IS NOT NULL;

-- 5) inscription : idem
SELECT COUNT(*) AS nb_inscription_avec_utilisateur FROM inscription WHERE EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='inscription' AND column_name='id_utilisateur') AND id_utilisateur IS NOT NULL;

-- 6) contrat : combien de contrats pointent sur employe_id ?
SELECT COUNT(*) AS nb_contrat_avec_employe FROM contrat WHERE EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='contrat' AND column_name='employe_id') AND employe_id IS NOT NULL;

-- 7) Estimation des rôles utilisateur -> personnel
SELECT COUNT(*) AS nb_utilisateur_role_a_migrer FROM utilisateur_role WHERE NOT EXISTS (SELECT 1 FROM personnel_role pr WHERE pr.id_personnel = (SELECT p.id_personnel FROM personnel p WHERE p.email = (SELECT u.email FROM utilisateur u WHERE u.id_utilisateur = utilisateur_role.id_utilisateur LIMIT 1) LIMIT 1) AND pr.id_role = utilisateur_role.id_role);

-- 8) Vérifier existence des backups
SELECT CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='utilisateur_backup') THEN 'oui' ELSE 'non' END AS utilisateur_backup_existe;
SELECT CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='employe_backup') THEN 'oui' ELSE 'non' END AS employe_backup_existe;

-- Fin du dry-run
