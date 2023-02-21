% vim: set ft=tex:
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{poster}[2023-02-11 Poster pour l’AÉDIROUM]

\LoadClass{article}

% Disposition
\RequirePackage[paperwidth=210mm, paperheight=315mm, total={210mm, 315mm}]{geometry}

% Polices
\RequirePackage{fontspec}
\setmainfont{Concourse T3}
\newfontfamily{\titlecaps}{Concourse C4}
\newfontfamily{\noticetext}{Concourse T3}[Scale=.65]
\RequirePackage[protrusion=true, expansion=true]{microtype}

% Traduction
\RequirePackage{polyglossia}
\RequirePackage{csquotes}

% Dessin
\RequirePackage{tikz}
\usetikzlibrary{calc}
\usetikzlibrary{fit}
\usetikzlibrary{intersections}
\usetikzlibrary{positioning}

% Système de coordonnées relatif à la page
% (adapté de <https://tex.stackexchange.com/a/89592>)
%
%   --------------------------
%   |(-1,1)    (0,1)    (1,1)|
%   |                        |
%   |(-1,0)    (0,0)    (1,0)|
%   |                        |
%   |(-1,-1)   (0,-1)  (1,-1)|
%   --------------------------
\def\parsecomma#1,#2\endparsecomma{\def\page@x{#1}\def\page@y{#2}}
\tikzdeclarecoordinatesystem{page}{
    \parsecomma#1\endparsecomma
    \pgfpointanchor{current page}{north east}
    % Save the upper right corner
    \pgf@xc=\pgf@x%
    \pgf@yc=\pgf@y%
    % save the lower left corner
    \pgfpointanchor{current page}{south west}
    \pgf@xb=\pgf@x%
    \pgf@yb=\pgf@y%
    % Transform to the correct placement
    \pgfmathparse{(\pgf@xc-\pgf@xb)/2.*\page@x+(\pgf@xc+\pgf@xb)/2.}
    \expandafter\pgf@x\expandafter=\pgfmathresult pt
    \pgfmathparse{(\pgf@yc-\pgf@yb)/2.*\page@y+(\pgf@yc+\pgf@yb)/2.}
    \expandafter\pgf@y\expandafter=\pgfmathresult pt
}

% Paragraphes suivant une courbe, en TikZ
% (adapté de <https://tex.stackexchange.com/a/68740>)
\RequirePackage{shapepar}

\def\shapeparnodeaccuracy{2}
\newcommand\shapeparnode[6][]{
    % 6 parameters:
    % style for node (default:empty),
    % h margin, v margin, left path, right path, text (just one paragraph!)

    % name left and right paths and compute their bounding boxes
    \begin{scope}[local bounding box=leftbb]
        \path[name path global=left,xshift=#2] #4;
    \end{scope}
    \node[inner ysep=-#3,inner xsep=0pt,fit=(leftbb)](leftbb){};
    \begin{scope}[local bounding box=rightbb]
        \path[name path global=right,xshift=-#2] #5;
    \end{scope}
    \node[inner ysep=-#3,inner xsep=0pt,fit=(rightbb)](rightbb){};

    % global bounding box
    \path let
    \p1=(leftbb.north west), \p2=(leftbb.south west),
    \p3=(rightbb.north east), \p4=(rightbb.south east)
    in
    \pgfextra{
        \pgfmathsetmacro{\ymin}{(\y1 < \y3) ? \y1 : \y3}
        \pgfmathsetmacro{\ymax}{(\y2 > \y4) ? \y2 : \y4}
        \typeout{ymin \ymin}
        \typeout{ymax \ymax}
    } node[inner sep=0,fit={(\x1,\ymin pt)(\x3,\ymax pt)}](mybb){};

    % compute nb steps
    \path let \p1=(mybb.north), \p2=(mybb.south) in
    \pgfextra{
        \pgfmathsetmacro{\fnthght}{1em/\shapeparnodeaccuracy}
        \pgfmathtruncatemacro{\nbsteps}{(\y1-\y2)/\fnthght}
        \xdef\nbsteps{\nbsteps}
        \typeout{nb steps \nbsteps}
    };

    % horizontal references
    \path (mybb.north) -- (mybb.south)
    \foreach \cnt in {0,1,...,\nbsteps}{
        \pgfextra{\pgfmathsetmacro{\pos}{\cnt/\nbsteps}}
        coordinate[pos=\pos] (ref \cnt)
    };

    % left and right boundaries coordinates
    \foreach \cnt in {0,1,...,\nbsteps}{
        % an horizontal line from left to right
        \path[name path=ltor]
        (mybb.west |- ref \cnt) --  (mybb.east |- ref \cnt);
        % same line from right to left
        \path[name path=rtol]
        (mybb.east |- ref \cnt) -- (mybb.west |- ref \cnt);
        % left boundary
        \path[name intersections={of=rtol and left,by={l \cnt},sort by=rtol}];
        % right boundary
        \path[name intersections={of=ltor and right,by={r \cnt},sort by=ltor}];
    }
    % start point (and initial value of boundshape)
    \path let \p1=(l 0) in 
    \pgfextra{
        \pgfmathsetmacro{\xstart}{\x1}
        \xdef\boundshape{{0}{0}b{\xstart}}
        \xdef\xmin{\xstart}
        \xdef\xmax{\xstart}
    };

    % top and bottom
    \path let \p1=(l 0), \p2=(l \nbsteps) in
    \pgfextra{
        \pgfmathsetmacro{\ystart}{\y1}\xdef\ystart{\ystart}
        \pgfmathsetmacro{\yending}{\y2}\xdef\yending{\yending}
    };
    % incremental definition of boundshape
    \foreach \cnt in {0,1,...,\nbsteps}{
        \path let \p1=(l \cnt), \p2=(r \cnt) in
        \pgfextra{
            \pgfmathsetmacro{\start}{\x1}
            \pgfmathsetmacro{\len}{\x2-\x1}
            \pgfmathsetmacro{\ypos}{\cnt/\nbsteps*(\ystart - \yending)}
            {\let\\=\relax \xdef\boundshape{\boundshape\\{\ypos}t{\start}{\len}}}
            \pgfmathsetmacro{\xmin}{(\xmin < \start) ? \xmin : \start}
            \xdef\xmin{\xmin}
            \pgfmathsetmacro{\xmax}{(\xmax > \start + \len) ? \xmax : \start + \len}
            \xdef\xmax{\xmax}
        };
    }
    % draw the node with text in a shapepar
    \pgfmathsetmacro{\ymax}{\ystart - \yending}
    {\let\\=\relax \xdef\boundshape{\boundshape\\{\ymax}e{0}}}
    \node[#1,text width=\xmax pt - \xmin pt,align=flush left,
    anchor=north west,inner sep=0]
    at (mybb.north west -| \xmin pt,0)
    {\Shapepar[1pt]{\boundshape}#6\par};
}

% Mise en page
\tikzset{
    poster background/.style={
        inner sep=0pt,
        outer sep=0pt,
    },
    poster name/.style 2 args={
        align=#1,
        anchor=#2,
        inner xsep=0pt,
        inner ysep=4pt,
        outer sep=0pt,
    },
    poster biography/.style={
        font=\large\color{text main},
    },
    poster notice/.style={
        fill=black,
        anchor=south west,
        font=\noticetext\color{white},
        minimum width=\paperwidth,
        text width=.9\paperwidth,
        align=left,
        outer sep=0pt,
        inner ysep=18pt,
    },
}

\newcommand{\background}[1]{
    \begin{scope}
        \clip (page cs:-1,-1) rectangle (page cs:1,1);
        \node[poster background] at (page cs:0,0)
            {\includegraphics[height=\paperheight]{#1}};
        \path[fill=background tint, blend mode=overlay]
            (page cs:-1,-1) rectangle (page cs:1,1);
    \end{scope}
}

\newcommand{\name}[5]{
    \node[poster name={#3}{#4}] at #5 {%
        \fontsize{64}{64}\selectfont\color{text accent}\strut\MakeLowercase{#1}\\[-.4em]
        \titlecaps\fontsize{64}{64}\selectfont\color{text main}\MakeLowercase{#2}\par
    };
}

\newcommand{\biography}[3]{
    % (Décommenter la ligne suivante pour afficher les guides de disposition du texte)
    %\path[draw=white, ultra thick] #1 #2;
    \shapeparnode[poster biography]{0pt}{1pt}{#1}{#2}{#3};
}

\newcommand{\notice}[2]{
    \node[poster notice] at (page cs:-1,-1) {
        \vspace*{-2pt}%
        \begin{minipage}[c]{.95\textwidth}
            \vspace*{0pt}
            \emph{Image:}\enspace#1\\[-.4em]
            \emph{Éléments biographiques:}\enspace#2
    
            \textbf{\@title} (\@author, \@date)
        \end{minipage}\hfill%
        \begin{minipage}[c]{.05\textwidth}
            \vspace*{0pt}
            \includegraphics[width=\linewidth]{images/aediroum-simple}
        \end{minipage}
    };
}
