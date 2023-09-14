ActiveAdmin.register User do
  belongs_to :school
  permit_params :description, :name, :email, :school_id, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :description
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  scope 'School Admins', :school_admin
  scope 'Students', :student

  filter :name
  filter :email
  filter :description
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :school_id, as: :select, collection: School.all.collect {|school| [school.name, school.id] }
      f.input :description
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  config.remove_action_item :new

  action_item :new, only: :index do
    link_to 'Create School Admin', new_admin_school_user_path
  end

end
