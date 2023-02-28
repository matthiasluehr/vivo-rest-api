desc "Synchronize Persons from VIVO into PostgreSQL"
task :person_sync => [:environment] do 
    Person.sync_from_vivo
end 

desc "Sync Publications from VIVO"
task :publication_sync => [:environment] do 
    Publication.sync_from_vivo
end 

desc "Sync Project from VIVO"
task :project_sync => [:environment] do 
    Project.sync_from_vivo
end 
    