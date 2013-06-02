module Jekyll

  class BookshelfItem 
    include Convertible

    attr_accessor :data, :content
    attr_accessor :itemdata

    def initialize(site, dir, filename)
      @itemdata = self.read_yaml(dir, filename)
      @itemdata['id'] = File.basename(filename, ".*")
      @itemdata['content'] = self.content
    end

    def get_id
      @itemdata['id']
    end

    def valid?
      true
    end

  end


  class Bookshelf
    @books = {}
    @users = {}

    attr_accessor :books, :users

    def initialize(site)
      @books = {}
      @users = {}
      @site = site

      dir = site.config['bookshelf_database'] || '_database'
      base = File.join(site.source, dir)
      return unless File.exists?(base)

      books_dir = File.join(base, 'books')
      entries = Dir.chdir(books_dir) { site.filter_entries(Dir['**/*']) }

      # Reverse chronological order
      entries.each do |f|
        entry = BookshelfItem.new(site, books_dir, f)
        @books[entry.get_id] = entry.itemdata if entry.valid?
      end


      users_dir = File.join(base, 'users')
      entries = Dir.chdir(users_dir) { site.filter_entries(Dir['**/*']) }

      # Reverse chronological order
      entries.each do |f|
        entry = BookshelfItem.new(site, users_dir, f)
        @users[entry.get_id] = entry.itemdata if entry.valid?
      end
    end
  end

  class BookshelfGenerator < Generator
    safe true

    def generate(site)
      bookshelf = Bookshelf.new(site)
      puts bookshelf.books
      puts bookshelf.users
    end
  end

end