#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: ExpressionTool

requirements:
  InlineJavascriptRequirement: {}

inputs:
  domain:
    type: Any
  prot_seq:
    type: ["null", File, string]
  db_bakta:
    type: ["null", Directory, string]

outputs:
  validated:
    type: boolean

expression: |
  ${
    if (inputs.domain === "prokaryotic" && inputs.db_bakta === null) {
      throw new Error("A prokaryotic run requires db_bakta; prot_seq is not used.");
    }
    if (inputs.domain === "eukaryotic" && inputs.prot_seq === null) {
      throw new Error("An eukaryotic run requires prot_seq; db_bakta is not used.");
    }
    return {
      validated: true
    };
  }
