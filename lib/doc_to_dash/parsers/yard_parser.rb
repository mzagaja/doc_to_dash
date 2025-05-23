module DocToDash
  class YardParser
    def initialize(doc_directory)
      @doc_directory = doc_directory

      fix_css_file
    end

    def fix_css_file
      File.open(@doc_directory + '/css/style.css', 'a') { |file| file.write('#header, .showSource, .inheritanceTree, .inheritName, h2 small { display: none; } .source_code, .fullTree { display: block !important; }') }
    end

    def parse_classes
      classes_file = File.read(@doc_directory + '/class_list.html')
      classes_html = Nokogiri::HTML(classes_file)
      classes      = []

      classes_html.css('span.object_link').each do |method|
        a     = method.children.first
        title = a.children.first.to_s.gsub('#', '')
        href  = a["href"].to_s

        classes << [href, title] unless title == "Top Level Namespace"
      end

      classes
    end

    def parse_methods
      methods_file = File.read(@doc_directory + '/method_list.html')
      methods_html = Nokogiri::HTML(methods_file)
      methods      = []

      methods_html.css('span.object_link').each do |method|
        a     = method.children.first
        href  = a["href"].to_s
        name  = a["title"].to_s.gsub(/\((.+)\)/, '').strip! # Strip the (ClassName) and whitespace.

        methods << [href, name]
      end

      methods
    end

    def parse_files
      files_file = File.read(@doc_directory + '/file_list.html')
      files_html = Nokogiri::HTML(files_file)
      files = []

      files_html.css('span.object_link').each do |file|
        a     = file.children.first
        href  = a["href"].to_s
        name  = a["title"].to_s # Strip the (ClassName) and whitespace.

        files << [href, name]
      end

      files
    end
  end
end
