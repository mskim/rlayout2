
HELP_TEXT =<<EOF

usgage
  newsman article+ [article_folder_path]
  newsman section [section_path]
  newsman article [article_folder_path]
  newsman article [story_md_path]
  newsman pillar [pillar_folder_path]

  newsman rjob .
  newsman rjob . -jpg
  newsman rjob story_md_path
  newsman rjob story_md_path -jpg
  newsman rjob story_md_path output_path -jpg -preview

  newsman pdf2jpg [pdf_path]
  newsman pdf2jpg [pdf_path] -high

EOF

# newsman make_issue [issue_path]
# newsman make_page [page_path]
# newsman make_article [article_path]

class AppDelegate
  def main(argc, argv)
    puts "v 2019 12 3"
    # p argv
    if argc == 1
      puts HELP_TEXT
    elsif argv[1] == "-h" || argv[1] == "--help"
      puts HELP_TEXT
    elsif argv[1] == "font_width"
      folder = `pwd`
      puts "Extracting font width from: #{folder}"
      # RLayout::FontWidthExtractor.new(folder.chomp!)
      return
    elsif argc == 2
      puts HELP_TEXT
    elsif argc >= 3
      argv.shift
      path = File.expand_path(argv[1])
      puts "+++++++ path:#{path}"
      case argv[0]

      when 'yaml'
        puts YAML.dump({:first=>"my_first", :second=>"my_second"})
        puts YAML.dump({"first"=>"my_first", "second"=>"my_second"})
        config_path = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/config.yml"
        file= File.open(config_path, 'r'){|f| f.read}
        puts YAML.load(file)
        # puts Hash.transform_keys_to_symbols(YAML.load(file))
      when 'new_publication'
        #create new publication at path
        options = {}
        options[:path] = path
        options[:name] = argv[2]
        # RLayout::Newspaper.new(options)
      when 'new_issue'
        #create new issue in publication path path
        RLayout::NewspaperIssue.new(path, :issue_date=>argv[2])
      when 'section'
        # generate section pdf by merging story pdf files
        options = {}
        options[:section_path]  = path
        options[:output_path]   = path + "/section.pdf"
        options[:jpg]           = true
        if argv[2] =~ /-time_stamp/
          options[:time_stamp] = argv[2].split("=")[1]
        end
        puts "processing section pdf..."
        # RLayout::NewsPage.section_pdf(options)
        # news_section.merge_article_pdf(:jpg=>true)
      when 'change_section_layout'
        # change grid_key in section config.yml
        # and update each story to new layout
        # RLayout::NewspaperSection.change_section_layout(path, argv[2])
      when 'article+'
        puts "processing newsman article and page ..."
        options = {}
        if File.directory?(path)
          options[:article_path] = path
        elsif File.exist?(path)
          options[:story_path]   = path
        end
        options[:jpg]  = true

        if argv[2] =~ /-time_stamp/
          options[:time_stamp] = argv[2].split("=")[1]
        end

        RLayout::NewsBoxMaker.new(options)

        # section_path = File.dirname(path)
        # options.delete(:article_path)
        # options[:section_path]  = section_path
        # options[:output_path]   = section_path + "/section.pdf"
        # RLayout::NewsPage.section_pdf(options)

      when 'article'
        puts "processing newsman article ..."
        options = {}
        if File.directory?(path)
          options[:article_path] = path
        elsif File.exist?(path)
          options[:story_path]   = path
        end
        options[:jpg]  = true
        if argv[2] =~ /-custom/
          options[:custom_style] = true
          options[:publication_name] = argv[2].split("=")[1]
          argv.shift
        end
        if argv[2] =~ /-time_stamp/
          options[:time_stamp] = argv[2].split("=")[1]
        end
        if argv[2] =~ /-auto_fit/ 
          options[:auto_fit] = argv[2].split("=")[1]
        elsif argv[3] =~ /-auto_fit/
          options[:auto_fit] = argv[3].split("=")[1]
        end
        # RLayout::NewsBoxMaker.new(options)
        
      when 'pillar'
        puts "processing newsman pillar ..."
        options = {}
        if File.directory?(path)
          options[:pillar_path] = path
        elsif File.exist?(path)
          options[:story_path]   = path
        end
        options[:jpg]  = true
        if argv[2] =~ /-time_stamp/
          options[:time_stamp] = argv[2].split("=")[1]
        end
        # RLayout::NewsPillarMaker.new(options)

      when 'rjob'
        puts "processing newsman job ..."
        folder        = `pwd`
        @jpg          = false
        @preview      = false
        options_count = 0
        if argv.include?("-jpg")
          @jpg = true
          argv.delete("-jpg")
          options_count += 1
        end
        if argv.include?("-preview")
          @preview = true
          argv.delete("-preview")
          options_count += 1
        end
        # if script_path is specified, use the file.
        # if script_path directory is given, use the first .rb file.
        script_path = File.expand_path(argv[1])
        if File.directory?(script_path)
          script_path = Dir.glob("#{script_path}/*.rb").first
          # return if no file is found
          unless script_path
            puts "no layout file found !!!"
            return
          end
        end
        if argc == 3 + options_count
          output_path = 'output.pdf'
          base_name = File.basename(script_path, ".rb")
          output_path = base_name + ".pdf" if base_name != 'layout.rb'
          RLayout::RJob.new(script_path: script_path, output_path: output_path, jpg: @jpg, preview: @preview)
        elsif argc == 4 + options_count
          RLayout::RJob.new(script_path: script_path, output_path: File.expand_path(argv[2]), jpg: @jpg, preview: @preview)
        elsif argc == 5 + options_count
          RLayout::RJob.new(script_path: script_path, project_folder: argv[2], output_path: argv[3], jpg: @jpg, preview: @preview )
        else
          puts "Do nothing"
        end
      
      when 'make_issue'
        options = {}
        options[:issie_path]  = path
        # RLayout::MakeIssue.new(options)

      when 'make_page'
        options = {}
        options[:page_path]  = path
        RLayout::MakePage.new(options)
      when 'make_article'
        options = {}
        options[:article_path]  = path
        options[:update_page]   = true
        # RLayout::MakeArticle.new(options)

      when 'lines', 'line'
        options = {}
        options[:line_count] = true
        if File.directory?(path)
          options[:article_path] = path
        elsif File.exist?(path)
          options[:story_path]   = path
        end
        options[:jpg]  = true
        # RLayout::NewsBoxMaker.new(options)
      when 'pdf2jpg'
        res = 'nornal'
        if argv.include?("-high")
          res = 'high' 
          puts "generating high resoltion image..."
        else
          puts "+++++++  no -high"
        end
        # RLayout::GraphicViewMac.pdf2jpg(path, resolution:res)
      when "font_width"
        folder = `pwd`
        puts "extracting font width from folder:#{folder} ..."
        # RLayout::FontWidthExtractor.new(folder.chomp!)
        return
      else
        puts HELP_TEXT
      end

    end
  end

  # def applicationDidFinishLaunching(notification)
  #
  # end

end
