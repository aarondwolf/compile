{smcl}
{* *! version 0.1.1 Aaron Wolf 16jan2023}{...}
{title:Title}

{phang}
{cmd:compile} {hline 2} Quickly compile a latex file using a standalone environment.

{marker syntax}{...}
{title:Syntax}

{pmore}
{cmd: compile} {cmd: texfile.tex} {cmd:using} {it:{help filename}} {cmd:,} [{it:options}]

{* Using -help odkmeta- as a template.}{...}
{* 24 is the position of the last character in the first column + 3.}{...}
{synoptset 24 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Main}
{synopt:{opt r:eplace}}Replace/overwrite the existing {it: using} file.{p_end}
{synopt:{opt nocomp:ile}}Create the new file but do not compile.{p_end}
{synopt:{opt pack:ages(string)}}List of packages to add to the preamble of the new LaTeX document via {it: \usepackage{.}}.{p_end}
{synopt:{opt pre:amble(string)}}List of commands to add to the preamble (as is).{p_end}
{synopt:{opt bord:er(string)}}Adds a border option to the {it: \documentclass{standalone}} 
options. {it: \documentclass{standalone}} can accept a single number, or the 
user can specify, with braces, all four (LBRT) margins. E.g. {1mm 1mm 1mm 1mm}{p_end}
{synopt:{opt del:ete}}Deletes the .log and .aux files after compilation.{p_end}


{synoptline}


{title:Description}

{pstd}
{cmd:compile} generates a new .tex file using the standalone package, and (optionally) 
compiles it via the {help shell} command. It takes {cmd: texfile.tex} as an input,
and auto-generates the preamble necessary for the file to compile. Users can 
specify packages in {cmd: packages} as well as specific preamble text in
{cmd: preamble} to ensure their tex file compiles properly.

{pstd}
Users can also specify the option {opt: nocomp:ile} if they wish to generate
the new tex file without compiling it. This is useful on its own, but is
especially useful for debugging (e.g. figuring our which packages are necessary)
for compilation.

{title:Remarks}

{pstd}
{cmd: compile} uses the standalone package to generate simple LaTeX documents.
The basic structure of your new file will be, by default:

	\documentclass[border=3mm,preview]{standalone}
	\begin{document}
	\input{texfile.tex}
	\end{document}

Any packages or preamble you specify will be added before {it: \begin{document}}.

{title:Basic Example}

{pstd}
The following examples make use of the {help esttab} package.

	sysuse auto
	eststo clear
	eststo: reg mpg price, r
	eststo: reg mpg price foreign, r
	esttab using basic.tex, replace
	
	compile basic.tex using newfile, replace
	
{title:Complex Example}

{pstd}
	# delimit ; {p_end}
	esttab using complex.tex, replace booktabs label b se  
		nomtitles noomitted
		coeflabels(price "Price" foreign "Foreign")
		stats(N r2, labels("Observations" "\$R^2\$"))
		starlevels(* .1 ** .05 *** .01)
		title("My Title\tnote{1}")
		mgroups("Model Group", pattern(1 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span
				erepeat(\cmidrule(lr){@span}) )
		prehead("\begin{table}[htbp]\centering"
			"\addtocounter{table}{2}"
			"\scalebox{0.7}{"
			"\begin{threeparttable}[b]"
			"\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}"
			"\caption{@title}"
			"\begin{tabular}{l*{@span}{c}}"
			"\toprule" )
		postfoot("\bottomrule"
			"\end{tabular}"
			"Heteroscedasticity-robust standard errors in parentheses."
			"\\ \emph{Levels of significance}: *\$ p<0.1\$ , **\$ p<0.05\$ , ***\$ p<0.01\$ "
			"\begin{tablenotes}"
			"\item [1] Special Table Footnote"
			"\end{tablenotes}"				
			"\end{threeparttable}"
			"}"	
			"\end{table}"	);

	compile complex.tex using newfile_complex, replace del
		packages(booktabs graphics threeparttable) border({-20mm 3mm -20mm 3mm});
		
	# delimit cr


	
{title:Author}

{pstd}Aaron Wolf, Northwestern University {p_end}
{pstd}aaron.wolf@u.northwestern.edu{p_end}












