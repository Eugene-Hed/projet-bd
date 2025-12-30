import pymysql
from config import Config

class Database:
    """Classe pour gérer les connexions à la base de données MySQL"""
    
    def __init__(self):
        self.connection = None
    
    def connect(self):
        """Établir une connexion à la base de données"""
        try:
            self.connection = pymysql.connect(
                host=Config.MYSQL_HOST,
                user=Config.MYSQL_USER,
                password=Config.MYSQL_PASSWORD,
                database=Config.MYSQL_DB,
                port=Config.MYSQL_PORT,
                charset='utf8mb4',
                autocommit=False
            )
            print("✓ Connexion à MySQL établie")
            return self.connection
        except pymysql.Error as e:
            print(f"✗ Erreur de connexion à MySQL: {e}")
            raise
    
    def disconnect(self):
        """Fermer la connexion à la base de données"""
        if self.connection:
            try:
                self.connection.close()
                print("✓ Connexion à MySQL fermée")
            except pymysql.Error:
                pass
            finally:
                self.connection = None
    
    def get_connection(self):
        """Récupérer la connexion actuelle"""
        if not self.connection:
            self.connect()
        return self.connection
    
    def execute_query(self, query, args=None):
        """Exécuter une requête SELECT"""
        cursor = self.get_connection().cursor(pymysql.cursors.DictCursor)
        try:
            if args:
                cursor.execute(query, args)
            else:
                cursor.execute(query)
            result = cursor.fetchall()
            cursor.close()
            return result
        except pymysql.Error as e:
            print(f"✗ Erreur lors de l'exécution de la requête: {e}")
            raise
    
    def execute_update(self, query, args=None):
        """Exécuter une requête INSERT/UPDATE/DELETE"""
        cursor = self.get_connection().cursor()
        try:
            if args:
                cursor.execute(query, args)
            else:
                cursor.execute(query)
            self.connection.commit()
            affected_rows = cursor.rowcount
            cursor.close()
            return affected_rows
        except pymysql.Error as e:
            self.connection.rollback()
            print(f"✗ Erreur lors de l'exécution de la requête: {e}")
            raise

# Instance globale
db = Database()
