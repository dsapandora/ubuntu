#!/bin/bash

echo "==> Recording box generation date"
date > /etc/vagrant_box_build_date

echo "==> Customizing message of the day"
MOTD_FILE=/etc/motd

echo -e '        \e[36m,u@@E@@E@@>,\e[0m         '                                                                                                      > ${MOTD_FILE}
echo -e '    \e[36m.;EBBBBBBBBBBBBBBE@\e[0m       '                                                                                                     >> ${MOTD_FILE}
echo -e '   \e[32mp@BB@5\e[36mEBBBBBBBBBBBBBB@\e[0m    '                                             'Packer.io built VM maintained by the Application' >> ${MOTD_FILE}
echo -e ' \e[32m,EBBBBBB@\e[36m@BBBBBBBBBBBBBBBL\e[0m  '                                             'Development Team, Centre for Ecology & Hydrology' >> ${MOTD_FILE}
echo -e ' \e[32m@B\e[0m██████\e[32mBB\e[0m██████\e[36mBB\e[0m██\e[36mBB\e[0m██\e[36mBB,\e[0m '                                                          >> ${MOTD_FILE}
echo -e '\e[32mEBB\e[0m██\e[32mBBBBBB\e[0m██\e[36m@BBBBB\e[0m██\e[36mBB\e[0m██\e[36mBBE\e[0m '                                                          >> ${MOTD_FILE}
echo -e '\e[32mEBB\e[0m██\e[32mBBBBBB\e[0m████\e[36mBBBB\e[0m██████\e[36mBBB\e[0m '                                                                     >> ${MOTD_FILE}
echo -e '\e[32m(BB\e[0m██\e[32mBBBBBB\e[0m██\e[32mBB\e[36m@BBB\e[0m██\e[36mBB\e[0m██\e[36mBBE\e[0m ' "Version:    $(lsb_release -sd)"                   >> ${MOTD_FILE}
echo -e ' \e[32mEB\e[0m██████\e[32mBB\e[0m██████\e[36m@B\e[0m██\e[36mBB\e[0m██\e[36mBB\e[0m  '       "Built:      $(date +%Y-%m-%d)"                    >> ${MOTD_FILE}
echo -e '  \e[32mEBBBBBBBBBBBBBB@\e[36m@BBBBBBE"\e[0m  '                                             "Management: ${CM}"                                >> ${MOTD_FILE}
echo -e '   \e[32m"EBBBBBBBBBBBBBB@\e[36m@B@@P\e[0m    '                                             'Repository: https://github.com/NERC-CEH/ubuntu'   >> ${MOTD_FILE}
echo -e '     \e[32m"tEBBBBBBBBBBBBBb"\e[0m      '                                                                                                      >> ${MOTD_FILE}
echo -e '         \e[32m"*CehP*"^"\e[0m          '                                                                                                      >> ${MOTD_FILE}
