#!/bin/bash
tar cvf /data/html-`date +%F_%w`.tar /var/www/html

#!/bin/bash
tar cvf /tmp/services-`date +%F_%H`.tar /etc/services
