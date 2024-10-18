#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/stat.h>
#include <grp.h>
#include <pwd.h>

#include <message/message.h>
#include <argument/argument.h>
#include <utils/cslist.h>

int main(int argc, char **argv)
{
    Argument::ListeMap liste;
    CsList path;
    int largc;
    char **largv;
    struct passwd *pwd;
    struct group *group;
    std::string locale, project, pathstr, projectroot;
    char *va[1024];
    unsigned int i;

    liste["locale"] = Argument::Liste("-locale", 'c', 1, DEF_LOCALE);
    liste["path"]   = Argument::Liste("-path",   'c', 1, "");

#include "rexec.inc"

    largc = argc;
    largv = argv;

    Argument a(&liste, *argv);
    a.scan(--largc, ++largv);

    pwd = getpwuid(getuid());
    group = getgrgid(getegid());

    setuid( 0 );
    setgroups(0, NULL);
    setgid( 0 );

   projectroot = (std::string)a["projectroot"];
   if ( chdir((char*)projectroot.c_str()) < 0)
    {
        fprintf(stderr, "can't change to projectroot\n");
        exit (-1);
    }

    va[0] = new char[strlen(largv[0]) + ((std::string)a["path"]).size() + 1];
    path.setString(a["path"], ':');
    for ( i=0; i<path.size(); i++)
    {
        struct stat sb;
        strcpy( (char *)va[0], (path[i] + "/shell/" + *largv).c_str());
        if (stat(va[0], &sb) == 0 ) break;
    }

    if ( i == path.size() )
    {
        fprintf(stderr, "command not found <%s>\n", *largv);
        exit(-1);
    }

    locale = (std::string)a["locale"];
    project = (std::string)a["project"];
    pathstr = path.getString();

    va[1] = (char*)"-locale";
    va[2] = (char*)locale.c_str();
    va[3] = (char*)"-project";
    va[4] = (char*)project.c_str();
    va[5] = (char*)"-path";
    va[6] = (char*)pathstr.c_str();
    va[7] = (char*)"-user";
    va[8] = pwd->pw_name;
    va[9] = (char*)"-group";
    va[10] = group->gr_name;
    va[11] = (char*)"-projectroot";
    va[12] = (char*)projectroot.c_str();

    for ( i = 1 ; i != 1000 && largv[i] != NULL && largv[i+1] != NULL; i++, i++ )
    {
        va[i+12] = new char[strlen(largv[i]) + 4];
        strcpy((char *)va[i+12], ( std::string("-va") + largv[i]).c_str());
        va[i+13] = largv[i+1];
    }
    va[i + 12] = NULL;

    execv( va[0], va);
    fprintf(stderr, "command not executed <%s>\n", va[0]);
    fflush(stderr);
    exit(-1);
}
