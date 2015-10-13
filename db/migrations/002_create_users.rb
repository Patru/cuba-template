Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :name
      String :token, index: {unique:true}
      String :email, index: {unique:true}
      String :crypted_password
    end
  end
end