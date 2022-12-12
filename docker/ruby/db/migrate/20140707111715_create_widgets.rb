# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

class CreateWidgets < ActiveRecord::Migration[5.1]
  def change
    create_table :widgets do |t|
      t.string :name
      t.text :description
      t.integer :stock

      t.timestamps
    end
  end
end
