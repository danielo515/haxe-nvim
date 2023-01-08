package vim.types;

extern class WOpts {
  /* `'breakindentopt'`  `'briopt'`  string (default empty)
    // 			local to window
    // 	Settings for `'breakindent'` . It can consist of the following optional
    // 	items and must be separated by a comma:
    // 		min:{n}	    Minimum text width that will be kept after
    // 			    applying `'breakindent'` , even if the resulting
    // 			    text should normally be narrower. This prevents
    // 			    text indented almost to the right window border
    // 			    occupying lot of vertical space when broken.
    // 		shift:{n}   After applying `'breakindent'` , the wrapped line's
    // 			    beginning will be shifted by the given number of
    // 			    characters.  It permits dynamic French paragraph
    // 			    indentation (negative) or emphasizing the line
    // 			    continuation (positive).
    // 		sbr	    Display the `'showbreak'`  value before applying the
    // 			    additional indent.
    // 		list:{n}    Adds an additional indent for lines that match a
    // 			    numbered or bulleted list (using the
    // 			    `'formatlistpat'`  setting).
    // 		list:-1	    Uses the length of a match with `'formatlistpat'` 
    // 			    for indentation.
    // 	The default value for min is 20, shift and list is 0.
   */
  @:native('Breakindentopt') var Breakindentopt:String;

  // `'colorcolumn'`  `'cc'` 	string	(default "")
  // 			local to window
  // 	`'colorcolumn'`  is a comma-separated list of screen columns that are
  // 	highlighted with ColorColumn |hl-ColorColumn|.  Useful to align
  // 	text.  Will make screen redrawing slower.
  // 	The screen column can be an absolute number, or a number preceded with
  // 	`'+'`  or `'-'` , which is added to or subtracted from `'textwidth'` . >
  //
  // 		:set cc=+1  " highlight column after `'textwidth'`
  // 		:set cc=+1,+2,+3  " highlight three columns after `'textwidth'`
  // 		:hi ColorColumn ctermbg=lightgrey guibg=lightgrey
  // <
  // 	When `'textwidth'`  is zero then the items with `'-'`  and `'+'`  are not used.
  // 	A maximum of 256 columns are highlighted.
  @:native('colorcolumn') var Colorcolumn:String;

  // `'concealcursor'`  `'cocu'` 	string (default: "")
  // 			local to window
  // 	Sets the modes in which text in the cursor line can also be concealed.
  // 	When the current mode is listed then concealing happens just like in
  // 	other lines.
  // 	  n		Normal mode
  // 	  v		Visual mode
  // 	  i		Insert mode
  // 	  c		Command line editing, for `'incsearch'`
  //
  // 	`'v'`  applies to all lines in the Visual area, not only the cursor.
  // 	A useful value is "nc".  This is used in help files.  So long as you
  // 	are moving around text is concealed, but when starting to insert text
  // 	or selecting a Visual area the concealed text is displayed, so that
  // 	you can see what you are doing.
  // 	Keep in mind that the cursor position is not always where it's
  // 	displayed.  E.g., when moving vertically it may change column.
  @:native('concealcursor') var Concealcursor:String;

  // `'conceallevel'`  `'cole'` 	number (default 0)
  // 			local to window
  // 	Determine how text with the "conceal" syntax attribute |:syn-conceal|
  // 	is shown:
  //
  // 	Value		Effect ~
  // 	0		Text is shown normally
  // 	1		Each block of concealed text is replaced with one
  // 			character.  If the syntax item does not have a custom
  // 			replacement character defined (see |:syn-cchar|) the
  // 			character defined in `'listchars'`  is used.
  // 			It is highlighted with the "Conceal" highlight group.
  // 	2		Concealed text is completely hidden unless it has a
  // 			custom replacement character defined (see
  // 			|:syn-cchar|).
  // 	3		Concealed text is completely hidden.
  //
  // 	Note: in the cursor line concealed text is not hidden, so that you can
  // 	edit and copy the text.  This can be changed with the `'concealcursor'`
  // 	option.
  @:native('conceallevel') var Conceallevel:Int;

  // `'cursorbind'`  `'crb'` 	boolean  (default off)
  // 			local to window
  // 	When this option is set, as the cursor in the current
  // 	window moves other cursorbound windows (windows that also have
  // 	this option set) move their cursors to the corresponding line and
  // 	column.  This option is useful for viewing the
  // 	differences between two versions of a file (see `'diff'` ); in diff mode;
  // 	inserted and deleted lines (though not characters within a line) are
  // 	taken into account.
  @:native('cursorbind') var Cursorbind:Bool;

  // `'cursorcolumn'`  `'cuc'` 	boolean	(default off)
  // 			local to window
  // 	Highlight the screen column of the cursor with CursorColumn
  // 	|hl-CursorColumn|.  Useful to align text.  Will make screen redrawing
  // 	slower.
  // 	If you only want the highlighting in the current window you can use
  // 	these autocommands: >
  // 		au WinLeave * set nocursorline nocursorcolumn
  // 		au WinEnter * set cursorline cursorcolumn
  // <
  @:native('cursorcolumn') var Cursorcolumn:Bool;

  // `'cursorline'`  `'cul'` 	boolean	(default off)
  // 			local to window
  // 	Highlight the text line of the cursor with CursorLine |hl-CursorLine|.
  // 	Useful to easily spot the cursor.  Will make screen redrawing slower.
  // 	When Visual mode is active the highlighting isn't used to make it
  // 	easier to see the selected text.
  @:native('cursorline') var Cursorline:Bool;

  // `'cursorlineopt'`  `'culopt'`  string (default: "number,line")
  // 			local to window
  // 	Comma-separated list of settings for how `'cursorline'`  is displayed.
  // 	Valid values:
  // 	"line"		Highlight the text line of the cursor with
  // 			CursorLine |hl-CursorLine|.
  // 	"screenline"	Highlight only the screen line of the cursor with
  // 			CursorLine |hl-CursorLine|.
  // 	"number"	Highlight the line number of the cursor with
  // 			CursorLineNr |hl-CursorLineNr|.
  //
  // 	Special value:
  // 	"both"		Alias for the values "line,number".
  //
  // 	"line" and "screenline" cannot be used together.
  @:native('cursorlineopt') var Cursorlineopt:String;

  // `'diff'` 			boolean	(default off)
  // 			local to window
  // 	Join the current window in the group of windows that shows differences
  // 	between files.  See |diff-mode|.
  @:native('diff') var Diff:Bool;

  // `'fillchars'`  `'fcs'` 	string	(default "")
  // 			global or local to window |global-local|
  // 	Characters to fill the statuslines, vertical separators and special
  // 	lines in the window.
  // 	It is a comma-separated list of items.  Each item has a name, a colon
  // 	and the value of that item:
  //
  // 	  item		default		Used for ~
  // 	  stl		' ' or `'^'` 	statusline of the current window
  // 	  stlnc		' ' or `'='` 	statusline of the non-current windows
  // 	  wbr		' '		window bar
  // 	  horiz		`'─'`  or `'-'` 	horizontal separators |:split|
  // 	  horizup	`'┴'`  or `'-'` 	upwards facing horizontal separator
  // 	  horizdown	`'┬'`  or `'-'` 	downwards facing horizontal separator
  // 	  vert		`'│'`  or `'|'` 	vertical separators |:vsplit|
  // 	  vertleft	`'┤'`  or `'|'` 	left facing vertical separator
  // 	  vertright	`'├'`  or `'|'` 	right facing vertical separator
  // 	  verthoriz	`'┼'`  or `'+'` 	overlapping vertical and horizontal
  // 					separator
  // 	  fold		`'·'`  or `'-'` 	filling `'foldtext'`
  // 	  foldopen	`'-'` 		mark the beginning of a fold
  // 	  foldclose	`'+'` 		show a closed fold
  // 	  foldsep	`'│'`  or `'|'`       open fold middle marker
  // 	  diff		`'-'` 		deleted lines of the `'diff'`  option
  // 	  msgsep	' '		message separator `'display'`
  // 	  eob		`'~'` 		empty lines at the end of a buffer
  //
  // 	Any one that is omitted will fall back to the default.  For "stl" and
  // 	"stlnc" the space will be used when there is highlighting, `'^'`  or `'='`
  // 	otherwise.
  //
  // 	Note that "horiz", "horizup", "horizdown", "vertleft", "vertright" and
  // 	"verthoriz" are only used when `'laststatus'`  is 3, since only vertical
  // 	window separators are used otherwise.
  //
  // 	If `'ambiwidth'`  is "double" then "horiz", "horizup", "horizdown";
  // 	"vert", "vertleft", "vertright", "verthoriz", "foldsep" and "fold"
  // 	default to single-byte alternatives. var
  //
  // 	Example: >
  // 	    :set fillchars=stl:^,stlnc:=,vert:│,fold:·,diff:-
  // <	This is similar to the default, except that these characters will also
  // 	be used when there is highlighting.
  //
  // 	For the "stl", "stlnc", "foldopen", "foldclose" and "foldsep" items
  // 	single-byte and multibyte characters are supported.  But double-width
  // 	characters are not supported.
  //
  // 	The highlighting used for these items:
  // 	  item		highlight group ~
  // 	  stl		StatusLine		|hl-StatusLine|
  // 	  stlnc		StatusLineNC		|hl-StatusLineNC|
  // 	  wbr		WinBar			|hl-WinBar| or |hl-WinBarNC|
  // 	  horiz		WinSeparator		|hl-WinSeparator|
  // 	  horizup	WinSeparator		|hl-WinSeparator|
  // 	  horizdown	WinSeparator		|hl-WinSeparator|
  // 	  vert		WinSeparator		|hl-WinSeparator|
  // 	  vertleft	WinSeparator		|hl-WinSeparator|
  // 	  vertright	WinSeparator		|hl-WinSeparator|
  // 	  verthoriz	WinSeparator		|hl-WinSeparator|
  // 	  fold		Folded			|hl-Folded|
  // 	  diff		DiffDelete		|hl-DiffDelete|
  // 	  eob		EndOfBuffer		|hl-EndOfBuffer|
  @:native('fillchars') var Fillchars:String;

  // `'foldcolumn'`  `'fdc'` 	string (default "0")
  // 			local to window
  // 	When and how to draw the foldcolumn. Valid values are:
  // 	    "auto":       resize to the minimum amount of folds to display.
  // 	    "auto:[1-9]": resize to accommodate multiple folds up to the
  // 			  selected level
  //             0:            to disable foldcolumn
  // 	    "[1-9]":      to display a fixed number of columns
  // 	See |folding|.
  @:native('foldcolumn') var Foldcolumn:String;

  // `'foldenable'`  `'fen'` 	boolean (default on)
  // 			local to window
  // 	When off, all folds are open.  This option can be used to quickly
  // 	switch between showing all text unfolded and viewing the text with
  // 	folds (including manually opened or closed folds).  It can be toggled
  // 	with the |zi| command.  The `'foldcolumn'`  will remain blank when
  // 	`'foldenable'`  is off.
  // 	This option is set by commands that create a new fold or close a fold.
  // 	See |folding|.
  @:native('foldenable') var Foldenable:Bool;

  // `'foldexpr'`  `'fde'` 	string (default: "0")
  // 			local to window
  // 	The expression used for when `'foldmethod'`  is "expr".  It is evaluated
  // 	for each line to obtain its fold level.  See |fold-expr|.
  //
  // 	The expression will be evaluated in the |sandbox| if set from a
  // 	modeline, see |sandbox-option|.
  // 	This option can't be set from a |modeline| when the `'diff'`  option is
  // 	on or the `'modelineexpr'`  option is off.
  //
  // 	It is not allowed to change text or jump to another window while
  // 	evaluating `'foldexpr'`  |textlock|.
  @:native('foldexpr') var Foldexpr:String;

  // `'foldignore'`  `'fdi'` 	string (default: "#")
  // 			local to window
  // 	Used only when `'foldmethod'`  is "indent".  Lines starting with
  // 	characters in `'foldignore'`  will get their fold level from surrounding
  // 	lines.  White space is skipped before checking for this character.
  // 	The default "#" works well for C programs.  See |fold-indent|.
  @:native('foldignore') var Foldignore:String;

  // `'foldlevel'`  `'fdl'` 	number (default: 0)
  // 			local to window
  // 	Sets the fold level: Folds with a higher level will be closed.
  // 	Setting this option to zero will close all folds.  Higher numbers will
  // 	close fewer folds.
  // 	This option is set by commands like |zm|, |zM| and |zR|.
  // 	See |fold-foldlevel|.
  @:native('foldlevel') var Foldlevel:Int;

  // `'foldmarker'`  `'fmr'` 	string (default: "{{{,}}}")
  // 			local to window
  // 	The start and end marker used when `'foldmethod'`  is "marker".  There
  // 	must be one comma, which separates the start and end marker.  The
  // 	marker is a literal string (a regular expression would be too slow).
  // 	See |fold-marker|.
  @:native('foldmarker') var Foldmarker:String;

  // `'foldmethod'`  `'fdm'` 	string (default: "manual")
  // 			local to window
  // 	The kind of folding used for the current window.  Possible values:
  // 	|fold-manual|	manual	    Folds are created manually.
  // 	|fold-indent|	indent	    Lines with equal indent form a fold.
  // 	|fold-expr|	expr	    `'foldexpr'`  gives the fold level of a line.
  // 	|fold-marker|	marker	    Markers are used to specify folds.
  // 	|fold-syntax|	syntax	    Syntax highlighting items specify folds.
  // 	|fold-diff|	diff	    Fold text that is not changed.
  @:native('foldmethod') var Foldmethod:String;

  // `'foldminlines'`  `'fml'` 	number (default: 1)
  // 			local to window
  // 	Sets the number of screen lines above which a fold can be displayed
  // 	closed.  Also for manually closed folds.  With the default value of
  // 	one a fold can only be closed if it takes up two or more screen lines.
  // 	Set to zero to be able to close folds of just one screen line.
  // 	Note that this only has an effect on what is displayed.  After using
  // 	"zc" to close a fold, which is displayed open because it's smaller
  // 	than `'foldminlines'` , a following "zc" may close a containing fold.
  @:native('foldminlines') var Foldminlines:Int;

  // `'foldnestmax'`  `'fdn'` 	number (default: 20)
  // 			local to window
  // 	Sets the maximum nesting of folds for the "indent" and "syntax"
  // 	methods.  This avoids that too many folds will be created.  Using more
  // 	than 20 doesn't work, because the internal limit is 20.
  @:native('foldnestmax') var Foldnestmax:Int;

  // `'foldtext'`  `'fdt'` 	string (default: "foldtext()")
  // 			local to window
  // 	An expression which is used to specify the text displayed for a closed
  // 	fold.  See |fold-foldtext|.
  //
  // 	The expression will be evaluated in the |sandbox| if set from a
  // 	modeline, see |sandbox-option|.
  // 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
  //
  // 	It is not allowed to change text or jump to another window while
  // 	evaluating `'foldtext'`  |textlock|.
  @:native('foldtext') var Foldtext:String;

  // `'linebreak'`  `'lbr'` 	boolean	(default off)
  // 			local to window
  // 	If on, Vim will wrap long lines at a character in `'breakat'`  rather
  // 	than at the last character that fits on the screen.  Unlike
  // 	`'wrapmargin'`  and `'textwidth'` , this does not insert <EOL>s in the file;
  // 	it only affects the way the file is displayed, not its contents.
  // 	If `'breakindent'`  is set, line is visually indented. Then, the value
  // 	of `'showbreak'`  is used to put in front of wrapped lines. This option
  // 	is not used when the `'wrap'`  option is off.
  // 	Note that <Tab> characters after an <EOL> are mostly not displayed
  // 	with the right amount of white space.
  @:native('linebreak') var Linebreak:Bool;

  // `'list'` 			boolean	(default off)
  // 			local to window
  // 	List mode: By default, show tabs as ">", trailing spaces as "-", and
  // 	non-breakable space characters as "+". Useful to see the difference
  // 	between tabs and spaces and for trailing blanks. Further changed by
  // 	the `'listchars'`  option.
  //
  // 	The cursor is displayed at the start of the space a Tab character
  // 	occupies, not at the end as usual in Normal mode.  To get this cursor
  // 	position while displaying Tabs with spaces, use: >
  // 		:set list lcs=tab:\ \
  // <
  // 	Note that list mode will also affect formatting (set with `'textwidth'`
  // 	or `'wrapmargin'` ) when `'cpoptions'`  includes `'L'` .  See `'listchars'`  for
  // 	changing the way tabs are displayed.
  @:native('list') var List:Bool;

  // `'listchars'`  `'lcs'` 	string	(default: "tab:> ,trail:-,nbsp:+")
  // 			global or local to window |global-local|
  // 	Strings to use in `'list'`  mode and for the |:list| command.  It is a
  // 	comma-separated list of string settings.
  //
  //
  // 	  @:native('eol') var eol:c		Character to show at the end of each line.  When
  // 			omitted, there is no extra character at the end of the
  // 			line.
  //
  // 	  @:native('tab') var tab:xy[z]	Two or three characters to be used to show a tab.
  // 			The third character is optional.
  //
  // 	  @:native('tab') var tab:xy	The `'x'`  is always used, then `'y'`  as many times as will
  // 			fit.  Thus "tab:>-" displays:
  // 				>
  // 				>-
  // 				>//
  // 				etc.
  //
  // 	  @:native('tab') var tab:xyz	The `'z'`  is always used, then `'x'`  is prepended, and
  // 			then `'y'`  is used as many times as will fit.  Thus
  // 			"tab:<->" displays:
  // 				>
  // 				<>
  // 				<->
  // 				<//>
  // 				etc.
  //
  // 			When "tab:" is omitted, a tab is shown as ^I.
  //
  // 	  @:native('space') var space:c	Character to show for a space.  When omitted, spaces
  // 			are left blank.
  //
  // 	  @:native('multispace') var multispace:c...
  // 	 		One or more characters to use cyclically to show for
  // 	 		multiple consecutive spaces.  Overrides the "space"
  // 			setting, except for single spaces.  When omitted, the
  // 			"space" setting is used.  For example;
  // 			`:set listchars=multispace://-+` shows ten consecutive
  // 			spaces as:
  // 				//-+//-+// ~
  //
  // 	  @:native('lead') var lead:c	Character to show for leading spaces.  When omitted;
  // 			leading spaces are blank.  Overrides the "space" and
  // 			"multispace" settings for leading spaces.  You can
  // 			combine it with "tab:", for example: >
  // 				:set listchars+=tab:>-,lead:.
  // <
  // 	  @:native('leadmultispace') var leadmultispace:c...
  // 			Like the |lcs-multispace| value, but for leading
  // 			spaces only.  Also overrides |lcs-lead| for leading
  // 			multiple spaces.
  // 			`:set listchars=leadmultispace://-+` shows ten
  // 			consecutive leading spaces as:
  // 				//-+//-+//XXX ~
  // 			Where "XXX" denotes the first non-blank characters in
  // 			the line.
  //
  // 	  @:native('trail') var trail:c	Character to show for trailing spaces.  When omitted;
  // 			trailing spaces are blank.  Overrides the "space" and
  // 			"multispace" settings for trailing spaces.
  //
  // 	  @:native('extends') var extends:c	Character to show in the last column, when `'wrap'`  is
  // 			off and the line continues beyond the right of the
  // 			screen.
  //
  // 	  @:native('precedes') var precedes:c	Character to show in the first visible column of the
  // 			physical line, when there is text preceding the
  // 			character visible in the first column.
  //
  // 	  @:native('conceal') var conceal:c	Character to show in place of concealed text, when
  // 			`'conceallevel'`  is set to 1.  A space when omitted.
  //
  // 	  @:native('nbsp') var nbsp:c	Character to show for a non-breakable space character
  // 			(0xA0 (160 decimal) and U+202F).  Left blank when
  // 			omitted.
  //
  // 	The characters `':'`  and `','`  should not be used.  UTF-8 characters can
  // 	be used.  All characters must be single width.
  //
  // 	Each character can be specified as hex: >
  // 		set listchars=eol:\\x24
  // 		set listchars=eol:\\u21b5
  // 		set listchars=eol:\\U000021b5
  // <	Note that a double backslash is used.  The number of hex characters
  // 	must be exactly 2 for \\x, 4 for \\u and 8 for \\U.
  //
  // 	Examples: >
  // 	    :set lcs=tab:>-,trail:-
  // 	    :set lcs=tab:>-,eol:<,nbsp:%
  // 	    :set lcs=extends:>,precedes:<
  // <	|hl-NonText| highlighting will be used for "eol", "extends" and
  // 	"precedes". |hl-Whitespace| for "nbsp", "space", "tab", "multispace";
  // 	"lead" and "trail".
  @:native('listchars') var Listchars:String;

  // `'number'`  `'nu'` 		boolean	(default off)
  // 			local to window
  // 	Print the line number in front of each line.  When the `'n'`  option is
  // 	excluded from `'cpoptions'`  a wrapped line will not use the column of
  // 	line numbers.
  // 	Use the `'numberwidth'`  option to adjust the room for the line number.
  // 	When a long, wrapped line doesn't start with the first character, `'-'`
  // 	characters are put before the number.
  // 	For highlighting see |hl-LineNr|, |hl-CursorLineNr|, and the
  // 	|:sign-define| "numhl" argument.
  //
  // 	The `'relativenumber'`  option changes the displayed number to be
  // 	relative to the cursor.  Together with `'number'`  there are these
  // 	four combinations (cursor in line 3):
  //
  // 		`'nonu'`           `'nu'`             `'nonu'`           `'nu'`
  // 		`'nornu'`          `'nornu'`          `'rnu'`            `'rnu'`
  //
  // 	    |apple          |  1 apple      |  2 apple      |  2 apple
  // 	    |pear           |  2 pear       |  1 pear       |  1 pear
  // 	    |nobody         |  3 nobody     |  0 nobody     |3   nobody
  // 	    |there          |  4 there      |  1 there      |  1 there
  @:native('number') var Number:Bool;

  // `'numberwidth'`  `'nuw'` 	number	(default: 4)
  // 			local to window
  // 	Minimal number of columns to use for the line number.  Only relevant
  // 	when the `'number'`  or `'relativenumber'`  option is set or printing lines
  // 	with a line number. Since one space is always between the number and
  // 	the text, there is one less character for the number itself.
  // 	The value is the minimum width.  A bigger width is used when needed to
  // 	fit the highest line number in the buffer respectively the number of
  // 	rows in the window, depending on whether `'number'`  or `'relativenumber'`
  // 	is set. Thus with the Vim default of 4 there is room for a line number
  // 	up to 999. When the buffer has 1000 lines five columns will be used.
  // 	The minimum value is 1, the maximum value is 20.
  @:native('numberwidth') var Numberwidth:Int;

  // `'previewwindow'`  `'pvw'` 	boolean (default off)
  // 			local to window
  // 	Identifies the preview window.  Only one window can have this option
  // 	set.  It's normally not set directly, but by using one of the commands
  // 	|:ptag|, |:pedit|, etc.
  @:native('previewwindow') var Previewwindow:Bool;

  // `'relativenumber'`  `'rnu'` 	boolean	(default off)
  // 			local to window
  // 	Show the line number relative to the line with the cursor in front of
  // 	each line. Relative line numbers help you use the |count| you can
  // 	precede some vertical motion commands (e.g. j k + -) with, without
  // 	having to calculate it yourself. Especially useful in combination with
  // 	other commands (e.g. y d c < > gq gw =).
  // 	When the `'n'`  option is excluded from `'cpoptions'`  a wrapped
  // 	line will not use the column of line numbers.
  // 	The `'numberwidth'`  option can be used to set the room used for the line
  // 	number.
  // 	When a long, wrapped line doesn't start with the first character, `'-'`
  // 	characters are put before the number.
  // 	See |hl-LineNr|  and |hl-CursorLineNr| for the highlighting used for
  // 	the number.
  //
  // 	The number in front of the cursor line also depends on the value of
  // 	`'number'` , see |number_relativenumber| for all combinations of the two
  // 	options.
  @:native('relativenumber') var Relativenumber:Bool;

  // `'rightleft'`  `'rl'` 	boolean	(default off)
  // 			local to window
  // 	When on, display orientation becomes right-to-left, i.e., characters
  // 	that are stored in the file appear from the right to the left.
  // 	Using this option, it is possible to edit files for languages that
  // 	are written from the right to the left such as Hebrew and Arabic.
  // 	This option is per window, so it is possible to edit mixed files
  // 	simultaneously, or to view the same file in both ways (this is
  // 	useful whenever you have a mixed text file with both right-to-left
  // 	and left-to-right strings so that both sets are displayed properly
  // 	in different windows).  Also see |rileft.txt|.
  @:native('rightleft') var Rightleft:Bool;

  // `'rightleftcmd'`  `'rlc'` 	string	(default "search")
  // 			local to window
  // 	Each word in this option enables the command line editing to work in
  // 	right-to-left mode for a group of commands:
  //
  // 		search		"/" and "?" commands
  //
  // 	This is useful for languages such as Hebrew, Arabic and Farsi.
  // 	The `'rightleft'`  option must be set for `'rightleftcmd'`  to take effect.
  @:native('rightleftcmd') var Rightleftcmd:String;

  // `'scroll'`  `'scr'` 		number	(default: half the window height)
  // 			local to window
  // 	Number of lines to scroll with CTRL-U and CTRL-D commands.  Will be
  // 	set to half the number of lines in the window when the window size
  // 	changes.  This may happen when enabling the |status-line| or
  // 	`'tabline'`  option after setting the `'scroll'`  option.
  // 	If you give a count to the CTRL-U or CTRL-D command it will
  // 	be used as the new value for `'scroll'` .  Reset to half the window
  // 	height with ":set scroll=0".
  @:native('scroll') var Scroll:Int;

  // `'scrollbind'`  `'scb'` 	boolean  (default off)
  // 			local to window
  // 	See also |scroll-binding|.  When this option is set, the current
  // 	window scrolls as other scrollbind windows (windows that also have
  // 	this option set) scroll.  This option is useful for viewing the
  // 	differences between two versions of a file, see `'diff'` .
  // 	See |`'scrollopt'` | for options that determine how this option should be
  // 	interpreted.
  // 	This option is mostly reset when splitting a window to edit another
  // 	file.  This means that ":split | edit file" results in two windows
  // 	with scroll-binding, but ":split file" does not.
  @:native('scrollbind') var Scrollbind:Bool;

  // `'scrolloff'`  `'so'` 	number	(default 0)
  // 			global or local to window |global-local|
  // 	Minimal number of screen lines to keep above and below the cursor.
  // 	This will make some context visible around where you are working.  If
  // 	you set it to a very large value (999) the cursor line will always be
  // 	in the middle of the window (except at the start or end of the file or
  // 	when long lines wrap).
  // 	After using the local value, go back the global value with one of
  // 	these two: >
  // 		setlocal scrolloff<
  // 		setlocal scrolloff=-1
  // <	For scrolling horizontally see `'sidescrolloff'` .
  @:native('scrolloff') var Scrolloff:Int;

  // `'showbreak'`  `'sbr'` 	string	(default "")
  // 			global or local to window |global-local|
  // 	String to put at the start of lines that have been wrapped.  Useful
  // 	values are "> " or "+++ ": >
  // 		:set showbreak=>\
  // <	Note the backslash to escape the trailing space.  It's easier like
  // 	this: >
  // 		:let &showbreak = '+++ '
  // <	Only printable single-cell characters are allowed, excluding <Tab> and
  // 	comma (in a future version the comma might be used to separate the
  // 	part that is shown at the end and at the start of a line).
  // 	The |hl-NonText| highlight group determines the highlighting.
  // 	Note that tabs after the showbreak will be displayed differently.
  // 	If you want the `'showbreak'`  to appear in between line numbers, add the
  // 	"n" flag to `'cpoptions'` .
  // 	A window-local value overrules a global value.  If the global value is
  // 	set and you want no value in the current window use NONE: >
  // 		:setlocal showbreak=NONE
  // <
  @:native('showbreak') var Showbreak:String;

  // `'sidescrolloff'`  `'siso'` 	number (default 0)
  // 			global or local to window |global-local|
  // 	The minimal number of screen columns to keep to the left and to the
  // 	right of the cursor if `'nowrap'`  is set.  Setting this option to a
  // 	value greater than 0 while having |`'sidescroll'` | also at a non-zero
  // 	value makes some context visible in the line you are scrolling in
  // 	horizontally (except at beginning of the line).  Setting this option
  // 	to a large value (like 999) has the effect of keeping the cursor
  // 	horizontally centered in the window, as long as one does not come too
  // 	close to the beginning of the line.
  // 	After using the local value, go back the global value with one of
  // 	these two: >
  // 		setlocal sidescrolloff<
  // 		setlocal sidescrolloff=-1
  // <
  // 	Example: Try this together with `'sidescroll'`  and `'listchars'`  as
  // 		 in the following example to never allow the cursor to move
  // 		 onto the "extends" character: >
  //
  // 		 :set nowrap sidescroll=1 listchars=extends:>,precedes:<
  // 		 :set sidescrolloff=1
  // <
  @:native('sidescrolloff') var Sidescrolloff:Int;

  // `'signcolumn'`  `'scl'` 	string	(default "auto")
  // 			local to window
  // 	When and how to draw the signcolumn. Valid values are:
  // 	   "auto"   	only when there is a sign to display
  // 	   "auto:[1-9]" resize to accommodate multiple signs up to the
  // 	                given number (maximum 9), e.g. "@:native('auto') var auto:4"
  // 	   "auto:[1-8]-[2-9]"
  // 	                resize to accommodate multiple signs up to the
  // 			given maximum number (maximum 9) while keeping
  // 			at least the given minimum (maximum 8) fixed
  // 			space. The minimum number should always be less
  // 			than the maximum number, e.g. "@:native('auto') var auto:2-5"
  // 	   "no"	    	never
  // 	   "yes"    	always
  // 	   "yes:[1-9]"  always, with fixed space for signs up to the given
  // 	                number (maximum 9), e.g. "@:native('yes') var yes:3"
  // 	   "number"	display signs in the `'number'`  column. If the number
  // 			column is not present, then behaves like "auto".
  //
  // 	Note regarding 'orphaned signs': with signcolumn numbers higher than
  // 	1, deleting lines will also remove the associated signs automatically;
  // 	in contrast to the default Vim behavior of keeping and grouping them.
  // 	This is done in order for the signcolumn appearance not appear weird
  // 	during line deletion.
  @:native('signcolumn') var Signcolumn:String;

  // `'spell'` 			boolean	(default off)
  // 			local to window
  // 	When on spell checking will be done.  See |spell|.
  // 	The languages are specified with `'spelllang'` .
  @:native('spell') var Spell:Bool;

  // `'statusline'`  `'stl'` 	string	(default empty)
  // 			global or local to window |global-local|
  // 	When non-empty, this option determines the content of the status line.
  // 	Also see |status-line|.
  //
  // 	The option consists of printf style `'%'`  items interspersed with
  // 	normal text.  Each status line item is of the form:
  // 	  %-0{minwid}.{maxwid}{item}
  // 	All fields except the {item} are optional.  A single percent sign can
  // 	be given as "%%".
  //
  // 	When the option starts with "%!" then it is used as an expression;
  // 	evaluated and the result is used as the option value.  Example: >
  // 		:set statusline=%!MyStatusLine()
  // <	The  variable will be set to the |window-ID| of the
  // 	window that the status line belongs to.
  // 	The result can contain %{} items that will be evaluated too.
  // 	Note that the "%!" expression is evaluated in the context of the
  // 	current window and buffer, while %{} items are evaluated in the
  // 	context of the window that the statusline belongs to.
  //
  // 	When there is error while evaluating the option then it will be made
  // 	empty to avoid further errors.  Otherwise screen updating would loop.
  //
  // 	Note that the only effect of `'ruler'`  when this option is set (and
  // 	`'laststatus'`  is 2 or 3) is controlling the output of |CTRL-G|.
  //
  // 	field	    meaning ~
  // 	-	    Left justify the item.  The default is right justified
  // 		    when minwid is larger than the length of the item.
  // 	0	    Leading zeroes in numeric items.  Overridden by `'-'` .
  // 	minwid	    Minimum width of the item, padding as set by `'-'`  & `'0'` .
  // 		    Value must be 50 or less.
  // 	maxwid	    Maximum width of the item.  Truncation occurs with a `'<'`
  // 		    on the left for text items.  Numeric items will be
  // 		    shifted down to maxwid-2 digits followed by `'>'` number
  // 		    where number is the amount of missing digits, much like
  // 		    an exponential notation.
  // 	item	    A one letter code as described below.
  //
  // 	Following is a description of the possible statusline items.  The
  // 	second character in "item" is the type:
  // 		N for number
  // 		S for string
  // 		F for flags as described below
  // 		- not applicable
  //
  // 	item  meaning ~
  // 	f S   Path to the file in the buffer, as typed or relative to current
  // 	      directory.
  // 	F S   Full path to the file in the buffer.
  // 	t S   File name (tail) of file in the buffer.
  // 	m F   Modified flag, text is "[+]"; "[-]" if `'modifiable'`  is off.
  // 	M F   Modified flag, text is ",+" or ",-".
  // 	r F   Readonly flag, text is "[RO]".
  // 	R F   Readonly flag, text is ",RO".
  // 	h F   Help buffer flag, text is "[help]".
  // 	H F   Help buffer flag, text is ",HLP".
  // 	w F   Preview window flag, text is "[Preview]".
  // 	W F   Preview window flag, text is ",PRV".
  // 	y F   Type of file in the buffer, e.g., "[vim]".  See `'filetype'` .
  // 	Y F   Type of file in the buffer, e.g., ",VIM".  See `'filetype'` .
  // 	q S   "[Quickfix List]", "[Location List]" or empty.
  // 	k S   Value of "@:native('b') var b:keymap_name" or `'keymap'`  when |:lmap| mappings are
  // 	      being used: "<keymap>"
  // 	n N   Buffer number.
  // 	b N   Value of character under cursor.
  // 	B N   As above, in hexadecimal.
  // 	o N   Byte number in file of byte under cursor, first byte is 1.
  // 	      Mnemonic: Offset from start of file (with one added)
  // 	O N   As above, in hexadecimal.
  // 	N N   Printer page number.  (Only works in the `'printheader'`  option.)
  // 	l N   Line number.
  // 	L N   Number of lines in buffer.
  // 	c N   Column number (byte index).
  // 	v N   Virtual column number (screen column).
  // 	V N   Virtual column number as -{num}.  Not displayed if equal to `'c'` .
  // 	p N   Percentage through file in lines as in |CTRL-G|.
  // 	P S   Percentage through file of displayed window.  This is like the
  // 	      percentage described for `'ruler'` .  Always 3 in length, unless
  // 	      translated.
  // 	a S   Argument list status as in default title.  ({current} of {max})
  // 	      Empty if the argument file count is zero or one.
  // 	{ NF  Evaluate expression between `'%{'`  and `'}'`  and substitute result.
  // 	      Note that there is no `'%'`  before the closing `'}'` .  The
  // 	      expression cannot contain a `'}'`  character, call a function to
  // 	      work around that.  See |stl-%{| below.
  // 	{% -  This is almost same as { except the result of the expression is
  // 	      re-evaluated as a statusline format string.  Thus if the
  // 	      return value of expr contains % items they will get expanded.
  // 	      The expression can contain the } character, the end of
  // 	      expression is denoted by %}.
  // 	      For example: >
  // 		func! Stl_filename() abort
  // 		    return "%t"
  // 		endfunc
  // <	        `stl=%{Stl_filename()}`   results in `"%t"`
  // 	        `stl=%{%Stl_filename()%}` results in `"Name of current file"`
  // 	%} -  End of `{%` expression
  // 	( -   Start of item group.  Can be used for setting the width and
  // 	      alignment of a section.  Must be followed by %) somewhere.
  // 	) -   End of item group.  No width fields allowed.
  // 	T N   For `'tabline'` : start of tab page N label.  Use %T or %X to end
  // 	      the label.  Clicking this label with left mouse button switches
  // 	      to the specified tab page.
  // 	X N   For `'tabline'` : start of close tab N label.  Use %X or %T to end
  // 	      the label, e.g.: %3Xclose%X.  Use %999X for a "close current
  // 	      tab" label.    Clicking this label with left mouse button closes
  // 	      specified tab page.
  // 	@ N   Start of execute function label. Use %X or %T to
  // 	      end the label, e.g.: %10@SwitchBuffer@foo.c%X.  Clicking this
  // 	      label runs specified function: in the example when clicking once
  // 	      using left mouse button on "foo.c" "SwitchBuffer(10, 1, `'l'` ;
  // 	      '    ')" expression will be run.  Function receives the
  // 	      following arguments in order:
  // 	      1. minwid field value or zero if no N was specified
  // 	      2. number of mouse clicks to detect multiple clicks
  // 	      3. mouse button used: "l", "r" or "m" for left, right or middle
  // 	         button respectively; one should not rely on third argument
  // 	         being only "l", "r" or "m": any other non-empty string value
  // 	         that contains only ASCII lower case letters may be expected
  // 	         for other mouse buttons
  // 	      4. modifiers pressed: string which contains "s" if shift
  // 	         modifier was pressed, "c" for control, "a" for alt and "m"
  // 	         for meta; currently if modifier is not pressed string
  // 	         contains space instead, but one should not rely on presence
  // 	         of spaces or specific order of modifiers: use |stridx()| to
  // 	         test whether some modifier is present; string is guaranteed
  // 	         to contain only ASCII letters and spaces, one letter per
  // 	         modifier; "?" modifier may also be present, but its presence
  // 	         is a bug that denotes that new mouse button recognition was
  // 	         added without modifying code that reacts on mouse clicks on
  // 	         this label.
  // 	< -   Where to truncate line if too long.  Default is at the start.
  // 	      No width fields allowed.
  // 	= -   Separation point between alignment sections. Each section will
  // 	      be separated by an equal number of spaces.
  // 	      No width fields allowed.
  // 	# -   Set highlight group.  The name must follow and then a # again.
  // 	      Thus use %#HLname# for highlight group HLname.  The same
  // 	      highlighting is used, also for the statusline of non-current
  // 	      windows.
  // 	* -   Set highlight group to User{N}, where {N} is taken from the
  // 	      minwid field, e.g. %1*.  Restore normal highlight with %* or %0*.
  // 	      The difference between User{N} and StatusLine  will be applied
  // 	      to StatusLineNC for the statusline of non-current windows.
  // 	      The number N must be between 1 and 9.  See |hl-User1..9|
  //
  // 	When displaying a flag, Vim removes the leading comma, if any, when
  // 	that flag comes right after plaintext.  This will make a nice display
  // 	when flags are used like in the examples below.
  //
  // 	When all items in a group becomes an empty string (i.e. flags that are
  // 	not set) and a minwid is not set for the group, the whole group will
  // 	become empty.  This will make a group like the following disappear
  // 	completely from the statusline when none of the flags are set. >
  // 		:set statusline=...%(\ [%M%R%H]%)...
  // <	Beware that an expression is evaluated each and every time the status
  // 	line is displayed.
  //
  // 	While evaluating %{} the current buffer and current window will be set
  // 	temporarily to that of the window (and buffer) whose statusline is
  // 	currently being drawn.  The expression will evaluate in this context.
  // 	The variable "@:native('g') var g:actual_curbuf" is set to the `bufnr()` number of the
  // 	real current buffer and "@:native('g') var g:actual_curwin" to the |window-ID| of the
  // 	real current window.  These values are strings.
  //
  // 	The `'statusline'`  option will be evaluated in the |sandbox| if set from
  // 	a modeline, see |sandbox-option|.
  // 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
  //
  // 	It is not allowed to change text or jump to another window while
  // 	evaluating `'statusline'`  |textlock|.
  //
  // 	If the statusline is not updated when you want it (e.g., after setting
  // 	a variable that's used in an expression), you can force an update by
  // 	using `:redrawstatus`.
  //
  // 	A result of all digits is regarded a number for display purposes.
  // 	Otherwise the result is taken as flag text and applied to the rules
  // 	described above.
  //
  // 	Watch out for errors in expressions.  They may render Vim unusable!
  // 	If you are stuck, hold down `':'`  or `'Q'`  to get a prompt, then quit and
  // 	edit your vimrc or whatever with "vim //clean" to get it right.
  //
  // 	Examples:
  // 	Emulate standard status line with `'ruler'`  set >
  // 	  :set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
  // <	Similar, but add ASCII value of char under the cursor (like "ga") >
  // 	  :set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
  // <	Display byte count and byte value, modified flag in red. >
  // 	  :set statusline=%<%f%=\ [%1%n%R%H]\ %-19(%3l,%02c%03V%)%O`'%02b'`
  // 	  :hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
  // <	Display a ,GZ flag if a compressed file is loaded >
  // 	  :set statusline=...%r%{VarExists(`'@:native('b') var b:gzflag'` ,'\ [GZ]')}%h...
  // <	In the |:autocmd|'s: >
  // 	  :let @:native('b') var b:gzflag : Int;
  // <	And: >
  // 	  :unlet @:native('b') var b:gzflag
  // <	And define this function: >
  // 	  :function VarExists(var, val)
  // 	  :    if exists(@:native('a') var a:var) | return a:val | else | return `''`  | endif
  // 	  :endfunction
  // <
  @:native('statusline') var Statusline:String;

  // `'virtualedit'`  `'ve'` 	string	(default "")
  // 			global or local to window |global-local|
  // 	A comma-separated list of these words:
  // 	    block	Allow virtual editing in Visual block mode.
  // 	    insert	Allow virtual editing in Insert mode.
  // 	    all		Allow virtual editing in all modes.
  // 	    onemore	Allow the cursor to move just past the end of the line
  // 	    none	When used as the local value, do not allow virtual
  // 			editing even when the global value is set.  When used
  // 			as the global value, "none" is the same as "".
  // 	    NONE	Alternative var spelling of "none".
  //
  // 	Virtual editing means that the cursor can be positioned where there is
  // 	no actual character.  This can be halfway into a tab or beyond the end
  // 	of the line.  Useful for selecting a rectangle in Visual mode and
  // 	editing a table.
  // 	"onemore" is not the same, it will only allow moving the cursor just
  // 	after the last character of the line.  This makes some commands more
  // 	consistent.  Previously the cursor was always past the end of the line
  // 	if the line was empty.  But it is far from Vi compatible.  It may also
  // 	break some plugins or Vim scripts.  For example because |l| can move
  // 	the cursor after the last character.  Use with care!
  // 	Using the `$` command will move to the last character in the line, not
  // 	past it.  This may actually move the cursor to the left!
  // 	The `g$` command will move to the end of the screen line.
  // 	It doesn't make sense to combine "all" with "onemore", but you will
  // 	not get a warning for it.
  // 	When combined with other words, "none" is ignored.
  @:native('virtualedit') var Virtualedit:String;

  // `'winbar'`  `'wbr'` 		string (default empty)
  // 			global or local to window |global-local|
  // 	When non-empty, this option enables the window bar and determines its
  // 	contents. The window bar is a bar that's shown at the top of every
  // 	window with it enabled. The value of `'winbar'`  is evaluated like with
  // 	`'statusline'` .
  //
  // 	When changing something that is used in `'winbar'`  that does not trigger
  // 	it to be updated, use |:redrawstatus|.
  //
  // 	Floating windows do not use the global value of `'winbar'` . The
  // 	window-local value of `'winbar'`  must be set for a floating window to
  // 	have a window bar.
  //
  // 	This option cannot be set in a modeline when `'modelineexpr'`  is off.
  @:native('winbar') var Winbar:String;

  // `'winblend'`  `'winbl'` 		number	(default 0)
  // 			local to window
  // 	Enables pseudo-transparency for a floating window. Valid values are in
  // 	the range of 0 for fully opaque window (disabled) to 100 for fully
  // 	transparent background. Values between 0-30 are typically most useful.
  //
  // 	UI-dependent. Works best with RGB colors. `'termguicolors'`
  @:native('winblend') var Winblend:Int;

  // `'winfixheight'`  `'wfh'` 	boolean	(default off)
  // 			local to window
  // 	Keep the window height when windows are opened or closed and
  // 	`'equalalways'`  is set.  Also for |CTRL-W_=|.  Set by default for the
  // 	|preview-window| and |quickfix-window|.
  // 	The height may be changed anyway when running out of room.
  @:native('winfixheight') var Winfixheight:Bool;

  // `'winfixwidth'`  `'wfw'` 	boolean	(default off)
  // 			local to window
  // 	Keep the window width when windows are opened or closed and
  // 	`'equalalways'`  is set.  Also for |CTRL-W_=|.
  // 	The width may be changed anyway when running out of room.
  @:native('winfixwidth') var Winfixwidth:Bool;

  // `'winhighlight'`  `'winhl'` 	string (default empty)
  // 			local to window
  // 	Window-local highlights.  Comma-delimited list of highlight
  // 	|group-name| pairs "{hl-from}:{hl-to},..." where each {hl-from} is
  // 	a |highlight-groups| item to be overridden by {hl-to} group in
  // 	the window.
  //
  // 	Note: highlight namespaces take precedence over `'winhighlight'` .
  // 	See |nvim_win_set_hl_ns()| and |nvim_set_hl()|.
  //
  // 	Highlights of vertical separators are determined by the window to the
  // 	left of the separator.  The `'tabline'`  highlight of a tabpage is
  // 	decided by the last-focused window of the tabpage.  Highlights of
  // 	the popupmenu are determined by the current window.  Highlights in the
  // 	message area cannot be overridden.
  //
  // 	Example: show a different color for non-current windows: >
  // 		set winhighlight=@:native('normal') var Normal:MyNormal,NormalNC:MyNormalNC
  // <
  @:native('winhighlight') var Winhighlight:String;

  // `'wrap'` 			boolean	(default on)
  // 			local to window
  // 	This option changes how text is displayed.  It doesn't change the text
  // 	in the buffer, see `'textwidth'`  for that.
  // 	When on, lines longer than the width of the window will wrap and
  // 	displaying continues on the next line.  When off lines will not wrap
  // 	and only part of long lines will be displayed.  When the cursor is
  // 	moved to a part that is not shown, the screen will scroll
  // 	horizontally.
  // 	The line will be broken in the middle of a word if necessary.  See
  // 	`'linebreak'`  to get the break at a word boundary.
  // 	To make scrolling horizontally a bit more useful, try this: >
  // 		:set sidescroll=5
  // 		:set listchars+=precedes:<,extends:>
  // <	See `'sidescroll'` , `'listchars'`  and |wrap-off|.
  // 	This option can't be set from a |modeline| when the `'diff'`  option is
  // 	on.
  @:native('wrap') var Wrap:Bool;
}
