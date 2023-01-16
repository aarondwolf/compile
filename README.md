# compile
 Quickly compile a minimal Tex document from Stata.

## Installing via *net install*

The current version is still a work in progress. To install, user can use the net install command to download from the project's Github page:

```
net install compile, from("https://aarondwolf.github.io/compile")
```

## Syntax

```
compile texfile.tex using filename [, options]
```

## Description

compile generates a new .tex file using the standalone package, and (optionally) compiles it via the shell command. It takes texfile.tex as an input, and auto-generates the preamble necessary for the file to compile. Users can specify packages in packages as well as specific preamble text in preamble to ensure their tex file compiles properly.

Users can also specify the option nocompile if they wish to generate the new tex file without
compiling it. This is useful on its own, but is especially useful for debugging (e.g. figuring our which
packages are necessary) for compilation.

## Remarks

compile uses the standalone package to generate simple LaTeX documents.  The basic structure of your new file will be, by default:
```
\documentclass[border=3mm,preview]{standalone}
\begin{document}
\input{texfile.tex}
\end{document}
```

Any packages or preamble you specify will be added before  \begin{document}.


## Options

### Main

- **replace** Replace/overwrite the existing using file.
- **nocompile** Create the new file but do not compile.
- **packages(string)** List of packages to add to the preamble of the new LaTeX document via \usepackage{.}.
- **preamble(string)** List of commands to add to the preamble (as is).
- **border(string)** Adds a border option to the \documentclass{standalone} options. \documentclass{standalone} can accept a single number, or the user can specify, with braces, all four (LBRT) margins. E.g. {1mm 1mm 1mm 1mm}

## Examples
The following examples make use of the esttab package.
### Basic
```
sysuse auto
eststo clear
eststo: reg mpg price, r
eststo: reg mpg price foreign, r
esttab using basic.tex, replace
        
compile basic.tex using newfile, replace
```

### Complex
```
# delimit ;
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
                        "\end{table}"   );

compile complex.tex using newfile_complex, replace del
packages(booktabs graphics threeparttable) border({-20mm 3mm -20mm 3mm});
                
# delimit cr

```



## Author

Aaron Wolf, Northwestern University
