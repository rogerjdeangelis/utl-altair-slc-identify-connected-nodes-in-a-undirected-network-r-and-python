    %let pgm=utl-altair-slc-identify-connected-nodes-in-a-undirected-network-r-and-python;

    %stop_submission;

    Altair slc identify connected nodes in a undirected network

    too lomg to post here, see github
    https://github.com/rogerjdeangelis/utl-altair-slc-identify-connected-nodes-in-a-undirected-network-r-and-python

    CONTENTS

      1 slc proc r
      2 slc proc python
      3 save subnet in autocall
      4 slc run subnet (worked as is)
        NOTE: The slc adds an additional note that a indexed join cannot used.
        I don't think sas would choose an indexed join. Indexes can be created on the fly?
        (you can select what join type you want but not indexed join?)


    How to setup a minimal python 310 to only import and export sas datasets
    https://github.com/rogerjdeangelis/utl-altair-slc-reading-writing-sas-datasets-using-latest-python-and-python310-sidebyside


    SOLUTION

        INPUT        OUTPUT       IDENTIFY THESE
       -------    -------------   DISCONECTED NETWORKS
       ID1 ID2    ID1 ID2 GROUP
                                  T----F
        A   Z      A   Z    1
        A   Y      A   Y    1     U----E----V
        A   X      A   X    1
        B   Z      B   Z    1     C----W----D
        B   Y      B   Y    1
        C   W      C   W    2     X----A----Y----B
        D   W      D   W    2           \       /
        E   V      E   V    3            \     /
        E   U      E   U    3             \   /
        F   T      F   T    4              \ /
                                            Z

    /*       _
    / |  ___| | ___   _ __  _ __ ___   ___   _ __
    | | / __| |/ __| | `_ \| `__/ _ \ / __| | `__|
    | | \__ \ | (__  | |_) | | | (_) | (__  | |
    |_| |___/_|\___| | .__/|_|  \___/ \___| |_|
                     |_|
    */

    /*--- autoexec has 'libname workx  "d:/wpswrkx" ---*/
    proc datasets lib=workx kill;
    run;quit;

    options validvarname=upcase; /*--- because r and python are case sensitive ---*/
    data workx.ids;
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

    /*---
    WORKX.IDS total obs=10

    Obs    ID1    ID2

      1     A      Z
      2     A      Y
      3     A      X
      4     B      Z
      5     B      Y
      6     C      W
      7     D      W
      8     E      V
      9     E      U
     10     F      T
    ---*/

    /*
     _ __  _ __ ___   ___ ___  ___ ___
    | `_ \| `__/ _ \ / __/ _ \/ __/ __|
    | |_) | | | (_) | (_|  __/\__ \__ \
    | .__/|_|  \___/ \___\___||___/___/
    |_|
    */

    options set=RHOME "C:\Progra~1\R\R-4.5.2\bin\r";
    proc r;
    export data=workx.ids r=df;
    submit;

    # Load igraph library
    library(igraph)

    # Create graph from edge list
    g <- graph_from_data_frame(df, directed = FALSE)

    # Find connected components
    components <- components(g)

    # Extract component membership for each node
    node_groups <- data.frame(
      node = names(components$membership),
      group = components$membership
    )

    # Map groups back to original edges
    df$group <- apply(df, 1, function(row) {
      # Find group of either node (they're in the same group)
      node_groups$group[node_groups$node == row[1]]
    })
    df
    endsubmit;
    import r=df data=workx.grps;
    run;

    proc print data=workx.grps;
    run;quit;

    /*---
    Altair SLC

    Obs    ID1    ID2    GROUP

      1     A      Z       1
      2     A      Y       1
      3     A      X       1
      4     B      Z       1
      5     B      Y       1
      6     C      W       2
      7     D      W       2
      8     E      V       3
      9     E      U       3
     10     F      T       4
    ---*/

    /*
    | | ___   __ _
    | |/ _ \ / _` |
    | | (_) | (_| |
    |_|\___/ \__, |
             |___/
    */

    1                                          Altair SLC     08:21 Wednesday, January 28, 2026

    NOTE: Copyright 2002-2025 World Programming, an Altair Company
    NOTE: Altair SLC 2026 (05.26.01.00.000758)
          Licensed to Roger DeAngelis
    NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

    NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
    NOTE: AUTOEXEC source line
    1       +  ï»¿ods _all_ close;
               ^
    ERROR: Expected a statement keyword : found "?"
    NOTE: Library workx assigned as follows:
          Engine:        SAS7BDAT
          Physical Name: d:\wpswrkx

    NOTE: Library slchelp assigned as follows:
          Engine:        WPD
          Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp


    LOG:  8:21:04
    NOTE: 1 record was written to file PRINT

    NOTE: The data step took :
          real time : 0.022
          cpu time  : 0.015


    NOTE: AUTOEXEC processing completed

    1         options set=RHOME "C:\Progra~1\R\R-4.5.2\bin\r";
    2         proc r;
    NOTE: Using R version 4.5.2 (2025-10-31 ucrt) from C:\Program Files\R\R-4.5.2
    3         export data=workx.ids r=df;
    NOTE: Creating R data frame 'df' from data set 'WORKX.ids'

    4         submit;
    5
    6         # Load igraph library
    7         library(igraph)
    8
    9         # Create graph from edge list
    10        g <- graph_from_data_frame(df, directed = FALSE)
    11
    12        # Find connected components
    13        components <- components(g)
    14
    15        # Extract component membership for each node
    16        node_groups <- data.frame(
    17          node = names(components$membership),
    18          group = components$membership
    19        )
    20
    21        # Map groups back to original edges
    22        df$group <- apply(df, 1, function(row) {
    23          # Find group of either node (they're in the same group)
    24          node_groups$group[node_groups$node == row[1]]
    25        })
    26        df
    27        endsubmit;

    NOTE: Submitting statements to R:

    >

    2                                                                                                                         Altair SLC

    > # Load igraph library
    > library(igraph)
    Attaching package: 'igraph'
    The following objects are masked from 'package:stats':
        decompose, spectrum
    The following object is masked from 'package:base':
        union
    >
    > # Create graph from edge list
    > g <- graph_from_data_frame(df, directed = FALSE)
    >
    > # Find connected components
    > components <- components(g)
    >
    > # Extract component membership for each node
    > node_groups <- data.frame(
    +   node = names(components$membership),
    +   group = components$membership
    + )
    >
    > # Map groups back to original edges
    > df$group <- apply(df, 1, function(row) {
    +   # Find group of either node (they're in the same group)
    +   node_groups$group[node_groups$node == row[1]]
    + })
    > df

    NOTE: Processing of R statements complete

    28        import r=df data=workx.grps;
    NOTE: Creating data set 'WORKX.grps' from R data frame 'df'
    NOTE: Column names modified during import of 'df'
    NOTE: Data set "WORKX.grps" has 10 observation(s) and 3 variable(s)

    29        run;
    NOTE: Procedure r step took :
          real time : 0.674
          cpu time  : 0.031


    30
    31        proc print data=workx.grps;
    32        run;quit;
    NOTE: 10 observations were read from "WORKX.grps"
    NOTE: Procedure print step took :
          real time : 0.016
          cpu time  : 0.015


    ERROR: Error printed on page 1

    NOTE: Submitted statements took :
          real time : 0.770
          cpu time  : 0.109


    /*___        _                                           _   _
    |___ \   ___| | ___   _ __  _ __ ___   ___   _ __  _   _| |_| |__   ___  _ __
      __) | / __| |/ __| | `_ \| `__/ _ \ / __| | `_ \| | | | __| `_ \ / _ \| `_ \
     / __/  \__ \ | (__  | |_) | | | (_) | (__  | |_) | |_| | |_| | | | (_) | | | |
    |_____| |___/_|\___| | .__/|_|  \___/ \___| | .__/ \__, |\__|_| |_|\___/|_| |_|
                         |_|                    |_|    |___/
    */

    options set=PYTHONHOME "D:\py314";
    proc python;
    submit;
    import pyarrow
    import pandas as pd
    import networkx as nx
    import pyreadstat as ps
    df,meta=ps.read_sas7bdat("d:/wpswrkx/ids.sas7bdat")
    # Create DataFrame

    # Create graph from edge list
    G = nx.Graph()
    G.add_edges_from(zip(df['ID1'], df['ID2']))

    # Find connected components
    components = list(nx.connected_components(G))

    # Create mapping from node to component number
    node_to_group = {}
    for group_num, component in enumerate(components, 1):
        for node in component:
            node_to_group[node] = group_num

    # Map groups back to edges
    df['group'] = df['ID1'].map(node_to_group)

    # Display result
    print(df)

    # python versions after 310 cannot crea a sas dataset
    # save df to parquet file to use in python 310 to create sas datasets
    df.to_parquet('d:/wpswrkx/df.parquet', engine='pyarrow')

    endsubmit;
    run;

    /*--- create sas dataset from parquet file ---*/
    /*--- very minial 310 basically just support for parquet files ---*/
    options set=PYTHONHOME "D:\py310";
    proc python;
    submit;
    import pyarrow
    import pandas as pd
    grps = pd.read_parquet('d:/wpswrkx/df.parquet', engine='pyarrow')
    print(grps)
    endsubmit;
    import python=grps data=workx.grps;
    run;quit;

    proc print data=workx.grps;
    title "sas dataset from parquet file";
    run;quit;

    /*---
    Altair SLC

    Obs    ID1    ID2    GROUP

      1     A      Z       1
      2     A      Y       1
      3     A      X       1
      4     B      Z       1
      5     B      Y       1
      6     C      W       2
      7     D      W       2
      8     E      V       3
      9     E      U       3
     10     F      T       4
    ---*/

    /*
    | | ___   __ _
    | |/ _ \ / _` |
    | | (_) | (_| |
    |_|\___/ \__, |
             |___/
    */

    1                                          Altair SLC     08:22 Wednesday, January 28, 2026

    NOTE: Copyright 2002-2025 World Programming, an Altair Company
    NOTE: Altair SLC 2026 (05.26.01.00.000758)
          Licensed to Roger DeAngelis
    NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

    NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
    NOTE: AUTOEXEC source line
    1       +  ï»¿ods _all_ close;
               ^
    ERROR: Expected a statement keyword : found "?"
    NOTE: Library workx assigned as follows:
          Engine:        SAS7BDAT
          Physical Name: d:\wpswrkx

    NOTE: Library slchelp assigned as follows:
          Engine:        WPD
          Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp


    LOG:  8:22:54
    NOTE: 1 record was written to file PRINT

    NOTE: The data step took :
          real time : 0.031
          cpu time  : 0.000


    NOTE: AUTOEXEC processing completed

    1         options set=PYTHONHOME "D:\py314";
    2         proc python;
    3         submit;
    4         import pyarrow
    5         import pandas as pd
    6         import networkx as nx
    7         import pyreadstat as ps
    8         df,meta=ps.read_sas7bdat("d:/wpswrkx/ids.sas7bdat")
    9         # Create DataFrame
    10
    11        # Create graph from edge list
    12        G = nx.Graph()
    13        G.add_edges_from(zip(df['ID1'], df['ID2']))
    14
    15        # Find connected components
    16        components = list(nx.connected_components(G))
    17
    18        # Create mapping from node to component number
    19        node_to_group = {}
    20        for group_num, component in enumerate(components, 1):
    21            for node in component:
    22                node_to_group[node] = group_num
    23
    24        # Map groups back to edges
    25        df['group'] = df['ID1'].map(node_to_group)
    26
    27        # Display result
    28        print(df)
    29
    30        # python versions after 310 cannot crea a sas dataset
    31        # save df to parquet file to use in python 310 to create sas datasets
    32        df.to_parquet('d:/wpswrkx/df.parquet', engine='pyarrow')
    33
    34        endsubmit;

    2                                                                                                                         Altair SLC


    NOTE: Submitting statements to Python:


    35        run;
    NOTE: Procedure python step took :
          real time : 1.184
          cpu time  : 0.046


    36
    37        /*--- create sas dataset from parquet file ---*/
    38        /*--- very minial 310 basically just support for parquet files ---*/
    39        options set=PYTHONHOME "D:\py310";
    40        proc python;
    41        submit;
    42        import pyarrow
    43        import pandas as pd
    44        grps = pd.read_parquet('d:/wpswrkx/df.parquet', engine='pyarrow')
    45        print(grps)
    46        endsubmit;

    NOTE: Submitting statements to Python:


    47        import python=grps data=workx.grps;
    NOTE: Creating data set 'WORKX.grps' from Python data frame 'grps'
    NOTE: Data set "WORKX.grps" has 10 observation(s) and 3 variable(s)

    48        run;quit;
    NOTE: Procedure python step took :
          real time : 0.921
          cpu time  : 0.031


    49
    50        proc print data=workx.grps;
    51        title "sas dataset from parquet file";
    52        run;quit;
    NOTE: 10 observations were read from "WORKX.grps"
    NOTE: Procedure print step took :
          real time : 0.015
          cpu time  : 0.000


    ERROR: Error printed on page 1

    NOTE: Submitted statements took :
          real time : 2.206
          cpu time  : 0.156


    options validvarname=upcase; /*--- because r and python are case sensitive ---*/
    data workx.ids;
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

    /*____                                   _                _     _                    _                  _ _
    |___ /   ___  __ ___   _____   ___ _   _| |__  _ __   ___| |_  (_)_ __    __ _ _   _| |_ ___   ___ __ _| | |
      |_ \  / __|/ _` \ \ / / _ \ / __| | | | `_ \| `_ \ / _ \ __| | | `_ \  / _` | | | | __/ _ \ / __/ _` | | |
     ___) | \__ \ (_| |\ V /  __/ \__ \ |_| | |_) | | | |  __/ |_  | | | | || (_| | |_| | || (_) | (_| (_| | | |
    |____/  |___/\__,_| \_/ \___| |___/\__,_|_.__/|_| |_|\___|\__| |_|_| |_| \__,_|\__,_|\__\___/ \___\__,_|_|_|

    */

    data _null_;
     file "c:/wpsoto/utl_subnet.sas";
     input;
     put _infile_;
    cards4;
    %macro utl_subnet(in=,out=,from=from,to=to,subnet=subnet,directed=1);
    /*----------------------------------------------------------------------
    SUBNET - Build connected subnets from pairs of nodes.
    Input Table :FROM TO pairs of rows
    Output Table:input data with &subnet added
    Work Tables:
      NODES - List of all nodes in input.
      NEW - List of new nodes to assign to current subnet.

    Algorithm:
    Pick next unassigned node and grow the subnet by adding all connected
    nodes. Repeat until all unassigned nodes are put into a subnet.

    To treat the graph as undirected set the DIRECTED parameter to 0.
    ----------------------------------------------------------------------*/
    %local subnetid next getnext ;
    %*----------------------------------------------------------------------
    Initialize subnet id counter.
    -----------------------------------------------------------------------;
    %let subnetid=0;
    proc sql noprint;
    *----------------------------------------------------------------------;
    * Create list of all nodes ;
    *----------------------------------------------------------------------;
      create table nodes as
        select . as subnet, &from as node from &in where &from is not null
        union
        select . as subnet, &to as node from &in where &to is not null
      ;
    *----------------------------------------------------------------------;
    * Generate query to get next unassigned node into a macro variable. ;
    *----------------------------------------------------------------------;
    %*----------------------------------------------------------------------
    Query is modified based on type of variable used for node.  This query
    is put into a macro variable so it can be used twice in the program.
    -----------------------------------------------------------------------;
      select catx(' ','select ',case when type='num' then 'node'
                   else 'quote(trim(node),"''")' end
                 ,'into :next from nodes where subnet=.')
        into :getnext
        from dictionary.columns
        where libname='WORK' and memname='NODES' and upcase(name)='NODE'
      ;
    *----------------------------------------------------------------------;
    * Get next unassigned node ;
    *----------------------------------------------------------------------;
      &getnext;
    %do %while (&sqlobs and not &sqlrc) ;
    *----------------------------------------------------------------------;
    * Set subnet to next id ;
    *----------------------------------------------------------------------;
      %let subnetid=%eval(&subnetid+1);
      update nodes set subnet=&subnetid where node=&next;
      %do %while (&sqlobs) ;
    *----------------------------------------------------------------------;
    * Get list of connected nodes for this subnet ;
    *----------------------------------------------------------------------;
        create table new as
          select distinct a.&to as node
            from &in a, nodes b, nodes c
            where a.&from= b.node
              and a.&to= c.node
              and b.subnet = &subnetid
              and c.subnet = .
        ;
    %if "&directed" ne "1" %then %do;
        insert into new
          select distinct a.&from as node
            from &in a, nodes b, nodes c
            where a.&to= b.node
              and a.&from= c.node
              and b.subnet = &subnetid
              and c.subnet = .
        ;
    %end;
    *----------------------------------------------------------------------;
    * Update subnet for these nodes ;
    *----------------------------------------------------------------------;
        update nodes set subnet=&subnetid
          where node in (select node from new )
        ;
      %end;
    *----------------------------------------------------------------------;
    * Get next unassigned node ;
    *----------------------------------------------------------------------;
      &getnext;
    %end;
    *----------------------------------------------------------------------;
    * Create output dataset by adding subnet number. ;
    *----------------------------------------------------------------------;
      create table &out as
        select distinct a.*,b.subnet as &subnet
          from &in a , nodes b
          where a.&from = b.node
      ;
    quit;
    %mend utl_subnet ;
    ;;;;
    run;

    /*  _         _                                     _                _
    | || |    ___| | ___   _ __ _   _ _ __    ___ _   _| |__  _ __   ___| |_
    | || |_  / __| |/ __| | `__| | | | `_ \  / __| | | | `_ \| `_ \ / _ \ __|
    |__   _| \__ \ | (__  | |  | |_| | | | | \__ \ |_| | |_) | | | |  __/ |_
       |_|   |___/_|\___| |_|   \__,_|_| |_| |___/\__,_|_.__/|_| |_|\___|\__|

    */

    %utlopts;
    %utl_subnet(in=workx.ids,out=workx.want,from=id1,to=id2,subnet=group,directed=0);

    proc print data=workx.want;
    run;

    /*---
    Altair SLC
    LIST: 7:41:29

    Obs    ID1    ID2    GROUP

      1     A      X       1
      2     A      Y       1
      3     A      Z       1
      4     B      Y       1
      5     B      Z       1
      6     C      W       2
      7     D      W       2
      8     E      U       3
      9     E      V       3
     10     F      T       4
    ---*/

    /*
    | | ___   __ _
    | |/ _ \ / _` |
    | | (_) | (_| |
    |_|\___/ \__, |
             |___/
    */

    1                                          Altair SLC      07:46 Thursday, January 29, 2026

    NOTE: Copyright 2002-2025 World Programming, an Altair Company
    NOTE: Altair SLC 2026 (05.26.01.00.000758)
          Licensed to Roger DeAngelis
    NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

    NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
    NOTE: AUTOEXEC source line
    1       +  ?ods _all_ close;
               ^
    ERROR: Expected a statement keyword : found "?"
    NOTE: Library workx assigned as follows:
          Engine:        SAS7BDAT
          Physical Name: d:\wpswrkx

    NOTE: Library slchelp assigned as follows:
          Engine:        WPD
          Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp


    LOG:  7:46:45
    NOTE: 1 record was written to file PRINT

    NOTE: The data step took :
          real time : 0.026
          cpu time  : 0.015


    NOTE: AUTOEXEC processing completed

    1         %utlopts;
    MPRINT(UTLOPTS):  MERROR NOCENTER DETAILS SERROR NONUMBER FULLSTIMER NODATE DKRICOND=WARN DKROCOND=WARN NOSYNTAXCHECK ;
    MPRINT(UTLOPTS):  run;
    MPRINT(UTLOPTS):  quit;
    MLOGIC(UTLOPTS): Ending execution
    2         %utl_subnet(in=workx.ids,out=workx.want,from=id1,to=id2,subnet=group,directed=0);
    MLOGIC(UTL_SUBNET): Beginning execution
    MLOGIC(UTL_SUBNET): This macro was compiled from the autocall file c:\wpsoto\utl_subnet.sas
    MLOGIC(UTL_SUBNET): Parameter IN has value workx.ids
    MLOGIC(UTL_SUBNET): Parameter OUT has value workx.want
    MLOGIC(UTL_SUBNET): Parameter FROM has value id1
    MLOGIC(UTL_SUBNET): Parameter TO has value id2
    MLOGIC(UTL_SUBNET): Parameter SUBNET has value group
    MLOGIC(UTL_SUBNET): Parameter DIRECTED has value 0
    MLOGIC(UTL_SUBNET): %LOCAL  subnetid next getnext
    MLOGIC(UTL_SUBNET): %LET (variable name is subnetid)
    MPRINT(UTL_SUBNET):  proc sql noprint;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Create list of all nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    MPRINT(UTL_SUBNET):  create table nodes as select . as subnet, id1 as node from workx.ids where id1 is not null union select . as subnet, id2 as node from workx.ids where id2 is not null ;
    NOTE: Data set "WORK.nodes" has 13 observation(s) and 2 variable(s)
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Generate query to get next unassigned node into a macro variable. ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  select catx(' ','select ',case when type='num' then 'node' else 'quote(trim(node),"''")' end ,'into :next from nodes where subnet=.') into :getnext from dictionary.columns where libname='WORK' and memname='NODES' and
                         upcase(name)='NODE' ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;

    2                                                                                                                         Altair SLC

    MPRINT(UTL_SUBNET):  * Get next unassigned node ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable getnext resolved to select quote(trim(node),"'") into :next from nodes where subnet=.
    MPRINT(UTL_SUBNET):  select quote(trim(node),"'") into :next from nodes where subnet=. ;
    SYMBOLGEN: Macro variable sqlobs resolved to 13
    SYMBOLGEN: Macro variable sqlrc resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs and not &sqlrc) loop beginning; condition is TRUE
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Set subnet to next id ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MLOGIC(UTL_SUBNET): %LET (variable name is subnetid)
    SYMBOLGEN: Macro variable subnetid resolved to 0
    SYMBOLGEN: Macro variable subnetid resolved to 1
    SYMBOLGEN: Macro variable next resolved to 'A'
    MPRINT(UTL_SUBNET):  update nodes set subnet=1 where node='A' ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) loop beginning; condition is TRUE
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 3 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  update nodes set subnet=1 where node in (select node from new ) ;
    NOTE: 3 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 3
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause

    3                                                                                                                         Altair SLC

    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 1 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  update nodes set subnet=1 where node in (select node from new ) ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 1 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 1
    MPRINT(UTL_SUBNET):  update nodes set subnet=1 where node in (select node from new ) ;
    NOTE: 0 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is FALSE; loop will not iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get next unassigned node ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable getnext resolved to select quote(trim(node),"'") into :next from nodes where subnet=.
    MPRINT(UTL_SUBNET):  select quote(trim(node),"'") into :next from nodes where subnet=. ;
    SYMBOLGEN: Macro variable sqlobs resolved to 8
    SYMBOLGEN: Macro variable sqlrc resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs and not &sqlrc) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;

    4                                                                                                                         Altair SLC

    MPRINT(UTL_SUBNET):  * Set subnet to next id ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MLOGIC(UTL_SUBNET): %LET (variable name is subnetid)
    SYMBOLGEN: Macro variable subnetid resolved to 1
    SYMBOLGEN: Macro variable subnetid resolved to 2
    SYMBOLGEN: Macro variable next resolved to 'C'
    MPRINT(UTL_SUBNET):  update nodes set subnet=2 where node='C' ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) loop beginning; condition is TRUE
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 1 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  update nodes set subnet=2 where node in (select node from new ) ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 2

    5                                                                                                                         Altair SLC

    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 1 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  update nodes set subnet=2 where node in (select node from new ) ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 2 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 2
    MPRINT(UTL_SUBNET):  update nodes set subnet=2 where node in (select node from new ) ;
    NOTE: 0 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is FALSE; loop will not iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get next unassigned node ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable getnext resolved to select quote(trim(node),"'") into :next from nodes where subnet=.
    MPRINT(UTL_SUBNET):  select quote(trim(node),"'") into :next from nodes where subnet=. ;
    SYMBOLGEN: Macro variable sqlobs resolved to 5
    SYMBOLGEN: Macro variable sqlrc resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs and not &sqlrc) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Set subnet to next id ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MLOGIC(UTL_SUBNET): %LET (variable name is subnetid)
    SYMBOLGEN: Macro variable subnetid resolved to 2
    SYMBOLGEN: Macro variable subnetid resolved to 3
    SYMBOLGEN: Macro variable next resolved to 'E'
    MPRINT(UTL_SUBNET):  update nodes set subnet=3 where node='E' ;
    NOTE: 1 record(s) updated in table WORK.nodes

    6                                                                                                                         Altair SLC

    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) loop beginning; condition is TRUE
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 3 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 2 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 3 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  update nodes set subnet=3 where node in (select node from new ) ;
    NOTE: 2 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 2
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 3 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 3 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;

    7                                                                                                                         Altair SLC

    SYMBOLGEN: Macro variable subnetid resolved to 3
    MPRINT(UTL_SUBNET):  update nodes set subnet=3 where node in (select node from new ) ;
    NOTE: 0 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is FALSE; loop will not iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get next unassigned node ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable getnext resolved to select quote(trim(node),"'") into :next from nodes where subnet=.
    MPRINT(UTL_SUBNET):  select quote(trim(node),"'") into :next from nodes where subnet=. ;
    SYMBOLGEN: Macro variable sqlobs resolved to 2
    SYMBOLGEN: Macro variable sqlrc resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs and not &sqlrc) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Set subnet to next id ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MLOGIC(UTL_SUBNET): %LET (variable name is subnetid)
    SYMBOLGEN: Macro variable subnetid resolved to 3
    SYMBOLGEN: Macro variable subnetid resolved to 4
    SYMBOLGEN: Macro variable next resolved to 'F'
    MPRINT(UTL_SUBNET):  update nodes set subnet=4 where node='F' ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) loop beginning; condition is TRUE
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 4 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 1 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 4 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  update nodes set subnet=4 where node in (select node from new ) ;
    NOTE: 1 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 1
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is TRUE; loop will iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get list of connected nodes for this subnet ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1

    8                                                                                                                         Altair SLC

    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  create table new as select distinct a.id2 as node from workx.ids a, nodes b, nodes c where a.id1= b.node and a.id2= c.node and b.subnet = 4 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Data set "WORK.new" has 0 observation(s) and 1 variable(s)
    SYMBOLGEN: Macro variable directed resolved to 0
    MLOGIC(UTL_SUBNET): %IF condition "&directed" ne "1"  evaluated to TRUE
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable to resolved to id2
    SYMBOLGEN: Macro variable from resolved to id1
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  insert into new select distinct a.id1 as node from workx.ids a, nodes b, nodes c where a.id2= b.node and a.id1= c.node and b.subnet = 4 and c.subnet = . ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: Indexes on dataset WORK.nodes not considered for indexed join due to the presence of extra WHERE clause
    NOTE: 0 records were inserted into WORK.new
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Update subnet for these nodes ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable subnetid resolved to 4
    MPRINT(UTL_SUBNET):  update nodes set subnet=4 where node in (select node from new ) ;
    NOTE: 0 record(s) updated in table WORK.nodes
    SYMBOLGEN: Macro variable sqlobs resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs) condition is FALSE; loop will not iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Get next unassigned node ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable getnext resolved to select quote(trim(node),"'") into :next from nodes where subnet=.
    MPRINT(UTL_SUBNET):  select quote(trim(node),"'") into :next from nodes where subnet=. ;
    NOTE: No rows were selected
    SYMBOLGEN: Macro variable sqlobs resolved to 0
    SYMBOLGEN: Macro variable sqlrc resolved to 0
    MLOGIC(UTL_SUBNET): %DO %WHILE(&sqlobs and not &sqlrc) condition is FALSE; loop will not iterate again
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    MPRINT(UTL_SUBNET):  * Create output dataset by adding subnet number. ;
    MPRINT(UTL_SUBNET):  *----------------------------------------------------------------------;
    SYMBOLGEN: Macro variable out resolved to workx.want
    SYMBOLGEN: Macro variable subnet resolved to group
    SYMBOLGEN: Macro variable in resolved to workx.ids
    SYMBOLGEN: Macro variable from resolved to id1
    MPRINT(UTL_SUBNET):  create table workx.want as select distinct a.*,b.subnet as group from workx.ids a , nodes b where a.id1 = b.node ;
    NOTE: No useful index exists on dataset WORKX.ids for indexed join use
    NOTE: No useful index exists on dataset WORK.nodes for indexed join use
    NOTE: Data set "WORKX.want" has 10 observation(s) and 3 variable(s)
    MPRINT(UTL_SUBNET):  quit;
    NOTE: Procedure sql step took :
          real time       : 0.826
          user cpu time   : 0.187
          system cpu time : 0.234
          Timestamp       :   29JAN26:07:46:45
          Peak working set    : 29876k
          Current working set : 29252k
          Page fault count    : 2177


    MLOGIC(UTL_SUBNET): Ending execution
    3
    4         proc print data=workx.want;
    5         run;
    NOTE: 10 observations were read from "WORKX.want"

    9                                                                                                                         Altair SLC

    NOTE: Procedure print step took :
          real time       : 0.005
          user cpu time   : 0.000
          system cpu time : 0.000
          Timestamp       :   29JAN26:07:46:45
          Peak working set    : 29876k
          Current working set : 29692k
          Page fault count    : 87


    6
    ERROR: Error printed on page 1

    NOTE: Submitted statements took :
          real time       : 0.952
          user cpu time   : 0.203
          system cpu time : 0.281
          Timestamp       :   29JAN26:07:46:45
          Peak working set    : 29876k
          Current working set : 29684k
          Page fault count    : 5006

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
