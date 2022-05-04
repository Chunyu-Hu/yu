# in 5.7.1-qt-objs dir
cp ../qt-everywhere-opensource-src-5.7.1/qttools/ -fr ./
cd qttools/
qmake qttools.pro 
qmake src.pro
make sub-qdoc
cd assistant/
qmake assistant.pro 
make sub-qhelpgenerator
make qmake_all
make docs -j12 V=1
make docs V=1
cd qttools/
cp bin/* /opt/x86_64/qt-5.7.1/bin/
make docs V=1 -j12
make doc_install
make html_docs -j12 V=1

# in the doc folder, run 'F8'
