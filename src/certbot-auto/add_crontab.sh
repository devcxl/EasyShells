#!/bin/bash
(crontab -l ; echo "0 */61 * * * /usr/local/bin/certbot renew") | crontab -