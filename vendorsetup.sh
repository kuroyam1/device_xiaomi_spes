# ROM source patches

color="\033[0;32m"
end="\033[0m"

echo -e "${color}Applying patches${end}"
sleep 1

# Remove pixel headers to avoid conflicts
rm -rf hardware/google/pixel/kernel_headers/Android.bp

# Remove hardware/lineage/compat to avoid conflicts
rm -rf hardware/lineage/compat/Android.bp

# Clone kernel/vendortree/xiaomi-hardware
echo -e "${color}Setup kernel,vendor,xiaomi-hardware tree ${end}"
git clone --depth=1 https://github.com/muralivijay/kernel_xiaomi_sm6225.git -b main kernel/xiaomi/spes
git clone --depth=1 https://github.com/kuroyam1/vendor_xiaomi_spes.git -b 13.0 vendor/xiaomi/spes
git clone https://github.com/LineageOS/android_hardware_xiaomi -b lineage-21 hardware/xiaomi
rm -fr hardware/lineage/interfaces/health/aidl/default/Android.bp
rm -fr hardware/xiaomi/interfaces/xiaomi/hardware/mtdservice/1.3
rm -fr hardware/xiaomi/interfaces/xiaomi/hardware/mfidoca/1.0

# Rename conflicting qti_kernel_headers in source
sed -i 's/"qti_kernel_headers"/"qti_kernel_headers_old"/g' vendor/lineage/build/soong/Android.bp
