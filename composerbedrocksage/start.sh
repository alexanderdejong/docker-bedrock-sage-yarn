#!/bin/bash
###### variables ##################
projectdir='/var/www/html'
envfile='/root/.env'

###### functions ##################
function install_bedrock(){
# install bedrock
    /usr/bin/composer create-project roots/bedrock ${projectdir} && \
echo "Bedrock installed..."
}
###################################
# if there is no projectdir create it
if [ ! -d ${projectdir}  ]; then
    mkdir -p ${projectdir}
fi

# check if directory /var/www/html is empty then install bedrock
[[ $(ls -1 ${projectdir} | wc -l ) -gt 0 ]] || install_bedrock

# chack if we need sage if SAGE_INSTALL = 'yes' install sage
if [ ${SAGE_INSTALL} = 'yes' ]; then
    cd ${projectdir}/web/app/themes
    composer create-project roots/sage ${SAGE_THEME_NAME} ${SAGE_VERSION} && \
echo "Sage installed..."
fi

# copy .env file to projectdir if it exist
if [ -f ${envfile} ]; then
    cp ${envfile} ${projectdir} && echo "copy .env file to working directory"
fi

# run apache in doreground
/usr/local/bin/apache2-foreground
