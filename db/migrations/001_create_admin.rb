Sequel.migration do
  change do
    create_table(:admins) do
      primary_key :id
      String :token, index: {unique:true}
      String :name
      String :email, index:{unique:true}
      String :crypted_password
    end
  end
end