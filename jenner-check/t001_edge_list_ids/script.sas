/*----------------------------------------------------------------------
 Build the undirected-network edge list (WORKX.IDS) that drives the
 connected-nodes solution.
 Source: rogerjdeangelis/utl-altair-slc-identify-connected-nodes-in-a-
         undirected-network-r-and-python.
 Verbatim from the repo, with the only change being the external WORKX
 library dropped in favour of WORK so the bundle is self-contained.
 The VALIDVARNAME=UPCASE option is the author's, kept because R and
 Python are case sensitive.
----------------------------------------------------------------------*/

options validvarname=upcase; /*--- because r and python are case sensitive ---*/
data ids;
  input ID1$ ID2$;
cards4;
A Z
A Y
A X
B Z
B Y
C W
D W
E V
E U
F T
;;;;
run;quit;

proc print data=ids;
run;quit;
