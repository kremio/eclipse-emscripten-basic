PROJECT = EmscriptenSetup

#Adapted from https://gist.github.com/funkaster/5199237
#GNU Make docs: http://www.gnu.org/software/make/manual/make.html
#Emscripten: http://kripken.github.io/emscripten-site/docs/
EMSDK_HOME = ~/playground/emscripten/emsdk_portable
EMSCRIPTEN_HOME = $(EMSDK_HOME)/emscripten/1.35.0
SYSROOT = /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.11.sdk
CLANG = /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang

SOURCES = $(wildcard */*.cpp) $(wildcard */*.c)
OBJECTS = $(patsubst %.cpp,%.o,$(patsubst %.c,%.o,$(SOURCES)))

#Sets up the EMSDK environment inside make.
#See gdw2 answer at https://stackoverflow.com/questions/7507810/howto-source-a-script-from-makefile/16490872#16490872
IGNORE := $(shell bash -c "source  $(EMSDK_HOME)/emsdk_env.sh; env | sed 's/=/:=/' | sed 's/^/export /' > makeenv")                         
include makeenv 

	
set-native:
	$(eval CXX := $(CLANG) -x c++)
	$(eval CC := $(CLANG))
	$(eval CPPFLAGS := -g -O2 -DHAS_TR1)
	$(eval CXXFLAGS := -v -std=c++11 -stdlib=libc++ -I $(EMSCRIPTEN_HOME)/system/include -I $(CLANG_INCLUDE))
	$(eval LDFLAGS := -lstdc++)
	$(eval TARGET := native)

set-js:
	$(eval CXX := em++)
	$(eval CC := emcc)
	$(eval CXXFLAGS := -std=c++11 -s ASM_JS=1)
	$(eval LDFLAGS := -lc++ -O0)
	$(eval TARGET := js)

set-html: set-js
	$(eval TARGET := html)

compile: $(OBJECTS)
	$(CC) $(LDFLAGS) $^ -o $(PROJECT).$(TARGET)

native: set-native compile

js: set-js show-vars compile

js-html: set-html show-vars compile

show-vars:
	echo $(PATH)
	echo $(SOURCES)
	echo $(OBJECTS)

clean:
	rm -f */*.o
	rm -rf $(PROJECT).* */*.dSYM
	rm -f makeenv