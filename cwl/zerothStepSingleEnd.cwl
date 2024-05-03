#!/usr/bin/env cwl-runner
class: ExpressionTool
cwlVersion: "v1.2"

requirements:
  InlineJavascriptRequirement: {}
  LoadListingRequirement:
    loadListing: shallow_listing
inputs: 
  dir: Directory

expression: |
        ${
          
          var files = inputs.dir.listing;

          var reads = [];

          files.forEach(function (file) {
                reads.push(file);
          });

          return {"reads": reads};
         }

outputs:
  reads: File[]
