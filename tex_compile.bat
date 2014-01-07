cd temp
platex -kanji=sjis -guess-input-enc -interaction=nonstopmode ./temp.tex
jbibtex ./temp.aux
platex -kanji=sjis -guess-input-enc -interaction=nonstopmode ./temp.tex
platex -kanji=sjis -guess-input-enc -interaction=nonstopmode ./temp.tex
dvipdfmx ./temp.dvi
temp.pdf
cd ..