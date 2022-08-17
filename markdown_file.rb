class MarkdownFile
  attr_reader :path, :front_matter, :title, :text

  def initialize(path)
    @path = path
    @front_matter = {}
    lines = IO.readlines(path)
    @front_matter_present = lines[0].start_with?('---')
    if @front_matter_present
      lines.shift
      i = lines.find_index { |l| l.start_with?('---') } - 1
      yaml = lines[0..i].join
      @front_matter = YAML.load(yaml)
      lines = lines.drop(i + 2)
    end
    @title = File.basename(path)[0...-(File.extname(path).length)]
    remove_wiki_links(lines)
    @text = lines.join
  end

  private

  def remove_wiki_links(lines)
    lines.each do |line|
      replacements = {}
      line.scan(/(\[\[(.*?)\]\])/) do |match|
        wikilink = match[0]
        text = match[1]
        link, label = text.split('|')
        page, anchor = link.split('#')
        replacements[wikilink] = if !label.nil?
                                   # [[Internal link|Alias]] -> Alias
                                   label
                                 elsif !anchor.nil?
                                   # [[Internal link#Reference]] -> Internal link > Reference
                                   "#{page} > #{anchor}"
                                 else
                                   # [[Internal link]] -> Internal link
                                   page
                                 end
      end
      replacements.each_pair { |k, v| line.gsub!(k, v) }
    end
  end
end

