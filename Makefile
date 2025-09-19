#
# 'make'        build executable file 'main'
# 'make clean'  removes all .o and executable files
#

# define the Cpp compiler to use
CXX = g++

# define any compile-time flags
CXXFLAGS := -std=c++17 -Wall -Wextra -g

# define library paths in addition to /usr/lib
LFLAGS =

# directories
OUTPUT   := output
SRC      := src
INCLUDE  := include
LIB      := lib
OBJDIR   := build

ifeq ($(OS),Windows_NT)
    MAIN        := main.exe
    SOURCEDIRS  := $(SRC)
    INCLUDEDIRS := $(INCLUDE)
    LIBDIRS     := $(LIB)
    FIXPATH     = $(subst /,\,$1)
    RM          := del /q /f
    MD          := mkdir
else
    MAIN        := main
    SOURCEDIRS  := $(shell find $(SRC) -type d)
    INCLUDEDIRS := $(shell find $(INCLUDE) -type d)
    LIBDIRS     := $(shell find $(LIB) -type d)
    FIXPATH     = $1
    RM          = rm -f
    MD          := mkdir -p
endif

# include directories
INCLUDES := $(patsubst %,-I%, $(INCLUDEDIRS:%/=%))

# libraries
LIBS := $(patsubst %,-L%, $(LIBDIRS:%/=%))

# sources, objects, deps
SOURCES := $(wildcard $(patsubst %,%/*.cpp, $(SOURCEDIRS)))
OBJECTS := $(patsubst $(SRC)/%.cpp,$(OBJDIR)/%.o,$(SOURCES))
DEPS    := $(OBJECTS:.o=.d)

# output binary path
OUTPUTMAIN := $(call FIXPATH,$(OUTPUT)/$(MAIN))

# default target: build + run
all: $(OUTPUT) $(OBJDIR) $(MAIN)
	@echo Build complete, running program...
	./$(OUTPUTMAIN)

$(OUTPUT):
	$(MD) $(OUTPUT)

$(OBJDIR):
	$(MD) $(OBJDIR)

$(MAIN): $(OBJECTS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(OUTPUTMAIN) $(OBJECTS) $(LFLAGS) $(LIBS)

# rule for compiling .cpp to .o (+ .d)
$(OBJDIR)/%.o: $(SRC)/%.cpp
	@$(MD) $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c -MMD $< -o $@

# include dependency files
-include $(DEPS)

.PHONY: clean
clean:
	$(RM) $(OUTPUTMAIN)
	$(RM) $(call FIXPATH,$(OBJECTS))
	$(RM) $(call FIXPATH,$(DEPS))
	@echo Cleanup complete!

run: all
	./$(OUTPUTMAIN)
	@echo Executing 'run: all' complete!
