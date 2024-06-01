Here lies the scripts used to build ROMs with help of crave (https://foss.crave.io/)
For LOS16: Use arch-python2 image
Build commands - 
crave devspace
crave run --no-patch "GET SCRIPT HERE" --disable-build-cache
--no-patch -> needed since we put patches manually
--disable-build-cache -> since compiler caching causes build errors (mbt issues :P)

Get image -
crave devspace
crave pull out/target/product/*/*.zip
curl https://raw.githubusercontent.com/sounddrill31/crave_aosp_builder/main/scripts/vscode-tunnel.sh | bash && tmux a -t codetunnel
Use vscode and download :P


