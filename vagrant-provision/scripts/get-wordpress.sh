WORDPRESS_VERSION=$1

if [[ $WORDPRESS_VERSION ]]; then
	WORDPRESS_ZIP_NAME="wordpress-$WORDPRESS_VERSION.tar.gz"
else
	WORDPRESS_ZIP_NAME="latest.tar.gz";
fi

wget https://wordpress.org/$WORDPRESS_ZIP_NAME

tar -zxvf $WORDPRESS_ZIP_NAME
rm $WORDPRESS_ZIP_NAME
cd wordpress
cp -rf . ..
cd ..
rm -r wordpress
