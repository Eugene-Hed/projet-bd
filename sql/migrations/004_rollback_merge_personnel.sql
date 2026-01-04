-- Migration 004 : Rollback de la fusion `utilisateur`/`employe` -> `personnel`
-- Objectif : restaurer les tables `utilisateur` et `employe` à partir des sauvegardes créées par la migration 003
-- Remarques :
--  - Ce rollback s'appuie sur les tables `utilisateur_backup` et `employe_backup` créées par la migration 003.
--  - Avant d'exécuter ce rollback, assurez-vous que les backups existent et sont intacts.
--  - Tous les commentaires sont en français.

BEGIN;

-- 1) Restaurer la table utilisateur à partir de la sauvegarde
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='utilisateur_backup') THEN
        -- recréer la table utilisateur si nécessaire
        CREATE TABLE IF NOT EXISTS utilisateur (
            id_utilisateur SERIAL PRIMARY KEY,
            nom VARCHAR(100) NOT NULL,
            telephone VARCHAR(20),
            email VARCHAR(150) UNIQUE
        );

        -- vider et réinsérer les données depuis la sauvegarde
        TRUNCATE TABLE utilisateur;
        INSERT INTO utilisateur (id_utilisateur, nom, telephone, email)
        SELECT id_utilisateur, nom, telephone, email FROM utilisateur_backup;
    END IF;
END$$;

-- 2) Restaurer la table employe à partir de la sauvegarde
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='employe_backup') THEN
        CREATE TABLE IF NOT EXISTS employe (
            id SERIAL PRIMARY KEY,
            nom VARCHAR(100) NOT NULL,
            prenom VARCHAR(100) NOT NULL,
            email VARCHAR(150) UNIQUE,
            date_embauche DATE NOT NULL,
            statut VARCHAR(50),
            poste_id INTEGER
        );

        TRUNCATE TABLE employe;
        INSERT INTO employe (id, nom, prenom, email, date_embauche, statut, poste_id)
        SELECT id, nom, prenom, email, date_embauche, statut, poste_id FROM employe_backup;
    END IF;
END$$;

-- 3) Restaurer les colonnes id_utilisateur dans presence et inscription en reconstituant les correspondances
DO $$
DECLARE
    per RECORD;
    u_id INT;
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_personnel') THEN
        -- ajouter id_utilisateur si nécessaire
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='presence' AND column_name='id_utilisateur') THEN
            ALTER TABLE presence ADD COLUMN id_utilisateur INTEGER;
        END IF;

        -- pour chaque presence liée à un personnel, on tente de trouver l'utilisateur correspondant
        FOR per IN SELECT id_personnel FROM presence LOOP
            SELECT id_utilisateur INTO u_id FROM utilisateur_backup ub
            WHERE (ub.email IS NOT NULL AND ub.email = (SELECT email FROM personnel WHERE id_personnel = per.id_personnel) )
            LIMIT 1;

            IF u_id IS NULL THEN
                -- aucune correspondance n'a été trouvée ; on laisse NULL
                CONTINUE;
            END IF;

            UPDATE presence SET id_utilisateur = u_id WHERE id_personnel = per.id_personnel;
        END LOOP;

        -- si id_utilisateur désormais renseigné, on peut restaurer PK et FK
        BEGIN
            ALTER TABLE presence DROP CONSTRAINT IF EXISTS presence_pkey;
        EXCEPTION WHEN OTHERS THEN END;

        ALTER TABLE presence ADD CONSTRAINT presence_pkey PRIMARY KEY (id_utilisateur, id_evenement);
        ALTER TABLE presence ADD CONSTRAINT fk_presence_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE;

        -- optionnel : supprimer id_personnel si vous souhaitez revenir strictement à l'ancien schéma
        -- ALTER TABLE presence DROP COLUMN IF EXISTS id_personnel;
    END IF;

    -- même logique pour inscription
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='inscription' AND column_name='id_personnel') THEN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='inscription' AND column_name='id_utilisateur') THEN
            ALTER TABLE inscription ADD COLUMN id_utilisateur INTEGER;
        END IF;

        FOR per IN SELECT id_personnel FROM inscription LOOP
            SELECT id_utilisateur INTO u_id FROM utilisateur_backup ub
            WHERE (ub.email IS NOT NULL AND ub.email = (SELECT email FROM personnel WHERE id_personnel = per.id_personnel) )
            LIMIT 1;

            IF u_id IS NULL THEN
                CONTINUE;
            END IF;

            UPDATE inscription SET id_utilisateur = u_id WHERE id_personnel = per.id_personnel;
        END LOOP;

        BEGIN
            ALTER TABLE inscription DROP CONSTRAINT IF EXISTS inscription_pkey;
        EXCEPTION WHEN OTHERS THEN END;

        ALTER TABLE inscription ADD CONSTRAINT inscription_pkey PRIMARY KEY (id_utilisateur, id_evenement);
        ALTER TABLE inscription ADD CONSTRAINT fk_inscription_utilisateur FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur) ON DELETE CASCADE;

        -- ALTER TABLE inscription DROP COLUMN IF EXISTS id_personnel;
    END IF;
END$$;

-- 4) Restaurer employe_id dans contrat
DO $$
DECLARE
    c RECORD;
    e_id INT;
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='contrat' AND column_name='id_personnel') THEN
        IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='contrat' AND column_name='employe_id') THEN
            ALTER TABLE contrat ADD COLUMN employe_id INTEGER;
        END IF;

        FOR c IN SELECT id, id_personnel FROM contrat WHERE id_personnel IS NOT NULL LOOP
            SELECT id INTO e_id FROM employe_backup eb
            WHERE (eb.email IS NOT NULL AND eb.email = (SELECT email FROM personnel WHERE id_personnel = c.id_personnel))
            LIMIT 1;

            IF e_id IS NOT NULL THEN
                UPDATE contrat SET employe_id = e_id WHERE id = c.id;
            END IF;
        END LOOP;

        -- restaurer FK
        ALTER TABLE contrat DROP CONSTRAINT IF EXISTS fk_contrat_personnel;
        ALTER TABLE contrat ADD CONSTRAINT fk_contrat_employe FOREIGN KEY (employe_id) REFERENCES employe(id);

        -- optionnel : enlever id_personnel
        -- ALTER TABLE contrat DROP COLUMN IF EXISTS id_personnel;
    END IF;
END$$;

-- 5) Restaurer utilisateur_role à partir de personnel_role si possible
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='personnel_role') THEN
        CREATE TABLE IF NOT EXISTS utilisateur_role (
            id_utilisateur INTEGER NOT NULL,
            id_role INTEGER NOT NULL,
            date_attribution TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id_utilisateur, id_role)
        );

        -- insérer les rôles en tentant de retrouver l'utilisateur via la sauvegarde
        INSERT INTO utilisateur_role (id_utilisateur, id_role, date_attribution)
        SELECT ub.id_utilisateur, pr.id_role, pr.date_attribution
        FROM personnel_role pr
        JOIN personnel p ON p.id_personnel = pr.id_personnel
        JOIN utilisateur_backup ub ON (ub.email IS NOT NULL AND ub.email = p.email)
        WHERE NOT EXISTS (
            SELECT 1 FROM utilisateur_role ur WHERE ur.id_utilisateur = ub.id_utilisateur AND ur.id_role = pr.id_role
        );
    END IF;
END$$;

COMMIT;

-- Fin du rollback
