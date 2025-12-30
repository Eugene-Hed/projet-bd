import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    """Configuration de base"""
    MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.getenv('MYSQL_USER', 'hedric')
    MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', 'Hedric&2002')
    MYSQL_DB = os.getenv('MYSQL_DB', 'etablissement')
    MYSQL_PORT = int(os.getenv('MYSQL_PORT', 3306))
    
    SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')
    JSON_SORT_KEYS = False
    
class DevelopmentConfig(Config):
    """Configuration de développement"""
    DEBUG = True
    TESTING = False

class ProductionConfig(Config):
    """Configuration de production"""
    DEBUG = False
    TESTING = False

class TestingConfig(Config):
    """Configuration de test"""
    TESTING = True
    MYSQL_DB = 'etablissement_test'

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'testing': TestingConfig,
    'default': DevelopmentConfig
}
