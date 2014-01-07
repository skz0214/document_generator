data
	基礎ファイルが置いてある．
	header.tex
	tail.tex
	があり，これらに挟まれる形でtexファイルを生成する．
	パッケージを追加する時はここにかく．


lib
	ライブラリのフォルダここにライブラリを入れる．
	document_generator\lib\<ライブラリ名>
	中身は
	document_generator\lib\<ライブラリ名>\hoge.tex
	document_generator\lib\<ライブラリ名>\hoge.bib
	texファイルは一行目に
%tag : tag0 tag1 tag2 ･･･
	というようにタグを入れる．
	bibファイルは通常通りに作成

config.ini

	用いるライブラリを指定する．書き方は，
	library all
	ですべて指定．
	指定したい時は，
	library lib0 lib1 lib2 ･･･
	と書く

a.txt
	ここにチェックしたい文章を書く

main.rb
	いろいろ出来たらこれを実行！

temp/temp.tex
temp/temp.pdf
	完成したtex・pdfファイル