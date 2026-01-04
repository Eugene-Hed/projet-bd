# Notes de migration SQL (FR)

Ce dossier contient le schéma principal et des migrations pour la base `sge`.

Fichiers importants :

- `sge.sql` — Schéma final du Système de Gestion d'Établissement (SGE). Ce fichier décrit la table `personnel` (fusion de `employe` et `utilisateur`), les tables de référence (`role`, `diplome`, `type_evenement`, `statut_*`), les contraintes, les indexes et les vues (`v_evenement_presences`, `v_personnel_detail`).

- `migrations/001_init_sge.sql` — Initialisation idempotente du schéma : création de la base `sge` (ou exécution manuelle si vous n'avez pas les droits), création/alter des tables de référence et seeds minimaux.

- `migrations/002_consolidate_personnel.sql` — Migration qui crée `personnel` et `personne_poste` et migre les données depuis la table `employe` (en évitant les doublons).

- `migrations/003_merge_personnel_and_update_fks.sql` — Migration unique qui :

  - sauvegarde `utilisateur` et `employe` (`*_backup`),
  - fusionne les enregistrements de `utilisateur` et `employe` dans `personnel`,
  - met à jour les clés étrangères (`presence`, `inscription`, `contrat`, `personnel_role`),
  - crée des mappings temporaires pour garantir la traçabilité.

- `migrations/004_rollback_merge_personnel.sql` — Script de rollback qui restaure `utilisateur` et `employe` à partir des backup créés par la migration 003 et reconstitue les FK d'origine lorsque possible.

Instructions d'exécution (recommandé) :

1. Ouvrir `psql` ou un client compatible :

   - $ psql -U <utilisateur_superuser> -h <hôte>

2. Si nécessaire, créer la base :

   - CREATE DATABASE sge;

3. Exécuter l'initialisation :

   - \i sql/migrations/001_init_sge.sql

4. Exécuter la consolidation du personnel (optionnel si vous avez déjà les données) :

   - \i sql/migrations/002_consolidate_personnel.sql

5. Exécuter la migration de fusion unique et de mise à jour des FK :

   - \i sql/migrations/003_merge_personnel_and_update_fks.sql

6. Vérifier le résultat (scripts de vérification à venir) ; si nécessaire, lancer le rollback :
   - \i sql/migrations/004_rollback_merge_personnel.sql

Précautions et bonnes pratiques :

- Les migrations créent des tables de sauvegarde (`utilisateur_backup`, `employe_backup`) : conservez-les jusqu'à validation complète, elles permettent un rollback fiable.
- Exécutez d'abord ces scripts sur une copie de la base (environnement de test) avant de les lancer en production.
- Les scripts sont conçus pour être idempotents et sûrs dans la mesure du possible, mais la logique métier locale peut nécessiter des ajustements.

Souhaitez-vous que je :

- Ajoute des scripts de test/validation automatique (`sql/tests/migration_check.sql`),
- Ou bien que j'exécute un dry-run (simulation) des migrations et vous fournisse un rapport des actions (s'il est possible d'exécuter ici) ?
