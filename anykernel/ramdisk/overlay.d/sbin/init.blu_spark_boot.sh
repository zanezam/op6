#!/system/bin/sh

# (c) 2018-2020 changes for blu_spark by eng.stk

# Wait to set proper init values
sleep 30

# Set TCP congestion algorithm
echo "westwood" > /proc/sys/net/ipv4/tcp_congestion_control

# Tweak IO performance after boot complete
echo "zen" > /sys/block/sda/queue/scheduler
echo 512 > /sys/block/sda/queue/read_ahead_kb

# Input boost and stune configuration
echo "0:1056000 1:0 2:0 3:0 4:0 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
echo 500 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 5 > /dev/stune/top-app/schedtune.boost

# Disable scheduler core_ctl
echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable

# Enable adrenoboost
echo 1 > /sys/class/devfreq/5000000.qcom,kgsl-3d0/adrenoboost

# Set min cpu freq
echo 300000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 825600 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

# Configure cpu governor settings
echo "blu_schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/blu_schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/blu_schedutil/down_rate_limit_us
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/blu_schedutil/iowait_boost_enable
echo "blu_schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/blu_schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/blu_schedutil/down_rate_limit_us
echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/blu_schedutil/iowait_boost_enable

# Enable OTG by default
echo 1 > /sys/class/power_supply/usb/otg_switch

# Disable swap file
swapoff /data/vendor/swap/swapfile

echo "Boot blu_spark completed " >> /dev/kmsg
