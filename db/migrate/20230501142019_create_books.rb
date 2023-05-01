class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :content

      # Define the embeddings column with the float[] data type
      t.column :embeddings, :float, array: true

      t.timestamps
    end
      
  end
end
