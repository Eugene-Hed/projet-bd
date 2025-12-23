import os

class Config:
    """Configuration de base"""
    SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://root:@localhost/mod_personnel'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = 'your-secret-key-change-this'
    DEBUG = True
