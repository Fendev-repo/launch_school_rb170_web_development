require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'pry-byebug'

before do
  @contents = File.readlines('data/toc.txt')
  @data = Dir.glob('data/*')
  @chapters = chapters
end

# rubocop:disable Metrics/BlockLength
helpers do
  def in_paragraphs(chapter_content)
    chapter_content.split("\n\n").map do |line|
      "<p>#{line}</p>"
    end.join
  end

  # rubocop:disable Metrics/AbcSize
  def highlight_search_query_in_paragraph(title)
    text = File.read(chapters[title].first)

    rtn_ary = text.split("\n\n").each_with_object([]) do |para, ary|
      if para.include?(params[:query])
        str = "<strong>#{params[:query]}</strong>"
        ary << para.gsub(params[:query], str)
      end
    end
    rtn_ary.first
  end
  # rubocop:enable Metrics/AbcSize

  def chapters
    chapters = {}

    @contents.each_with_index do |title, index|
      @data.each do |file|
        chapters[title] = [file, index + 1] if file.match?("p#{index + 1}[.]")
      end
    end
    chapters
  end

  def chapter_number(title)
    chapters[title].last
  end

  def scan_chapter_for(query)
    results = []

    chapters.each_pair do |title, chapter|
      text = File.read(chapter.first)
      results << title if text.include? query
    end
    results
  end
end
# rubocop:enable Metrics/BlockLength

get '/' do
  @title = 'The Adventures of Sherlock Holmes'

  erb :home
end

get '/chapters/:number' do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect '/' unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

not_found do
  redirect '/'
end

get '/show/:name' do
  params[:name]
end

get '/search' do
  query = params[:query]
  @search_results = nil

  @search_results = scan_chapter_for(query) unless [nil, ''].include? query

  erb :search
end
