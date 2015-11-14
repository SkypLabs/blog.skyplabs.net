La meilleure façon de tracer des diagrammes de Bode, Nyquist et Black en LaTeX est d'utiliser le package **bodegraph**. Ce dernier utilise à son tour le package **Tikz**.

Voici la démarche à suivre pour les installer tous les deux (en utilisant la distribution **TexLive**) :

    mkdir -p  ~/texmf/tex/latex
    cd ~/texmf/tex/latex
    cvs -z3 -d:pserver:anonymous@pgf.cvs.sourceforge.net:/cvsroot/pgf co -P pgf
    wget http://sciences-indus-cpge.papanicola.info/IMG/zip/bodegraph.zip
    unzip bodegraph.zip
    rm bodegraph.zip
    texhash ~/texmf

Et voici une [documentation pour bodegraph][1].

 [1]: http://www.math.washington.edu/tex-archive/graphics/pgf/contrib/bodegraph/bodegraph.pdf "Doc bodegraph"