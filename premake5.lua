workspace "nn-glsl-core"
    configurations { "Debug", "Release" }
    architecture "x86_64"
    startproject "nn-glsl-core"

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

dofile("external/glfw-premake5.lua")

project "nn-glsl-core"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")
    staticruntime "On"
    dependson { "glfw" }

    -- Global defines for the entire project
    defines { "NOMINMAX" }

    files { "src/**.h", "src/**.cpp", "external/glad/src/glad.c" }
    includedirs {
        "external/glfw/include",
        "external/glad/include",
        "external/glm"
    }

    filter { "configurations:Debug" }
        defines { "DEBUG" }
        runtime "Debug"
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG" }
        runtime "Release"
        optimize "On"

    filter { "configurations:Debug", "system:windows" }
        buildoptions { "/MTd" }
    filter { "configurations:Release", "system:windows" }
        buildoptions { "/MT" }

    filter { "configurations:Debug", "system:linux"}
        buildoptions { "-static-libgcc", "-static-libstdc++", "-g" }
    filter { "configurations:Release", "system:linux"}
        buildoptions { "-static-libgcc", "-static-libstdc++" }


    filter { "system:windows" }
        defines { "WINDOWS" }
        files { "external/glad/src/glad_wgl.c" }
        links {
            "glfw",
            "opengl32"
        }

    filter { "system:linux" }
        defines { "LINUX" }
        files { "external/glad/src/glad_glx.c" }
        links {
            "GL",
            "dl",
            "tbb",
            "pthread",
            "X11",
            "Xrandr",
            "Xi",
            "Xxf86vm",
            "Xcursor",
            "glfw"
        }