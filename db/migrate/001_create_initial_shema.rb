class CreateInitialShema < ActiveRecord::Migration
  def self.up

    create_table "articles", :force => true do |t|
      t.column "title",         :string
      t.column "synopsis",      :text
      t.column "body",          :text
      t.column "category_id",   :integer
      t.column "permalink",     :string
      t.column "language_code", :string
      t.column "published",     :boolean
      t.column "event_date",    :date
      t.column "position",      :integer
      t.column "created_at",    :datetime
      t.column "updated_at",    :datetime
      t.column "published_at",  :datetime
      t.column "with_comments", :boolean
    end

    create_table "assets", :force => true do |t|
      t.column "name",            :string
      t.column "filename",        :string
      t.column "width",           :integer
      t.column "height",          :integer
      t.column "content_type",    :string
      t.column "size",            :integer
      t.column "thumbnail",       :string
      t.column "parent_id",       :integer
      t.column "created_at",      :datetime
      t.column "updated_at",      :datetime
      t.column "type",            :string
      t.column "attachable_type", :string
      t.column "attachable_id",   :integer
    end

    create_table "attachments", :force => true do |t|
      t.column "name",          :string
      t.column "url",           :string,  :limit => 50
      t.column "legend",        :string
      t.column "enabled",       :boolean
      t.column "position",      :integer
      t.column "page_id",       :integer
      t.column "language_code", :string,  :limit => 2
      t.column "show_what",     :string,  :limit => 40
      t.column "linktype",      :string,  :limit => 20
    end


    create_table "categories", :force => true do |t|
      t.column "name",        :string
      t.column "permalink",   :string
      t.column "synopsis",    :string
      t.column "position",    :integer, :default => 0
      t.column "member",      :boolean, :default => false
      t.column "homepage",    :boolean, :default => false
      t.column "agenda",      :boolean, :default => false
    end


    create_table "pages", :force => true do |t|
      t.column "title",             :string
      t.column "permalink",         :string
      t.column "body",              :text
      t.column "keywords",          :string
      t.column "description",       :string
      t.column "created_at",        :datetime
      t.column "updated_at",        :datetime
      t.column "parent_id",         :integer,  :default => 0
      t.column "position",          :integer,  :default => 1
      t.column "enabled",           :boolean,  :default => false
      t.column "attachments_count", :integer
      t.column "with_comments",     :boolean
    end


    create_table :globalize_countries, :force => true do |t|
      t.column :code,                   :string,  :limit => 2
      t.column :english_name,           :string
      t.column :date_format,            :string
      t.column :currency_format,        :string
      t.column :currency_code,          :string,  :limit => 3
      t.column :thousands_sep,          :string,  :limit => 2
      t.column :decimal_sep,            :string,  :limit => 2
      t.column :currency_decimal_sep,   :string,  :limit => 2
      t.column :number_grouping_scheme, :string
    end
    add_index :globalize_countries, :code

    create_table :globalize_translations, :force => true do |t|
      t.column :type,                   :string
      t.column :tr_key,                 :string
      t.column :table_name,             :string
      t.column :item_id,                :integer
      t.column :facet,                  :string
      t.column :built_in,               :boolean, :default => true
      t.column :language_id,            :integer
      t.column :pluralization_index,    :integer
      t.column :text,                   :text
      t.column :namespace,              :string
    end
    add_index :globalize_translations, [ :tr_key, :language_id ]
    add_index :globalize_translations, [ :table_name, :item_id, :language_id ], :name => 'globalize_translations_table_name_and_item_and_language'

    create_table :globalize_languages, :force => true do |t|
      t.column :iso_639_1,              :string,  :limit => 2
      t.column :iso_639_2,              :string,  :limit => 3
      t.column :iso_639_3,              :string,  :limit => 3
      t.column :rfc_3066,               :string
      t.column :english_name,           :string
      t.column :english_name_locale,    :string
      t.column :english_name_modifier,  :string
      t.column :native_name,            :string
      t.column :native_name_locale,     :string
      t.column :native_name_modifier,   :string
      t.column :macro_language,         :boolean
      t.column :direction,              :string
      t.column :pluralization,          :string
      t.column :scope,                  :string,  :limit => 1
    end
    add_index :globalize_languages, :iso_639_1
    add_index :globalize_languages, :iso_639_2
    add_index :globalize_languages, :iso_639_3
    add_index :globalize_languages, :rfc_3066





  end

  def self.down
    drop_table "articles"
    drop_table "assets"
    drop_table "attachments"
    drop_table "categories"
    drop_table "pages"
    drop_table :globalize_countries
    drop_table :globalize_translations
    drop_table :globalize_languages
  end
end
