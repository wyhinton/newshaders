import os

path = os.getcwd()

SHADER_FILE = "Butterfly.glsl"
# SHADER_FILE = "NeonFalloff.glsl"
# SHADER_FILE = "VornoiWeave.glsl"
# SHADER_FILE = "FractalMaze.glsl"
# SHADER_FILE = "RandomMultEffect.glsl"
# SHADER_FILE = "FloatLogger.glsl"
# SHADER_FILE = "CircleWavesEffect.glsl"
# SHADER_FILE = "GalaxyBasic.glsl"
CONVERT_TERMS = [["void mainImage( out vec4 fragColor, in vec2 fragCoord )", "void main()"], ["iTime", "u_time"], ["iResolution", "u_resolution"], ["fragColor", "gl_FragColor"], ["fragCoord", "gl_FragCoord"], ["iMouse", "u_mouse"]]
UNIFORMS = ["float u_time", "vec2 u_resolution", "vec2 u_mouse", 
"sampler2D u_texture_0"]

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
    return "\n".join(final)+"\n"
        
    

def saveOutput(block):
    with open(toConvertPath, "w") as output:
        output.write(block)



text = ""
with open(toConvertPath) as f:
    lines = f.read()
    text = lines

withUniforms = addUniforms() + text
withUniforms = convertTerms(withUniforms)

saveOutput(withUniforms)


print(text)
    


# print(path)