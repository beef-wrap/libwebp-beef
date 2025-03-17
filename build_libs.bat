mkdir libs
mkdir libs\debug
mkdir libs\release

mkdir libwebp\build
cd libwebp\build

cmake ..

cmake --build .
copy Debug\libsharpyuv.lib ..\..\libs\debug
copy Debug\libwebp.lib ..\..\libs\debug

cmake --build . --config Release
copy Release\libsharpyuv.lib ..\..\libs\release
copy Release\libwebp.lib ..\..\libs\release