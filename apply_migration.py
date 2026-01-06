from app import create_app, db
from sqlalchemy import text


def column_exists(col_name):
    q = text("SELECT COUNT(*) FROM information_schema.columns WHERE table_schema=DATABASE() AND table_name='contrat' AND column_name=:col")
    res = db.session.execute(q, {"col": col_name})
    return res.scalar() > 0


def main():
    app = create_app()
    with app.app_context():
        try:
            if not column_exists('status'):
                print('Adding column `status` to `contrat`...')
                db.session.execute(text("ALTER TABLE contrat ADD COLUMN status VARCHAR(50) NOT NULL DEFAULT 'En attente'"))
                db.session.commit()
                print('`status` added')
            else:
                print('Column `status` already exists')

            if not column_exists('date_candidature'):
                print('Adding column `date_candidature` to `contrat`...')
                db.session.execute(text("ALTER TABLE contrat ADD COLUMN date_candidature DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"))
                db.session.commit()
                print('`date_candidature` added')
            else:
                print('Column `date_candidature` already exists')

        except Exception as e:
            print('Migration error:', e)


if __name__ == '__main__':
    main()
