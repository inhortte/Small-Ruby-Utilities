#! /usr/local/bin/ruby

require 'rexml/document'
require 'yaml'

def passwd(pass)
  { '%' => '%25',
    '#' => '%23',
    '$' => '%24',
    '&' => '%26',
    '/' => '%2F',
    ':' => '%3A',
    ';' => '%3B',
    '<' => '%3C',
    '=' => '%3D',
    '>' => '%3E',
    '?' => '%3F',
    '@' => '%40',
    '[' => '%5B',
    '\\' => '%5C',
    ']' => '%5D',
    '^' => '%5E',
    '`' => '%60',
    '{' => '%7B',
    '|' => '%7C',
    '}' => '%7D',
    '~' => '%7E' }.each_pair do |from, to|
    pass.gsub!(from, to)
  end
  pass
end

arg = ARGV[0]
login = '-----'
password = passwd('-----')
temp_file = '/tmp/gmail.xml'
out_file = '/home/polaris/.new_mail.yml'
quote = '"'
email_limit = 4

File.unlink temp_file if File.exist? temp_file
`wget -O - "https://#{login}:#{password}\@mail.google.com/mail/feed/atom" --no-check-certificate > #{temp_file}`
doc = REXML::Document.new File.new(temp_file)
entries = doc.elements.to_a("feed/entry")
number_of_new_emails = entries.size
entries.map! do |e|
  author = e.get_elements("author")[0]
  title = e.get_elements("title")[0].get_text
  title = title.nil? ? '-none-' : title.value
  { :subject => title,
    :from_name => author.get_elements("name")[0].get_text.value,
    :from_email => author.get_elements("email")[0].get_text.value,
    :sent => e.get_elements("issued")[0].get_text.value }
end

File.unlink out_file if File.exist? out_file
File.new(out_file, "w").write(entries.to_yaml)
  
