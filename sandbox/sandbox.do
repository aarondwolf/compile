cap program drop compile
program define compile, rclass
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
		
		//	Delete Auxillary Files
		if "`delete'" == "delete" {
			erase `using'.log // Log file
			erase `using'.aux // 	
			di "Auxillary files erased."
		}
	}
	
end




qui {
	sysuse auto
	eststo clear
	eststo: reg mpg price, r
	eststo: reg mpg price foreign, r

	//	Basic esttab table
	esttab using basic.tex, replace

	//	Complex esttab table --> Requires graphics, threeparttable, and booktabs packages
	esttab using complex.tex, replace booktabs label b se ///
		nomtitles noomitted ///
		coeflabels(price "Price" foreign "Foreign") ///
		stats(N r2, labels("Observations" "\$R^2\$")) ///
		starlevels(* .1 ** .05 *** .01)  /// 
		title("My Title\tnote{1}") ///
		mgroups("Model Group", pattern(1 0) ///
				prefix(\multicolumn{@span}{c}{) suffix(}) span 	///
				erepeat(\cmidrule(lr){@span}) ) ///			
		prehead(	"\begin{table}[htbp]\centering"	///
					"\addtocounter{table}{2}" ///
					"%\renewcommand{\thetable}{\arabic{table}a}" ///
					"%\renewcommand{\theHtable}{\thetable B}% To keep hyperref happy" ///
					"\scalebox{0.7}{"	///
					"\begin{threeparttable}[b]" ///
					"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"	///
					"\caption{@title}"	///
					"\begin{tabular}{l*{@span}{c}}"	///
					"\toprule" ) ///
		postfoot(	"\bottomrule"	///
					"\end{tabular}"	///
					"Heteroscedasticity-robust standard errors in parentheses." ///
					"\\ \emph{Levels of significance}: *\$ p<0.1\$ , **\$ p<0.05\$ , ***\$ p<0.01\$ " ///
					"\begin{tablenotes}"	///
					"\item [1] Special Table Footnote" ///
					"\end{tablenotes}"	///				
					"\end{threeparttable}"	///
					"}"				///	
					"\end{table}"	)
	
	
}


//	Basic table
	compile basic.tex using newfile, replace del

//	Complex table --> Requires graphics, threeparttable, and booktabs packages
	compile complex.tex using newfile_complex, replace del ///
		packages(booktabs graphics threeparttable) border({-20mm 3mm -20mm 3mm})


exit





