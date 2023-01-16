*! version 0.1.2  16jan2023 Aaron Wolf, aaron.wolf@u.northwestern.edu
program define compile, rclass
	
	version 15

	syntax anything(name=filename) using/ [, Replace noCOMPile PACKages(passthru) PREamble(passthru) BORDer(passthru) DELete]
	
//	Check whether using has a .tex or .pdf extension
	if strpos("`using'", ".tex") | strpos("`using'", ".pdf") {
		di as error "Option using must not specify an extension."
		error 198
	}
	
//	Subtract "packages(" and ")" from local packages
	local packages = substr("`packages'",10,strlen("`packages'")-10)

//	Extract "preamble(" and ")" from preamble macro
	local preamble = substr("`preamble'",10,strlen("`preamble'")-10)
	
//	Parse Border (LBRT, needs {} if all specified)
	if "`border'" == "" local border 3mm
	else local border = substr("`border'",8,strlen("`border'")-8)
	
//	Write new tex file
	* Open File
	file open compFile using `using'.tex, write `replace'
	* Initialize
	file write compFile "\documentclass[border=`border',preview]{standalone}" _n
	* Add packages
	foreach pkg of local packages {
		file write compFile "\usepackage{`pkg'}"  _n
	}
	foreach line of local preamble {
		file write compFile "`line'" _n
	}
	* Write document content
	file write compFile "\begin{document}"  _n
	file write compFile "\input{`filename'}"  _n
	file write compFile "\end{document}"  _n
	* Close
	file close compFile
	
//	Compile
	if "`compile'" != "nocompile" {
		shell pdflatex `using'.tex
		di "`using'.tex compiled."
		
		//	Delete Auxillary Files (pdflatex places them in pwd)
		if "`delete'" == "delete" {
			local last =  max(strrpos("`using'","/"),strrpos("`using'","\"))
			local fname = substr("`fullpath'",`last'+1,.)
			erase `fname'.log // Log file
			erase `fname'.aux // Aux File	
			di "Auxillary files erased."
		}
	}
	
end