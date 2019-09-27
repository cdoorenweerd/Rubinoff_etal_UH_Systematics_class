# 20191001 Newick tree format and renaming.

## Introduction
The Newick Standard for representing trees in computer-readable form makes use of the correspondence between trees and nested parentheses, noticed in 1857 by the famous English mathematician Arthur Cayley. If we have this rooted tree:

![](newicktree.gif)

then in the tree file it is represented by the following sequence of printable characters:

(B,(A,C,E),D);

The tree ends with a semicolon. The bottommost node in this tree is an interior node, not a tip. Interior nodes are represented by a pair of matched parentheses. Between them are representations of the nodes that are immediately descended from that node, separated by commas. In the above tree, the immediate descendants are B, another interior node, and D. The other interior node is represented by a pair of parentheses, enclosing representations of its immediate descendants, A, C, and E. In our example these happen to be tips, but in general they could also be interior nodes and the result would be further nestings of parentheses, to any level.

Tips are represented by their names. A name can be any string of printable characters except blanks, colons, semicolons, parentheses, and square brackets.

Because you may want to include a blank in a name, it is assumed that an underscore character ("_") stands for a blank; any of these in a name will be converted to a blank when it is read in. Any name may also be empty: a tree like

(,(,,),);

is allowed. Trees can be multifurcating at any level.

Branch lengths can be incorporated into a tree by putting a real number, with or without decimal point, after a node and preceded by a colon. This represents the length of the branch immediately below that node. Thus the above tree might have lengths represented as:

(B:6.0,(A:5.0,C:3.0,E:4.0):5.0,D:11.0);

The tree starts on the first line of the file, and can continue to subsequent lines. It is best to proceed to a new line, if at all, immediately after a comma. Blanks can be inserted at any point except in the middle of a species name or a branch length.

The above description is actually of a subset of the Newick Standard. For example, interior nodes can have names in that standard. These names follow the right parenthesis for that interior node, as in this example:

(B:6.0,(A:5.0,C:3.0,E:4.0)Ancestor1:5.0,D:11.0);

Examples
To help you understand this tree representation, here are some trees in the above form:

((raccoon:19.19959,bear:6.80041):0.84600,((sea_lion:11.99700, seal:12.00300):7.52973,((monkey:100.85930,cat:47.14069):20.59201, weasel:18.87953):2.09460):3.87382,dog:25.46154);

(Bovine:0.69395,(Gibbon:0.36079,(Orang:0.33636,(Gorilla:0.17147,(Chimp:0.19268, Human:0.11927):0.08386):0.06124):0.15057):0.54939,Mouse:1.21460):0.10;

(Bovine:0.69395,(Hylobates:0.36079,(Pongo:0.33636,(G._Gorilla:0.17147, (P._paniscus:0.19268,H._sapiens:0.11927):0.08386):0.06124):0.15057):0.54939, Rodent:1.21460);

A;

((A,B),(C,D));

(Alpha,Beta,Gamma,Delta,,Epsilon,,,);

(Non-)Uniqueness
The Newick Standard does not make a unique representation of a tree, for two reasons. First, the left-right order of descendants of a node affects the representation, even though it is biologically uninteresting. Thus, to a biologist

(A,(B,C),D);

is the same tree as

(A,(C,B),D);

which is in turn the same tree as

(D,(C,B),A);

and that is the same tree as

(D,A,(C,B));

and

((C,B),A,D);

Rooted and unrooted trees
In addition, the standard is representing a rooted tree. For many biological purposes we may not be able to infer the position of the root. We would like to have a representation of an unrooted tree when decribing inferences in such cases. Here the convention is simply to arbitrarily root the tree and report the resulting rooted tree. Thus

(B,(A,D),C);

would be the same unrooted tree as

(A,(B,C),D);

and as

((A,D),(C,B));

Widespread use
In spite of this limitation of nonuniqueness the readability of the resulting representation (for trees of modest size) and the ease of writing programs that read it have kept this standard in widespread use.

Its competitors include the NEXUS standard for trees (part of the more general NEXUS standard for phylogeny data sets). However the NEXUS representation of trees is based on the Newick standard -- inside the NEXUS TREES Block you will find ... Newick trees.

A less Newick-based standard is the PhyloXML standard, which is an XML representation using nesting the <CLADE> ... </CLADE> tag pairs instead of parentheses.

Origin
The Newick Standard was adopted 26 June 1986 by an informal committee meeting convened by me during the Society for the Study of Evolution meetings in Durham, New Hampshire and consisting of James Archie, William H.E. Day, Wayne Maddison, Christopher Meacham, F. James Rohlf, David Swofford, and myself. (The committee was not an activity of the SSE nor endorsed by it). The reason for the name is that the second and final session of the committee met at Newick's restaurant in Dover, New Hampshire, and we enjoyed the meal of lobsters. The tree representation was a generalization of one developed by Christopher Meacham in 1984 for the tree plotting programs that he wrote for the PHYLIP package while visiting Seattle. His visit was a sabbatical leave from the University of Georgia, which thus indirectly partly funded that work.


## Renamer script

Now that we know how to renamer script 