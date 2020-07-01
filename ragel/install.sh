git clone https://github.com/adrian-thurston/colm.git
cd colm
./autogen.sh 
./configure 
sudo make
sudo make install
cd ..

git clone https://github.com/adrian-thurston/ragel.git
cd ragel/
./autogen.sh 
./configure --with-colm=/usr/local
sudo make
sudo make install

LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH