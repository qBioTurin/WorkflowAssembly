cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["sed", "s/\\*//g"]

requirements:
  InlineJavascriptRequirement: {}

inputs:
  input_file:
    type: File
    inputBinding:
      position: 1

outputs:
  cleaned_file:
    type: File
    outputBinding:
      glob: "cleaned.faa"
      outputEval: ${
        var nameParts = inputs.input_file.basename.split(".");
        self[0].basename = nameParts[0] + ".faa";
        return self; }

stdout: cleaned.faa
