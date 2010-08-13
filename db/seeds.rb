# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
ActiveRecord::Base.connection.execute("INSERT INTO members (id, name, klass, role, rank, created_at, updated_at) VALUES (0, 'Bank', 'Bank', 'Bank', 'Bank', NOW(), NOW())")