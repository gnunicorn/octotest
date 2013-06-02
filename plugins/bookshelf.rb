module Jekyll

  class BookshelfIndex

    def initialize(site, url, content)
      @site = site
      @url = url
      @content = content
    end

    def destination(dest)
      File.join(dest, @url)
    end

    def write(dest)
      target_file = destination(dest)
      File.open(target_file, "w") do |f|
        f.write(@content)
      end
    end
  end

  class BookshelfItem 
    include Convertible

    attr_accessor :data, :content, :shelf
    attr_accessor :itemdata

    def initialize(site, shelf, dir, filename)
      @shelf = shelf
      @itemdata = self.read_yaml(dir, filename)
      @itemdata['id'] = File.basename(filename, ".*")
      @itemdata['content'] = self.content
      @itemdata['url'] = self.url_base + @itemdata['id'] + ".html"
      puts @itemdata['url']
      self.post_process()
    end

    def get_id
      @itemdata['id']
    end

    def url_base
    end

    def destination(dest)
      File.join(dest, @itemdata["url"])
    end

    def post_process
    end

    def write(dest)
      target_file = destination(dest)
      File.open(target_file, "w") do |f|
        f.write(@content)
      end
    end

    def valid?
      true
    end

  end

  class BookItem < BookshelfItem

    def url_base
      "books/"
    end

    def post_process
      @itemdata["recommendations"] = []
    end

  end

  class VideoItem < BookshelfItem

    def url_base
      "videos/"
    end

    def post_process
      @itemdata["recommendations"] = []
    end

  end

  class UserItem < BookshelfItem

    def url_base
      "users/"
    end

    def post_process

      @itemdata["recommendations"] = {
        "books" => [], "videos" => [], 
      }

      [ ['books', @shelf.books], ['videos', @shelf.videos]].each do |dir, target|
        @itemdata["recommends"][dir].each do |key, rec| 
          if target[key] != nil then
            target[key].itemdata["recommendations"] << {
                "user" => self, "text" => rec
              }
            @itemdata["recommendations"][dir] << {
                "item" => target[key].itemdata, "text" => rec
              }
          end
        end
      end
    end

    def valid?
      get_id and @itemdata['recommends'] != nil
    end
  end

  class Bookshelf
    @books = {}
    @users = {}
    @videos = {}

    attr_accessor :books, :videos, :users

    def initialize(site)
      @books = {}
      @users = {}
      @videos = {}
      @site = site

      dir = site.config['bookshelf_database'] || '_database'
      base = File.join(site.source, dir)
      return unless File.exists?(base)

      [ ['books', BookItem, @books],
        ['videos', VideoItem, @videos],
        ['users', UserItem, @users] # users have to be last
      ].each do |dir, cls, target|
        books_dir = File.join(base, dir)
        entries = Dir.chdir(books_dir) { site.filter_entries(Dir['**/*']) }

        entries.each do |f|
          entry = cls.new(site, self, books_dir, f)
          target[entry.get_id] = entry if entry.valid?
        end
      end
    end
  end

  class BookshelfGenerator < Generator
    safe true

    def generate(site)
      bookshelf = Bookshelf.new(site)

      [ ['book', bookshelf.books],
        ['video', bookshelf.videos],
        ['user', bookshelf.users] # users have to be last
      ].each do |dir, target|

        base = File.join(site.dest, dir + "s")
        puts base
        Dir.mkdir(base) unless Dir.exists?(base)

        tmpl = self.load_template('database/' + dir + '.html', site)
        items = target.each do |key, item|
          item.content = tmpl.render(dir=>item.itemdata).gsub(/\t/, '')
          site.static_files << item
          item.itemdata
        end

        tmpl = self.load_template('database/' + dir + '_index.html', site)
        site.static_files << BookshelfIndex.new(site,
            dir + "s/index.html",
            tmpl.render(dir + 's'=>items).gsub(/\t/, '')
          )
      end
    end


    def load_template(file, site)
      includes_dir = File.join(site.source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if file !~ /^[a-zA-Z0-9_\/\.-]+$/ || file =~ /\.\// || file =~ /\/\./
        return "Include file '#{file}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(file)
          Liquid::Template.parse(File.read(file))
        else
          "Included file '#{file}' not found in _includes directory"
        end
      end
    end

  end
end