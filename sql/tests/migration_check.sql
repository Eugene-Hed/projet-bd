-- Scripts de vérification post-migration (Migration checks)
-- Exécutez ce script après la migration pour valider les points clés.

-- 1) Vérifier qu'il n'existe pas de présence liée à un utilisateur non migré
SELECT count(*) AS nb_presence_sans_personnel
FROM presence
WHERE id_personnel IS NULL;

-- 2) Vérifier qu'il n'existe pas d'inscription liée à un utilisateur non migré
SELECT count(*) AS nb_inscription_sans_personnel
FROM inscription
WHERE id_personnel IS NULL;

-- 3) Vérifier que tous les contrats référencent bien un personnel
SELECT count(*) AS nb_contrat_sans_personnel
FROM contrat
WHERE id_personnel IS NULL;

-- 4) Vérifier que la table personnel contient au moins un enregistrement
SELECT count(*) AS nb_personnel_total FROM personnel;

-- 5) Vérifier la correspondance entre backups et personnel (si backups présents)
SELECT 'utilisateur_backup_exist' AS check, CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='utilisateur_backup') THEN 'oui' ELSE 'non' END;
SELECT 'employe_backup_exist' AS check, CASE WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='employe_backup') THEN 'oui' ELSE 'non' END;

-- 6) Vérifier les FK critiques
-- Présence -> personnel
SELECT tc.constraint_name, tc.table_name, kcu.column_name, ccu.table_name AS foreign_table, ccu.column_name AS foreign_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.table_name IN ('presence','inscription','contrat');

-- Fin du script de vérification
