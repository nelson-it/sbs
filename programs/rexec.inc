
// Allgemein gültige Optionen werden hier definiert
// ================================================
liste["debug"]       = Argument::Liste("-d",      'l', 1, "0");
liste["host"]        = Argument::Liste("-h",      'c', 1, "localhost");
liste["projectroot"] = Argument::Liste("-r",      'c', 1, "");
liste["project"]     = Argument::Liste("-project",'c', 1, "");
liste["umask"]       = Argument::Liste("-umask",  'l', 1, "");
// Deamon Optionen werden hier definiert
// ================================================
liste["daemon"]   = Argument::Liste("-daemon",  'l', 0, "0");
liste["logfile"]  = Argument::Liste("-logfile", 'c', 1, "-");
liste["lockfile"] = Argument::Liste("-lockfile",'c', 1, "");
liste["rundir"]   = Argument::Liste("-rundir",  'c', 1, "");
liste["runuser"]  = Argument::Liste("-runuser", 'c', 1, "");
liste["rungroup"] = Argument::Liste("-rungroup",'c', 1, "");
// IPC Optionen werden hier definiert
// ==================================
liste["port"]    = Argument::Liste("-p",  'l', 1, "8024");
// Php Options
// ===========
liste["PhpPath"] = Argument::Liste("-phppath", 'c', 1, "/usr/bin/php-cgi");
