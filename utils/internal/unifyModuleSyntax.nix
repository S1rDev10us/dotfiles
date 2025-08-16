# https://github.com/NixOS/nixpkgs/blob/fc756aa6f5d3e2e5666efcf865d190701fef150a/lib/modules.nix#L543-L629
/**
Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
{lib, ...}: let
  inherit
    (lib)
    mkMerge
    removeAttrs
    throw
    head
    attrNames
    throwIfNot
    isAttrs
    addFreeformType
    ;
in
  /**
  Massage a module into canonical form, that is, a set consisting
  of ‘options’, ‘config’ and ‘imports’ attributes.

  # Inputs

  `file`

  : 1\. Function argument

  `key`

  : 2\. Function argument

  `m`

  : 3\. Function argument
  */
  file: key: m: let
    addMeta = config:
      if m ? meta
      then
        mkMerge [
          config
          {meta = m.meta;}
        ]
      else config;
    addFreeformType = config:
      if m ? freeformType
      then
        mkMerge [
          config
          {_module.freeformType = m.freeformType;}
        ]
      else config;
  in
    if m ? config || m ? options
    then let
      badAttrs = removeAttrs m [
        "_class"
        "_file"
        "key"
        "disabledModules"
        "imports"
        "options"
        "config"
        "meta"
        "freeformType"
      ];
    in
      if badAttrs != {}
      then throw "Module `${key}' has an unsupported attribute `${head (attrNames badAttrs)}'. This is caused by introducing a top-level `config' or `options' attribute. Add configuration attributes immediately on the top level instead, or move all of them (namely: ${toString (attrNames badAttrs)}) into the explicit `config' attribute."
      else {
        _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.imports or [];
        options = m.options or {};
        config = addFreeformType (addMeta (m.config or {}));
      }
    else
      # shorthand syntax
      throwIfNot (isAttrs m) "module ${file} (${key}) does not look like a module." {
        _file = toString m._file or file;
        _class = m._class or null;
        key = toString m.key or key;
        disabledModules = m.disabledModules or [];
        imports = m.require or [] ++ m.imports or [];
        options = {};
        config = addFreeformType (
          removeAttrs m [
            "_class"
            "_file"
            "key"
            "disabledModules"
            "require"
            "imports"
            "freeformType"
          ]
        );
      }
