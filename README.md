# utl-altair-slc-identify-connected-nodes-in-a-undirected-network-r-and-python
Altair slc identify connected nodes in an undirected network
    %let pgm=utl-altair-slc-identify-connected-nodes-in-a-undirected-network-r-and-python;

    %stop_submission;

    Altair slc identify connected nodes in a undirected network

    too lomg to post here, see github
    https://github.com/rogerjdeangelis/utl-altair-slc-identify-connected-nodes-in-a-undirected-network-r-and-python

    CONTENTS

      1 slc proc r
      2 slc proc python

    https://chat.deepseek.com/a/chat/s/ba77ed74-8d5b-4e69-9fb5-e9883ca1dbc7


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

    /*              _
      ___ _ __   __| |
     / _ \ `_ \ / _` |
    |  __/ | | | (_| |
     \___|_| |_|\__,_|

    */
