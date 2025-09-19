#include <iostream>
#include <filesystem>

namespace fs = std::filesystem;

int main(int argc, char *argv[])
{
    fs::path currentPath = fs::current_path();
    
    for (const auto& entry : fs::directory_iterator(currentPath)) {
        std::cout << entry.path().filename() << std::endl;
    }
}
