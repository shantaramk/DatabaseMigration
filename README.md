# DatabaseMigration
# DatabaseMigration
Database migration is required whenever there is a change in existing database in new version of the app.

How to use

        DATABASEHELPER.initializeDatabase(Database.fileName)
        DATABASEHELPER.migrateToVersion(version: 1)
        print("DB Key:", DATABASEHELPER.getSecretKeyFromKeyChain())
        
What to do

        Name the .sql file with the database change version number included.

        e.g. migration-1.sql , migration-2.sql …

        Keep all previous .sql files intact.


