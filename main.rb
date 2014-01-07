# coding : SJIS

def expand_spaces(str)
	#str内の"_"をスペースに変える．
	#ただし，$と$の間などはこれをしない
	true_str = str
	if /_/ =~ str
		true_str = ""
		flag = true
		len = str.size
		len.times do |i|
			#\[ 数式 \]
			if i > 0 && str[i-1] == "\\" && str[i] == "[" 
				flag = false
			elsif i > 0 && str[i-1] == "\\" && str[i] == "]"
				flag = true
			#$$ 数式 $$
			elsif i > 0 && str[i-1] == "$" && str[i] == "$"
				flag = !flag
			#$ 数式 $
			elsif (i < 1 || str[i-1] != "$") && str[i] == "$" && (i+1 > len || str[i+1] != "$")
				flag = !flag
			end
			#puts flag
			if flag && str[i] == "_"
				true_str << " "
			else
				true_str << str[i]
			end
		end#each_byte
	end
	return true_str
end

=begin
class Term
	#術語
	##term, 
	@@counter = 0
	def initialize(name="",*tag)
		@id = @@counter
		@name = name
		@tag = tag.flatten
		@@counter += 1
	end
end
=end

class Statement
	#文字列
	#それぞれの辞書の中から
	@@counter = 0
	def initialize(string)
		@id = @@counter
		@string = string
		@tag = []
		@@counter += 1
	end

	def search(tag)
		#tagはhashでtag["タグ名"]が関連するfileのパスの配列
		#stringの中にタグ名が入っていたら，それを説明するファイルのパスを取り出す
		#
		path = []
		tag.each do |key,val|
			true_key = expand_spaces(key)
			if /#{true_key}/ =~ @string
				path += val
			end
		end
		return path
	end
end

class Library
	attr_reader :name
	#辞書
	#辞書ID,辞書名
	@@counter = 0
	@@list_library = []
	@@list_tag = Hash.new
	@@list_key = []
	def initialize(name="")
	#"./lib/name"の中身の処理
		@id = @@counter
		@name = name
		@@list_library << name
		@@counter += 1
		dir = Dir::entries("./lib/#{name}")
		tex_file = []
		txt_file = []
		tag_list = Hash.new
		dir.each do |val|
			if /\.tex\z/ =~ val
				tex_file << val
				File.open("./lib/#{name}/#{val}", "r") do |f|
					first_line = f.readlines[0]
					#最初の行からメタデータを読み取る
					if /\A\%tags : / =~ first_line
						first_line = $'
						first_line.chomp!
						#最初の行に%tags : tag0 tag1 tag2 tag3 ･･･ って書いているのを処理．
						#tag_listにtagを追加
						#keyにタグ，値にtagのあるファイル
						first_line.split.each do |elm_tag|
							if tag_list.key?(elm_tag)
								tag_list[elm_tag] << "#{name}/#{val}"
							elsif
								tag_list[elm_tag] = ["#{name}/#{val}"]
							end
						end
					elsif /\A\%/ =~ first_line
						#最初の行に%tag0 tag1 tag2 tag3 ･･･ って書いているのを処理．
						first_line = $'
						first_line.chomp!
						#tag_listにtagを追加
						#keyにタグ，値にtagのあるファイル
						first_line.split.each do |elm_tag|
							if tag_list.key?(elm_tag)
								tag_list[elm_tag] << "#{name}/#{val}"
							elsif
								tag_list[elm_tag] = ["#{name}/#{val}"]
							end
						end
					end
					#最初の行からの処理終わり

				end
			elsif /\.txt\z/ =~ val
				txt_file << val
			end
		end
		
		@tag_list = tag_list
		tag_list.each do |key,val|
			if @@list_tag.key?(key)
				@@list_tag[key] += val
			else
				@@list_key << key
				@@list_tag[key] = val
			end
		end
	end
	#辞書内の
	def self.list_tag
		@@list_tag
	end
end

class Report
	#各辞書に入っている
	@@counter = Hash.new
	def initialize(library,name="",*tag)
		@name = name
		@tag = tag.flatten
		unless @@counter.key?(library)
			@@counter[library] = 0
		end
		@id = [library,@@counter[library]]
		@@counter[library] += 1
	end

end


def gets_report(dir)

end
=begin
a = Report.new("na", "a",["ahoge"],[1,2])
p a
p File.absolute_path("")
=end

library_list = []
#config.iniの読み込み．
File.open("config.ini","r") do |f|
	first = f.readlines[0].chomp.split
	if first[0] == "library"
		if first[1] == "all"
			library_list = Dir::entries("./lib")
			library_list.delete(".")
			library_list.delete("..")
		else
			first.delete
			library_list = first
		end
	end
end
libs = []
library_list.each do |lib_name|
	libs << Library.new(lib_name)
end
#config.iniからlibs(libraryの一覧)を作った．

#ref.bibの生成
bib = []
libs.each do |l|
	File.open( "./lib/#{l.name}/ref.bib","r") do |f|
		bib += f.readlines
	end
end

File.open("./temp/ref.bib","w") do |f|
	f.puts bib
end
#puts Library.list_tag.keys
#=begin
a = ""
File.open("./a.txt","r") do |f|
	a = f.readlines.join
end
x = Statement.new(a)
files = x.search( Library.list_tag)
#x = gets
body = []
files.each do |val|
	File.open("./lib/" + val,"r") do |f|
		body += f.readlines
	end
end

header = nil
File.open("./data/header.tex","r") do |f|
	header = f.readlines
end
tail = nil
File.open("./data/tail.tex","r") do |f|
	tail = f.readlines
end

#t = Time.now.to_i
#p t
#File.open("./temp/temp#{t}.tex","w") do |f|
File.open("./temp/temp.tex","w") do |f|
	f.puts header
	f.puts body
	f.puts tail
end
system("tex_compile.bat")
#=end
