#!/usr/bin/env sh

cat <<EOF > .vim/colors/cool.vim
set background=dark
hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name = "cool"

" General
hi Normal ctermfg=255 guifg=$1 ctermbg=none guibg=none cterm=none gui=none
hi NonText ctermfg=244 guifg=$2 cterm=bold gui=bold
hi SpecialKey ctermfg=214 guifg=$3
hi MatchParen ctermfg=233 guifg=$4 ctermbg=none guibg=none cterm=bold gui=bold
hi ErrorMsg ctermfg=15 guifg=$5 ctermbg=9 guibg=#FF0000 cterm=none gui=none
hi Error ctermfg=15 guifg=$6 ctermbg=9 guibg=#FF0000 cterm=none gui=none
hi LineNr ctermbg=233 guibg=#151515 ctermfg=239 guifg=$7 cterm=none gui=none
hi Underlined ctermfg=32 guifg=$8 cterm=underline gui=underline
hi Todo ctermfg=142 guifg=$9 ctermbg=235 guibg=#252525 cterm=bold
hi CursorLine ctermbg=233 guibg=none cterm=none gui=none
hi CursorColumn ctermbg=233 guibg=none cterm=none gui=none
hi Visual ctermfg=233 guifg=$10 ctermbg=none guibg=$12
hi VisualNOS ctermfg=0 guifg=$11 ctermbg=none guibg=$13 cterm=none gui=none

" Search
hi IncSearch ctermfg=0 guifg=$14 ctermbg=226 guibg=$13 cterm=none gui=none
hi Search ctermfg=0 guifg=$15 ctermbg=151 guibg=$13 cterm=none gui=none

" Dividers
hi StatusLine ctermbg=235 guibg=$16 ctermfg=none guifg=$17 cterm=bold gui=none
hi StatusLineNC ctermbg=235 guibg=$16 ctermfg=none guifg=$18 cterm=none gui=none
hi VertSplit ctermfg=235 guifg=$19 ctermbg=none guibg=$20 cterm=none gui=none
hi ColorColumn ctermbg=233 guibg=$21

" Menus
hi Pmenu ctermfg=250 guifg=$22 ctermbg=236 guibg=$23
hi PmenuSel ctermfg=255 guifg=$24 ctermbg=167 guibg=$25
hi PmenuSbar ctermbg=243 guibg=$26
hi PmenuThumb ctermbg=250 guibg=$27
hi WildMenu ctermfg=0 guifg=$28 ctermbg=226 guibg=$29 cterm=none gui=none

" Syntax
hi Comment ctermfg=244 guifg=$1
hi Constant ctermfg=108 guifg=$2
hi Identifier ctermfg=145 guifg=$3 cterm=none
hi PreProc ctermfg=145 guifg=$4
hi Statement ctermfg=240 guifg=$5 cterm=none gui=none
hi Type ctermfg=246 guifg=$6 gui=none
hi Number ctermfg=174 guifg=$7
hi Delimiter ctermfg=240 guifg=$8
hi Special ctermfg=214 guifg=$9
hi Type ctermfg=246 guifg=$10 cterm=none gui=none

" Folds
hi Folded ctermfg=222 guifg=$11 ctermbg=234 guibg=#1c1c1c cterm=none gui=none
EOF
