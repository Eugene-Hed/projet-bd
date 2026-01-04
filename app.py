from flask import Flask, render_template, request, redirect, url_for, abort
from flask_sqlalchemy import SQLAlchemy
from decimal import Decimal
import datetime
import os
from sqlalchemy import text, inspect
from markupsafe import escape
import re

app = Flask(__name__)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Configure DB URI via environment or default
db_user = os.getenv('SGE_DB_USER', 'postgres')
db_pass = os.getenv('SGE_DB_PASS', 'Ag112211')
db_host = os.getenv('SGE_DB_HOST', 'localhost')
db_port = os.getenv('SGE_DB_PORT', '7777')
db_name = os.getenv('SGE_DB_NAME', 'sge')
app.config['SQLALCHEMY_DATABASE_URI'] = f'postgresql+psycopg2://{db_user}:{db_pass}@{db_host}:{db_port}/{db_name}'
db = SQLAlchemy(app)


# ---------------------- Models ----------------------
class Departement(db.Model):
    __tablename__ = 'departement'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(100), nullable=False)


class Poste(db.Model):
    __tablename__ = 'poste'
    id = db.Column(db.Integer, primary_key=True)
    titre = db.Column(db.String(100), nullable=False)
    departement_id = db.Column(db.Integer, db.ForeignKey('departement.id'), nullable=False)


class Employe(db.Model):
    __tablename__ = 'employe'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(100), nullable=False)
    prenom = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True)
    date_embauche = db.Column(db.Date, nullable=False)
    statut = db.Column(db.String(50))
    poste_id = db.Column(db.Integer, db.ForeignKey('poste.id'))


class Contrat(db.Model):
    __tablename__ = 'contrat'
    id = db.Column(db.Integer, primary_key=True)
    employe_id = db.Column(db.Integer, db.ForeignKey('employe.id'), nullable=False)
    type = db.Column(db.String(50))
    debut = db.Column(db.Date, nullable=False)
    fin = db.Column(db.Date)
    salaire = db.Column(db.Numeric(10,2))


class Etudiant(db.Model):
    __tablename__ = 'etudiant'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(100), nullable=False)
    prenom = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(150), unique=True)
    date_naissance = db.Column(db.Date)


class Salle(db.Model):
    __tablename__ = 'salle'
    id = db.Column(db.Integer, primary_key=True)
    code = db.Column(db.String(50), nullable=False)
    capacite = db.Column(db.Integer, nullable=False)


class Equipement(db.Model):
    __tablename__ = 'equipement'
    id = db.Column(db.Integer, primary_key=True)
    nom = db.Column(db.String(100), nullable=False)
    type = db.Column(db.String(50))
    etat = db.Column(db.String(50))
    salle_id = db.Column(db.Integer, db.ForeignKey('salle.id'))


# Map table name to model class
MODELS = {
    'departement': Departement,
    'poste': Poste,
    'employe': Employe,
    'contrat': Contrat,
    'etudiant': Etudiant,
    'salle': Salle,
    'equipement': Equipement,
}


@app.context_processor
def inject_tables():
    return {'tables': sorted(MODELS.keys())}
def convert_value(column, raw_value):
    if raw_value is None or raw_value == '':
        return None
    col_type = type(column.type).__name__.lower()
    try:
        if 'integer' in col_type:
            return int(raw_value)
        if 'numeric' in col_type or 'decimal' in col_type or 'float' in col_type:
            return Decimal(raw_value)
        if 'date' in col_type:
            return datetime.datetime.strptime(raw_value, '%Y-%m-%d').date()
    except Exception:
        # fallback to raw string
        return raw_value
    return raw_value


@app.route('/')
def index():
    return render_template('index.html', tables=sorted(MODELS.keys()))


@app.route('/<table>/')
def list_table(table):
    Model = MODELS.get(table)
    if not Model:
        abort(404)
    items = Model.query.all()
    columns = [c.name for c in Model.__table__.columns]
    return render_template('list.html', table=table, columns=columns, items=items)


@app.route('/<table>/create', methods=['GET', 'POST'])
def create_item(table):
    Model = MODELS.get(table)
    if not Model:
        abort(404)
    if request.method == 'POST':
        obj = Model()
        for col in Model.__table__.columns:
            if col.primary_key:
                continue
            val = request.form.get(col.name)
            setattr(obj, col.name, convert_value(col, val))
        db.session.add(obj)
        db.session.commit()
        return redirect(url_for('list_table', table=table))
    columns = [c for c in Model.__table__.columns if not c.primary_key]
    return render_template('form.html', table=table, columns=columns, item=None)


@app.route('/<table>/edit/<int:item_id>', methods=['GET', 'POST'])
def edit_item(table, item_id):
    Model = MODELS.get(table)
    if not Model:
        abort(404)
    item = Model.query.get_or_404(item_id)
    if request.method == 'POST':
        for col in Model.__table__.columns:
            if col.primary_key:
                continue
            val = request.form.get(col.name)
            setattr(item, col.name, convert_value(col, val))
        db.session.commit()
        return redirect(url_for('list_table', table=table))
    columns = [c for c in Model.__table__.columns if not c.primary_key]
    return render_template('form.html', table=table, columns=columns, item=item)


@app.route('/<table>/delete/<int:item_id>', methods=['POST'])
def delete_item(table, item_id):
    Model = MODELS.get(table)
    if not Model:
        abort(404)
    item = Model.query.get_or_404(item_id)
    db.session.delete(item)
    db.session.commit()
    return redirect(url_for('list_table', table=table))


@app.route('/__dbinfo__')
def dbinfo():
    uri = app.config.get('SQLALCHEMY_DATABASE_URI')
    sanitized = uri
    try:
        # mask password
        if '://' in sanitized and '@' in sanitized:
            prefix, rest = sanitized.split('://', 1)
            userinfo, hostinfo = rest.split('@', 1)
            if ':' in userinfo:
                user, pwd = userinfo.split(':', 1)
                userinfo = f'{user}:***'
            sanitized = f'{prefix}://{userinfo}@{hostinfo}'
    except Exception:
        pass
    tables = None
    try:
        # Try to list public tables
        res = db.session.execute("SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname='public'")
        tables = [r[0] for r in res.fetchall()]
    except Exception as e:
        tables = f'ERROR: {e}'
    return f'<pre>DB URI: {sanitized}\nTables: {tables}</pre>'


def do_migrate():
    # ensure DB connection
    try:
        db.session.execute(text('SELECT 1'))
    except Exception as e:
        return False, f'Connection error: {e}'

    inspector = inspect(db.engine)
    try:
        existing_tables = inspector.get_table_names()
    except Exception:
        # fallback query for pg
        try:
            res = db.session.execute(text("SELECT tablename FROM pg_catalog.pg_tables WHERE schemaname='public'"))
            existing_tables = [r[0] for r in res.fetchall()]
        except Exception as e:
            return False, f'Could not determine existing tables: {e}'

    model_tables = list(MODELS.keys())
    missing = [t for t in model_tables if t not in existing_tables]
    created = []

    # Create only missing tables
    for t in missing:
        try:
            MODELS[t].__table__.create(bind=db.engine)
            created.append(t)
        except Exception as e:
            return False, f'Error creating table {t}: {e}'

    # Read SQL file and insert seed data into tables that are empty or were just created
    inserted_tables = []
    sql_file = os.path.join(os.path.dirname(__file__), 'sql', 'sge.sql')
    if os.path.exists(sql_file):
        try:
            with open(sql_file, 'r', encoding='utf-8') as f:
                sql_text = f.read()
        except Exception as e:
            return False, f'Could not read sql/sge.sql: {e}'

        # Split into statements; execute only INSERT INTO statements
        statements = [s.strip() for s in re.split(r';\s*\n', sql_text) if s.strip()]
        for stmt in statements:
            s = stmt.strip()
            if re.match(r'(?i)^INSERT\s+INTO', s):
                m = re.match(r'(?i)INSERT\s+INTO\s+([\w]+)', s)
                if not m:
                    continue
                table_name = m.group(1)
                if table_name not in MODELS:
                    continue
                try:
                    # check if table exists and is empty
                    cnt = None
                    try:
                        cnt = db.session.execute(text(f'SELECT COUNT(*) FROM {table_name}')).scalar()
                    except Exception:
                        cnt = None
                    if cnt is None:
                        # table may not exist; skip
                        continue
                    if cnt == 0 or table_name in created:
                        try:
                            db.session.execute(text(s))
                            inserted_tables.append(table_name)
                        except Exception as e:
                            db.session.rollback()
                            return False, f'Error inserting into {table_name}: {e}'
                except Exception as e:
                    db.session.rollback()
                    return False, f'Error processing inserts: {e}'
        try:
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            return False, f'Commit error after inserts: {e}'

    return True, (f'Migration complete. Existing tables: {existing_tables}\n'
                  f'Created tables: {created}\nInserted seed into: {inserted_tables}')


@app.route('/__migrate__', methods=['GET', 'POST'])
@app.route('/__migrate__/', methods=['GET', 'POST'])
def migrate():
    ok, msg = do_migrate()
    if not ok:
        return msg, 500
    return msg


@app.route('/__routes__')
def routes():
    lines = []
    for rule in app.url_map.iter_rules():
        lines.append(f"{rule.endpoint}: {escape(str(rule))}")
    return '<pre>' + '\n'.join(sorted(lines)) + '</pre>'


if __name__ == '__main__':
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument('--migrate', action='store_true', help='Run DB migration and exit')
    args = parser.parse_args()

    if args.migrate:
        ok, msg = do_migrate()
        if ok:
            print(msg)
            exit(0)
        else:
            print('Migration failed:', msg)
            exit(1)

    app.run(debug=True)
