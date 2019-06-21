# DatabaseMigration
# DatabaseMigration
Database migration is required whenever there is a change in existing database in new version of the app.

How to user 

        DATABASEHELPER.initializeDatabase(Database.fileName)
        DATABASEHELPER.migrateToVersion(version: 1)
        print("DB Key:", DATABASEHELPER.getSecretKeyFromKeyChain())
