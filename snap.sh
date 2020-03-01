!/bin/bash
cd /root/snap2html/DiogenesList-master/
python /root/snap2html/DiogenesList-master/diogeneslist.py /root/01 index
#sed -i "s#\[LINK ROOT\]#https://p.newo.cf#g"  /root/snap2html/DiogenesList-master/index.html
#sed -i "s#\[LINK PROTOCOL\]##g"  /root/snap2html/DiogenesList-master/index.html
#sed -i "s#\[SOURCE ROOT\]##g"  /root/snap2html/DiogenesList-master/index.html
#sed -i "s#\\\\\\\root\\\\\\\rclone\\\\\\\01##g"  /root/snap2html/DiogenesList-master/index.html
#sed -i "s#1>index#1>劳资转身就是一脚!#g" /root/snap2html/DiogenesList-master/index.html
#sed -i "s#e>index#e>啊哒!#g" /root/snap2html/DiogenesList-master/index.html
cp /root/snap2html/DiogenesList-master/index.html /root/snapGit/
cd /root/snapGit
git add .
git commit -m 'snap2htmlDailyUpdate'
git push  https://github.com/ticn/blog.git
