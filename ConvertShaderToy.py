import os
import sys

path = os.getcwd()


class bcolors:
    OK = '\033[92m' #GREEN
    WARNING = '\033[93m' #YELLOW
    FAIL = '\033[91m' #RED
    RESET = '\033[0m' #RESET COLOR


# SHADER_FILE = "SAMPLE_FONT_SMOOTH.glsl"
SHADER_FILE = "TICK_TOCK.glsl"
# SHADER_FILE = "SPIRAL_CLOCK.glsl"
# SHADER_FILE = "REVOLVER_SDF.glsl"
# SHADER_FILE = "FONT_FUNCTION.glsl"
# SHADER_FILE = "READY/FONT_TEST_2.glsl"
# SHADER_FILE = "Butterfly.glsl"
# SHADER_FILE = "NeonFalloff.glsl"
# SHADER_FILE = "VornoiWeave.glsl"
# SHADER_FILE = "FractalMaze.glsl"
# SHADER_FILE = "RandomMultEffect.glsl"
# SHADER_FILE = "FloatLogger.glsl"
# SHADER_FILE = "CircleWavesEffect.glsl"
# SHADER_FILE = "GalaxyBasic.glsl"
HEADINGS = ["#version 300 es", "precision highp float;"]
CONVERT_TERMS = [["iTime", "u_time"], ["iResolution", "u_resolution"], ["fragColor", "gl_FragColor"], ["fragCoord", "gl_FragCoord"], ["iMouse", "u_mouse"], ["iChannel3", "u_texture_11"], ["iChannel0", "u_texture_10"]]
UNIFORMS = ["float u_time", "vec2 u_resolution", "vec2 u_mouse", 
"sampler2D u_texture_0", "sampler2D u_texture_10", "sampler2D u_texture_11"]
OUT_VARS = ["out vec4 fragColor;"]

toConvertPath = path+"/"+SHADER_FILE


def convertTerms(block: str):
    for t in CONVERT_TERMS:
        block = block.replace(t[0], t[1])
    return block

def addUniforms():
    final = []
    for u in UNIFORMS:
        u = "uniform "+u+";"
        final.append(u)
    return "\n".join(final)+"\n" + "\n".join(OUT_VARS) + "\n" + "\n"
        
    
def addHeadings():
    return "\n".join(HEADINGS) + "\n" 

def saveOutput(block):
    with open(toConvertPath, "w") as output:
        output.write(block)
        print(bcolors.OK + "SUCCESSFULLY CONVERTED SHADER" + bcolors.RESET)
        print(bcolors.WARNING + SHADER_FILE + bcolors.RESET)

def getShaderText(path):
    if os.path.isfile(path):
        with open(path) as f:
            lines = f.read()
            text = lines
            return text

    print(bcolors.FAIL+"COULDN'T FIND SHADER FILE")
    print(path)
    sys.exit()

def replaceMainFunc(text):
    lines = text.split("\n")
    for i, l in enumerate(lines):
        if "void mainImage" in l:
            replacement = "void main()"
            if "{" in l:
                replacement += "{"
            lines[i] = replacement
    return "\n".join(lines)
            


text = getShaderText(toConvertPath)

headings = addHeadings()

withUniforms = convertTerms(text)
withUniforms =  headings + addUniforms() + withUniforms
withUniforms = replaceMainFunc(withUniforms)

saveOutput(withUniforms)


# print(text)
    


# print(path)