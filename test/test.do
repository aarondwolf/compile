net install compile, from("https://aarondwolf.github.io/compile")

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





