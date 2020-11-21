./build_image_base.sh && ./build_image.sh && ./reload_container.sh

sleep 3
./thruk_rest_api.sh
